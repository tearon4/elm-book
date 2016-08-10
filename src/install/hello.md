##Hello World

「Hello World」と表示するプログラムを作ります。
ここでElmのコンパイルまでの過程を解説したいと思います。

以下のステップが必要です。（elm-packageなどのツールの説明は次のページで行います。）

* Hallo Worldのコードを書く
* 必要なライブラリをインストールする。
 - HelloWorldをブラウザに表示するには、Coreライブラリに含まれていないHtmlライブラリを使うので、elm-packageでインストールします。
* コンパイル。
* ブラウザで開く。


以下のコードをエディタで書いて、hello.elmという名前で保存します。


```
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

なにかエラーが起きたら、「よくみるエラー」等を参考に解決してみてください。

エラー無くコンパイルが出生きたら、index.htmlファイルが作られます。
index.htmlファイルをブラウザで開くと、hellow worldが表示されていると思います！

さらにElmを知りたくなったら、Elm構文へ進んでみてください。
