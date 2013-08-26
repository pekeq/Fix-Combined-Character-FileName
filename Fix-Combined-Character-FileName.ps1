<#
.SYNOPSIS
ファイル名、ディレクトリ名のUNICODE結合文字を、普通の１文字に変換する

.DESCRIPTION
ファイル名、ディレクトリ名のUNICODE結合文字になっている部分を、普通の１文字に変換する。
例えば、「か + ゛(濁点記号)」を、「が」に変換する。

Macは、ファイル名をUNICODE結合文字で保存するが、Windowsは、普通の１文字で保存するので、
MacからWindowsに、USBメモリーでファイルをコピーした際など、MacとWindowsのファイル交換時に
問題が生じる。

Macからファイルをコピーしてきた後で、このスクリプトを動かして、ファイル名をWindowsの
一般的な形式に変換しておくと、後々トラブルになりにくい。

.PARAMETER Path
変換対象のパス名。このPath以下の全ファイル、ディレクトリに対して処理を実行する。

.PARAMETER Rename
実際にファイル名をリネームするかどうか。

.PARAMETER Confirm
RENコマンドを実行する前に確認するかどうか。

.LINK
https://gist.github.com/pekeq/6182948
#>

# このファイルはSJISで保存してください

Param (
	[String]$Path = ".",
	[Switch]$Rename,
	[Switch]$Confirm
)

# 文字列をUNICODE正規化する
# http://stackoverflow.com/questions/7836670/how-remove-accents-in-powershell/7840951#7840951
function NormalizeString {
	Param (
		[String]$orig = [String]::Empty
	)

	$norm = $orig.Normalize([System.text.NormalizationForm]::FormC)
	$sb = New-Object Text.StringBuilder
	$nsm = [Globalization.UnicodeCategory]::NonSpacingMark;
	$norm.ToCharArray() | ForEach-Object {
		if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($_) -ne $nsm) {
			[void]$sb.Append($_)
		}
	}
	$sb.ToString()
}

function NormalizeFilename {
	Param (
		[Boolean]$Rename,
		[Boolean]$Confirm
	)

	# http://stackoverflow.com/questions/9526455/how-can-i-control-the-order-of-processing-items-in-from-get-childitem-recurse/9526935#9526935
	$input | Sort-Object -Property @{ Expression = {$_.FullName.Split('\').Count} } -Desc | ForEach-Object {
		$path = $_.FullName
		$orig = Split-Path $path -Leaf
		$norm = NormalizeString $orig
		
		if ($orig.Length -ne $norm.Length) {
			Write-Output $path

			if ($Rename -eq $True) {
				$dest = Join-Path (Split-Path $path -Parent) $norm
				if ($Confirm -eq $True) {
					Rename-Item $path $dest -Confirm
				} else {
					Rename-Item $path $dest
				}
			}
		}
	}
}


Get-ChildItem $Path -Recurse -Force -Directory | NormalizeFilename $Rename $Confirm
Get-ChildItem $Path -Recurse -Force -File | NormalizeFilename $Rename $Confirm
