
Elmでアプリケーションを書くには、Html.Appにある関数を使います。これらの関数は、Elm-Architecture（Elmアーキテクチャ）と呼ばれる考え方に基づいています。

ここではHtml.Appの使い方の前に、Elm-Architectureについて解説します。ですが、今も発展途中なので後々解釈が変わるかもしれないので注意です。

# Elm Architectureとは？

ElmアーキテクチュアとはElmの言語的な能力と、採用している構造化の手法を指します。

構造化手法とは、ソースコードをどう分けるか、（またそれを行えるように後ろにどんな技術があるか）という話です。


Elmの構造化手法は、フラクタル的でスケールしますし、合理的でわかりやすいものです。

初めて提案され、その後も詳しいドキュメントがあるレポジトリがこちらです。ですのでこれがElm-Architectureといえます。
https://github.com/evancz/elm-architecture-tutorial

またElmの外からも参照されていて、reduxが参考にしたり、cycle.jsの製作者が言及したりしています。


##Elm-Architecture

Elm-Architectureには大きく二種類あります。
実際に動くものを書くのは次ページで行います。

一つはビギナーバージョンと呼ばれるもので、
model、view、update、Msgに分けます。

もう一つは、Cmd/Subバージョンと呼ばれるもので、
model、update、view、cmd、subscriptions、Msgに分けます。

まずビギナーバージョンでなれると良いでしょう。
画面にボタンなどのインターフェースがあるアプリケーションが作れます。

Cmd/Subバージョンは、さらに外からの入力（マウスなど）や非同期処理を網羅したバージョンです。ビギナーバージョンを内包しているので、こちらが基本的に使うものになります。

model、update、view、cmd、subscriptions、Msgそれぞれと実行される順番について解説します。

Model

Modelとは、作るアプリケーションの状態の定義と、初期値をさします。

```
type alias Model = Int

model : Model
model = 0
```

Pub/Subバージョンでは初期化の関数は以下の様にCmd型を返すようにする必要があります。Cmd型は後で解説します。

```
init : (Model ,Cmd Msg)
```


Modelは、画面にカウンターを表示するなら、数字を持たなければならないし、タイトルを表示するならString型を付けます。画面上で動くものがあるなら、その場所も必要かもしれません。そうやってすべて書いていきます。

```
type alias Model = { counter : Int
                   , title : String
                   , position : Position
init : Model
init = {counter = 0,title = "",position = {x =0,y=0}}
```

##update

updateは、Msgがあった時自動で実行される関数で、アプリケーションの処理を表します。

```

update : Msg -> Model -> Model
update msg model = model


```

##Msg


##Cmd


##Sub
