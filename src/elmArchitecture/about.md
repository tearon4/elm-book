
Elmのmainの型は、Html a かProgram aである必要があります。

Program aは入力や操作ができる画面のあるアプリケーションになります。

これは一般的な汎用プログラミング言語と比べると変わっているところです。他のプログラミング言語では、画面を操るライブラリを用意して、それらを適切に操らなければならず、さらにソースコードが巨大になるならフレームワークを導入したりする必要があります。

ElmではHtml.Appにある関数を使いProgram aを作ります。

Html.Appの関数を使うには、init、update、view、Msg、といった関数を用意する必要があります。

Elmではこれらの関数を用意すると画面を持ったアプリケーションを作れるようになっています。

その考え方がElm Architectureです。

# Elm Architectureとは？

ElmアーキテクチュアとはElmと、Elmで実現する設計や構造化の手法、みたいなのを指します。
例えば、MVCならmodelとviewとControllerを記述するように、Elmではどういう関数を用意して、アプリケーションのソースコードをどう分けて構造化して、それをどう実現するか、みたいな話になります。

初めて提案され、詳しいドキュメントがあるレポジトリがこちらになります。
https://github.com/evancz/elm-architecture-tutorial

とりあえず、Elm側がこういったもの用意してるので、使う側はどういったものを用意するのかというのを説明します。

##二種類のElm-Architecture

Elm-Architectureには発案初期のバージョンと現在の二種類のバージョンがあります。

Elmではそれぞれ用に関数を用意しています。(beginerProgram、program)

一つは今ではビギナー用になっている、Elm-Architecture初期のバージョンです。
model、view、update、Msgという関数と型を用意する必要があります。

もう一つは、Cmd/Subがついた現行のバージョンです。内外からの入力（マウスなど）や非同期処理を網羅したバージョンなのです。
こちらではmodel、update、view、cmd、subscriptions、Msgを用意します。

まずビギナーバージョンでなれると良いでしょう。
画面にボタンなどのインターフェースがあるアプリケーションが作れます。

そしてCmd/Subバージョンは、ビギナーバージョンを内包しているので、慣れた後は普段からこちらを使います。


##実行される順番

流れについて確認しておきます。

まずElmが起動してアプリケーション全体を構築するとき、アプリケーションに初期値をセットします。このとき`init`関数が使われます。次に画面が構築された後、利用者が画面を操作します。このとき画面から起きたアクションや値がMsgになって`update`送られます。`update`関数が起動し、状態を更新し、新しい状態を返します。これは画面を操作されるたびに実行されます。

以上が基本の流れになります。


次に、model、update、view、cmd、subscriptions、Msgそれぞれについて解説します。


##Model

Modelとは、作るアプリケーションの状態の定義と、初期化関数をさします。

```elm
type alias Model = Int  --Model型を定義

model : Model          --初期化関数
model = 0
```

Pub/Subバージョンでは初期化の関数は以下の様にCmd型を返すようにする必要があります。Cmd型は後で解説します。

```elm
init : (Model ,Cmd Msg)
```

Model型の定義は、画面にカウンターを表示するなら数字型を、タイトルを表示するならString型を、画面上で動くものがあるなら、その場所の情報も必要かもしれません。そうやってアプリケーションで必要な値を定義していきます。

```elm
type alias Model = { counter : Int
                   , title : String
                   , position : Position
```

そしてModelを作る初期化用の関数を作ります。

```elm
init : Model
init = {counter = 0,title = "",position = {x =0,y=0}}
```

##Msg

Msgは、ユーザーの操作を定義したものです。

```elm
type Msg = TextInput String | MouseMove Position | Click | ...
```

（型の定義方法は、「新しい型を定義する」のページで解説しています。）

上記の例ではTextInputやMouseMoveやClickが型構築子というものにあたります。TextInputを見ると横にStringがあるので、この型はTetxtInput "hello"とか、TextInput "hogehoge"とかになることが予想されます。つまりこの型構築子がコンテナになって、操作自体と入力された値を画面側からアプリ内部へ送る役割を担います。

Html.Eventモジュールには、型構築を受けとる関数があります。

##update

updateは、ユーザーの操作があった時に自動で実行される関数です。

```elm
update : Msg -> Model -> Model
update msg model = model
```

(Cmd/Subバージョンでは以下のような型になる）

```elm
update : Msg -> Model -> (Model,Cmd Msg)
update msg model = model ! []
```

update関数の中ではまずMsgによって処理を振り分けることが多いです。

```elm
update : Msg -> Model -> Model
update msg model =
  case msg of
    TextInput str ->
    Click ->
    _ ->
```

updateの型は、`Msg -> Model -> Model`なので、それぞれの処理がModelを返すようにします。
レコード表記が有効です。

```elm
update : Msg -> Model -> Model
update msg model =
  case msg of
    TextInput str -> {model | titel = str}
    Click -> aresite model |> koresite |> soresite
    _ ->
```

##View

viewとはモデルを受け取り画面を作る関数です。

例

```elm
view : Model -> Html a
view model = div [] [text model.titel]

```

このとき画面上でクリックや入力のイベントがあるなら、Html.Eventの関数などを使いHtmlに設定します。

```elm
view : Model -> Html a
view model = div [onClick Click] [text model.titel]

```

これでMsg型の型構築子がコンテナになり、イベントが発火した時はupdate関数に必要な情報が渡ります。

Eventに関してはHtmlを参照してください。

##ビギナーバージョン

model、view、updateを記述すれば、後はHtml.Appの関数に渡すだけです。

```elm
import Html.App exposing (beginerProgram)

main = beginerProgram {model = init , view = view , update = update}

```

これでElmで動くアプリケーションが作れます。

次のページに続きます。
