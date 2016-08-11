##Hello World

「Hello World」と表示するプログラムを作ります。
ここでElmのコンパイルまでの過程を解説したいと思います。

以下のステップが必要です。（elm-packageなどのツールの説明はセクションで行います。）

* Hallo Worldのコードを書く
* 必要なライブラリをインストールする。
 - ブラウザに表示するには、Coreライブラリに含まれていない「Htmlライブラリ」を使うので、elm-packageを使いインストールする必要があります。
* コンパイル。
* ブラウザで開く。


以下のコードをエディタで書いて、hello.elmという名前で保存します。


```elm
import Html exposing (text)

main = text "Hello World"
```

次にhtmlライブラリをインストールします。コマンドプロンプト（またはターミナル）を開き以下のコマンドを打ちます。

```
elm-package install elm-lang/html -y
```

成功したらelm-package.jsonというファイルが作られます。

hello.elmファイルをコンパイルします。

```
elm-make hello.elm
```

エラー無くコンパイルが出来たら、index.htmlファイルが作られます。

index.htmlファイルをブラウザで開くと、hellow worldが表示されていると思います！

さらにElmを知りたくなったら、Elm構文へ進んでみてください。
