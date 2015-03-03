## 名前
Fix-Combined-Character-FileName.ps1

## 概要
ファイル名、ディレクトリ名のUNICODE結合文字を、普通の１文字に変換する


## 構文
    Fix-Combined-Character-FileName.ps1 [[-Path] <String>] [-Rename] [-Confirm] [<CommonParameters>]


## 説明
ファイル名、ディレクトリ名のUNICODE結合文字になっている部分を、普通の１文字に変換する。
例えば、「か + ゛(濁点記号)」を、「が」に変換する。

Macは、ファイル名をUNICODE結合文字で保存するが、Windowsは、普通の１文字で保存するので、MacからWindowsに、USBメモリーでファイルをコピーした際など、MacとWindowsのファイル交換時に問題が生じる。

Macからファイルをコピーしてきた後で、このスクリプトを動かして、ファイル名をWindowsの一般的な形式に変換しておくと、後々トラブルになりにくい。


## パラメーター

|オプション|説明|
|---------|----|
|-Path &lt;String&gt;|変換対象のパス名。このPath以下の全ファイル、ディレクトリに対して処理を実行する。|
|-Rename [&lt;SwitchParameter&gt;]|実際にファイル名をリネームするかどうか。|
|-Confirm [&lt;SwitchParameter&gt;]|RENコマンドを実行する前に確認するかどうか。|


## 利用上の注意

未署名のPowerShellスクリプトなので、実行に際しては未署名のスクリプトでも実行できるようにする必要があります。

    例：未署名のスクリプトでも実行できるPowerShellを起動する
    PowerShell.exe -ExecutionPolicy Unrestricted


## Author
Hideo Matsumoto &lt;hideo-m@pekeq.com&gt;


## License
MIT
