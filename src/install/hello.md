##Hello World

Hello Worldで、Elmの最初のコンパイルまでの過程をゆっくり解説したいと思います。

以下のステップが必要です。
* Hallo Worldのコードを書く
* 必要なライブラリをインストールする。
  - ElmはインストーラにCoreライブラリ（組み込みライブラリ）が含まれていません。パッケージ管理システムでバージョン管理するためです。なので、まずそれをインストールします。
* さらに必要なライブラリをインストール。
 - HelloWorldをブラウザに表示するには、Coreライブラリに含まれていないHtmlライブラリを使うので、elm-packageでインストールします。
* コンパイル。
* ブラウザで開く。


というわけで、まずCoreライブラリをインストールする必要があります。
elm-makeとコマンドを打ちます。

```
elm-make
```

elm-するとコアライブラリをインストールします。

つぎにhtmlライブラリをダウンロードします。

```
elm-package install elm-lang/html -y
```

インストールされましたら、以下のコードをエディタで書いて、hello.elmという名前で保存します。

```
import Html exposing (text)

main = text "Hello World"
```

このファイルをコンパイルします。

```
elm-make hello.elm
```

出来たファイルをブラウザで開きます。
hellow worldが表示されています。
