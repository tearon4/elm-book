
##Elmで動くアプリケーションを作るには？

Elmの`main`の型は、`Html a`か`Program a`である必要があります。

`Html a`型は静的な画面になり、`Program a`型はさらに入力や操作ができるアプリケーションになります。

Elmではelm-lang/htmlパッケージのHtml.Appモジュールにある関数を使い`Program a`型を作ります。

Html.Appの関数を使うには、init、update、view、Msg、といった関数を用意する必要があります。

Elmではこれらの関数を用意すると画面を持ったアプリケーションを作れるようになっています。それらの関数の役割がElm Architectureという考え方で決められています。

#Elm Architectureとは？

Elmでは、Elm ArchitectureというパラダイムでGUIアプリケーションを記述します。
パラダイムとは設計や構造化の手法、書き方みたいなのを指します。
過去にあったパラダイムとして、ゲームで使われるメインループ方式や、Webフレームワークにも採用されたMVC、MVC2、マイクロソフトが作ったMVVMといったものがあります。

初めて提案され、詳しいドキュメントがあるレポジトリがこちらになります。
https://github.com/evancz/elm-architecture-tutorial


##二種類のElm-Architecture

Elm-Architectureには二種類のバージョンがあります。そしてElmはそれぞれ用に関数を用意しています。(beginerProgram、program)

これは最初に大きなアプリケーションを構成して書くための方法としてElm製作者のEvanが発案したときのバージョンと、その後Elmが発展して非同期処理について固まった後に、それに対応して生まれた現行のバージョンと発表タイミングが２つに別れたためです。

初期を初期バージョン、現行をCmd/Subバージョンと呼ぶことにします。

余談：余談ですが、reduxやcycle.jsといったフレームワークの作者がElm-Architectureを参考にした時、つまり世に広まった時は、Cmd/Subバージョンが確立する前でした、なので各フレームワークは非同期処理についてばらつきがあるようです。

初期のバージョンは今ではビギナー用になっています。
model、view、update、Msgという関数と型を用意する必要があります。

Cmd/Subがついた現行のバージョンは、内外からの入出力（マウスなど）や非同期処理、副作用を網羅したものです。
こちらではmodel、update、view、cmd、subscriptions、Msgを用意します。

まずビギナーバージョンで慣れると良いでしょう。
画面にボタンなどのインターフェースがあるアプリケーションが作れます。

Cmd/Subバージョンは、ビギナーバージョンを内包しているので、慣れた後はこちらを使ってみましょう。

##Hello World

Elm-Architecture（現行のバージョン）で書かれた、Helloと表示するだけで何もしないコードは以下のようになります。
（下記のupdate関数のように、なにもしないならそのまま返す関数でOKです。）

```elm
[snippet](../sample/test.elm)
```


##実行される順番

各関数の実行順ついて確認しておきます。

まずElmが起動してアプリケーション全体を構築するとき、アプリケーションに初期値をセットします。このとき`init`関数が使われます。次に画面が構築された後、利用者が画面を操作します。このとき画面から起きたアクションや値が`Msg`になって`update`に送られます。`update`関数は状態を更新し新しい状態を返します。その状態が`view`に渡され画面が表示されます。

以上が基本の流れになります。

次に、用意するそれぞれの型や関数(model、update、view、cmd、subscriptions、Msg)について個別に見ていきます。

##Model

Modelとは、作るアプリケーションの状態の定義(Model型)と、初期化関数をさします。
状態というのは、アプリケーションの中で時間によって変化する部分をさします。

```elm
type alias Model = Int  --Model型を定義

model : Model          --初期化関数
model = 0
```

Pub/Subバージョンでは初期化の関数は以下の様にCmd型を返すようにする必要があります。Cmd型は後で解説します。

```elm
init : (Model ,Cmd Msg)
```

画面にカウンターを表示するなら数字型の値を、タイトルを表示するならString型を、画面上で動くものがあるなら、そのxy座標が必要かもしれません。そうやってアプリケーションで必要な値を定義していきます。

```elm
type alias Model = { counter : Int
                   , title : String
                   , position : Position

init : Model
init = {counter = 0,title = "",position = {x =0,y=0}}
```

##Msg

Msgというのはメッセージの略で、アプリケーションに起こりえるイベントを定義した型です。（例えばユーザーの操作など）

```elm
type Msg = TextInput String | MouseMove Position | Click | ...
```

（型の定義方法は、「新しい型を定義する」のページで解説しています。）

上記の例では`TextInput`や`MouseMove`や`Click`が**データ構築子**というものにあたります。`TextInput`を見ると横に`String`があるので、この型は`TetxtInput "hello"`とか、`TextInput "hogehoge"`といった入力になります。このMsgのデータ構築子がコンテナのようになって、操作と入力された値を画面側からアプリ内部へ運びます。

##update

updateは、Msgがあった時に自動で実行される関数です。

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
    TextInput str ->    --- Text入力があった場合の処理
    Click ->
    _ ->
```

updateの型は、`Msg -> Model -> Model`なので、入力(`Msg`)があって->今の状態(`Model`)それらを使って処理を行って、結果新たなアプリケーションの状態(`Model`)を返すということを表現しています。


```elm
update : Msg -> Model -> Model
update msg model =
  case msg of
    TextInput str -> {model | titel = str}    --titleが変化したmodelを返す。
    Click -> aresite model |> koresite |> soresite
    _ ->
```

##View

viewとはモデルを受け取り画面を作る関数です。ここにHTMLやCSSを書きます。

例

```elm
view : Model -> Html a
view model = div [] [text model.titel]  --titleデータを表示しています。

```

クリックや入力の出来る画面を作りたいなら、HtmlやHtml.Eventの関数を使います。

```elm
view : Model -> Html a
view model = div [onClick Click] [text model.titel]

```

ここでonClick関数にMsg型のデータ構築子を渡しています。Msg型のデータ構築子がコンテナになり、イベントが発火した時はupdate関数に必要な情報が渡ります。


##一旦のまとめ。ビギナーバージョン

ここまでの説明でビギナーバージョンのElm-Architectureを書くことが出来ます。
beginerProgram関数を使い、model、view、updateを記述すれば、後は関数に渡すだけです。

```elm
import Html.App exposing (beginerProgram)

main = beginerProgram {model = init , view = view , update = update}

```

これで画面にボタンや、入力をつくり、動くアプリケーションが作れます。

ビギナーバージョンで慣れたら、さらにマウスからの入力や、処理の途中からhttp通信を行ったり、といった非同期＋副作用がある処理を加えた、Cmd/Subバージョンを見てみましょう。
