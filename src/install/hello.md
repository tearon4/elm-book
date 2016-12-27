#Hello World！

Elmのインストールが済みましたら、「Hello World」と表示するプログラムを作ります。
ここでElmのコンパイルまでの過程を解説したいと思います。

以下のステップを説明します。

1. Hallo Worldのコードを書く
2. 必要なライブラリをインストールする。
3. コンパイル。
4. ブラウザで開く。

開発用のフォルダを作り、移動しておいてください。

```bash
mkdir myFirstElm
cd myFirstElm
```

###ソースコードを書く

サンプルとして、以下のコードをhello.elmという名前で保存します。


```elm
import Html exposing (text)

main =
  text "Hello World"
```

###必要なパッケージをインストールする。

ElmでHTMLを書いて画面に表示するには、Elm Packagesで公開されている「elm-lang/html」パッケージの`Html`を使います。
このパッケージはelm-packageを使うことでインストールする事ができます。

コマンドプロンプト（またはターミナル）を開き以下のコマンドを打ちます。

```bash
elm package install elm-lang/html -y
```

成功したらパッケージの入ったフォルダと、依存パッケージ情報が書き込まれたelm-package.jsonというファイルが作成されます。

###コンパイル

hello.elmファイルをコンパイルします。

```bash
elm make hello.elm
```

エラー無くコンパイルが出来たら、hello.elmと同じフォルダにindex.htmlというファイルが作られたと思います。

###ブラウザで開く。

index.htmlファイルをブラウザで開くと、Hello Worldと表示されています！
これであなたもElmで初めてブラウザアプリケーションを作成しました！

さらにElmでどんなものが作れるか気になった方は、Elm公式ページのSample集を見てみてください。
またElmをより書けるようになるには、Elmの構文ページへ進んでみてください。


##おまけ

Elmをインストールしたときに同封されるelm-reactorを使うと、さらに簡単にElmを試すことが出来ます。

起動コマンド

```
elm-reactor
```

起動した後、`http://localhost:8000/`にアクセスします。そして、hello.elmファイルをクリックすると、コンパイルが始まり画面で確認できます。hello.elmを編集して再度コンパイルするには、ブラウザの再読込を押します。
