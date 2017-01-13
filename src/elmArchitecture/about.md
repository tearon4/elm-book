
##Elmで状態のある動作するアプリケーションを作るには？

Elmの`main`の型は、SvgやHtmlなどの画面を表現する型か、`Program`型である必要があります。

`Html`型は静的な画面になり、`Program`型はさらに入力や操作ができるアプリケーションになります。

Elmではelm-lang/htmlパッケージのHtmlモジュールにあるprogram、beginerProgram、programWithFlags関数を使い`Program`型を作ります。

そしてそれらの関数は、The Elm Architectureというアプリケーションアーキテクチャに基いて使用します。

#The Elm Architectureとは？

Elmでは、The Elm ArchitectureというアプリケーションアーキテクチャでGUIアプリケーションを記述します。

アプリケーションアーキテクチャとは、大きなアプリケーションを構成して書くための設計や構造化の手法みたいなのを指します。他のアーキテクチャには、ゲームで使われる「メインループ」方式や、Webフレームワークにも採用された「MVC」、「MVC2」や、マイクロソフトが作った「MVVM」といったものがあります。

The Elm Architectureが初めて提案され、詳しいドキュメントがあるレポジトリがこちらになります。
https://github.com/evancz/elm-architecture-tutorial


##二種類のThe Elm Architecture

The Elm Architectureには初期のバージョンと、非同期について考慮された現行のバージョンの２つがあります。（初期のバージョンもbeginerProgram関数で使えます）

初期を初期バージョン、現行をCmd/Subバージョンと呼ぶことにします。

初期バージョンは今ではビギナー用になっています。
model、view、update、Msgという関数と型を用意する必要があります。

現行のCmd/Subバージョンは、外からの入出力（マウスなど）や非同期処理、副作用を網羅したものです。
こちらではmodel、update、view、cmd、subscriptions、Msgを用意します。

まずビギナーバージョンで慣れると良いでしょう。
画面にボタンなどのインターフェースがあるアプリケーションが作れます。

Cmd/Subバージョンは、ビギナーバージョンを内包しているので、慣れた後はこちらを使ってみましょう。

余談：余談ですが、reduxやcycle.jsといったフレームワークの作者がThe Elm Architectureを参考にして世に広まった時は、Cmd/Subバージョンが確立する前でした、なので各フレームワークは非同期処理についてばらつきがあるようです。


##Hello World

The Elm Architecture（Cmd/Subバージョン）で書かれた、Helloと表示するだけのコードは以下のようになります。

```elm
module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL

type alias Model = Int

type Msg = Hello

-- APP

main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


init : (Model,Cmd Msg)
init =
    0 ! []

update : Msg -> Model -> (Model,Cmd Msg)
update msg model =
    model ! []

view : Model -> Html Msg
view model =
    text "hello"
```


##init、update、view関数

`init`、`update`、`view`関数の実行のされかたについて確認しておきます。

初めてElmが起動してアプリケーション全体を構築するときに、`init`関数でアプリケーションの初期値が設定されます。  
アプリケーションが構築された後、利用者が画面を操作します。操作時画面から起きたアクションや値が`Msg`になって`update`に送られます。`update`関数は状態を更新し新しい状態を返します。  
アプリケーションの状態は常に`view`関数で画面になり、ブラウザに表示されます。

以上が動作の主幹部分です。Cmd/Subバージョンではそれに非同期な動作が加わります。Cmd/Subのページで解説しています。

##Model、Msg、Update、View

用意するそれぞれの型や関数(model、update、view、cmd、subscriptions、Msg)について個別に見ていきます。

##Model

Modelとは、作るアプリケーションの状態の定義(Model型)と、初期化関数を指します。
状態というのは、アプリケーションの中で時間によって変化する部分を指します。

```elm
type alias Model = Int  --Model型を定義

model : Model          --初期化関数
model = 0
```

Pub/Subバージョンでは初期化の関数は以下の様にCmd型を返すようにする必要があります。

```elm
init : (Model ,Cmd Msg)
```

アプリケーションの状態を考えてみます。画面にカウンターを表示するなら数字型の値を、タイトルを表示するならString型を、画面上で動くものがあるなら、そのxy座標が必要かもしれません。そうやってアプリケーションで必要な値を定義していきます。

```elm
type alias Model = { counter : Int
                   , title : String
                   , position : Position

init : Model
init = { counter = 0
       , title = ""
       , position = {x = 0, y = 0 }}
```

##Msg

Msgというのはメッセージの略で、`Msg`型という名前でアプリケーションに起こりえるイベントを定義します。イベントとは例えばユーザーの操作などが当たります。

```elm
type Msg = TextInput String | MouseMove Position | Click | ...
```

上記の例では、アプリケーション内に、`TextInput`や`MouseMove`や`Click`といったイベントが起こるという定義になっています。

`TextInput`や`MouseMove`や`Click`がデータ構築子（コンストラクタ）というものにあたります。

`TextInput`を見ると横に`String`型とあります。`TextInput "hello"`とか、`TextInput "hogehoge"`といったように、Msgのデータ構築子は入力された値をコンテナのようにアプリ内部へ運ぶ役割も担います。

##Update

`update`関数は、Msgがあった時に実行される関数です。

```elm
update : Msg -> Model -> Model
update msg model = model
```

(Cmd/Subバージョンでは以下のような型になる）

```elm
update : Msg -> Model -> (Model,Cmd Msg)
update msg model = model ! []
```

updateは、何かしら入力(`Msg`)があると実行され、今の状態(`Model`)を使って処理を行って、新しい状態(`Model`)を返します。


```elm
update : Msg -> Model -> Model
update msg model =
  case msg of
    TextInput str ->
          {model | title = str}    --titleが変化したmodelを返す。
    Click ->
          aresite model |> koresite |> soresite
    _ ->
```

上記のように、case式を使ってMsgを選別して処理を行います。

##View

`view`関数はモデルを受け取り画面を作る関数です。ここにHTMLやCSSを書きます。

例

```elm
view : Model -> Html a
view model =
  div [] [text model.title]  --titleデータを表示しています。

```

クリックや入力の出来る画面を作りたいなら、HtmlやHtml.Eventの関数を使います。

```elm
view : Model -> Html a
view model =
  div [onClick Click] [text model.title]

```

ここでonClick関数にMsg型のデータ構築子を渡しています。Msg型のデータ構築子がコンテナになり、イベントが発火した時はupdate関数に渡ります。


##一旦のまとめ。ビギナーバージョン

ここまでの説明でビギナーバージョンのThe Elm Architectureを書くことが出来ます。
beginerProgram関数を使い、model、view、updateを記述すれば、後は関数に渡すだけです。

```elm
import Html exposing (beginerProgram)

main =
  beginerProgram {model = init , view = view , update = update}

```

これで画面にボタンや、入力のある、状態のあるアプリケーションが作れます。

ビギナーバージョンで慣れたら、さらにマウスからの入力や、処理の途中からhttp通信を行ったり、といった非同期＋副作用がある処理を加えた、Cmd/Subバージョンを見てみましょう。
