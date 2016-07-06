##Htmlアプリケーションを書く

Htmlの関数を使いHtmlを書きました。

次に、ある程度の機能や画面を総合した「アプリケーション」（またはコンポーネント）を書く方法を説明します。

HtmlパッケージのHtml.Appモジュールの関数を使います。

以下はテキストフィールドに入力すると、文字の部分がリアルタイムに画面に出て、
エンターキーを押すと、そのフィールド上にリストで表示されていく、というよくわからない例です。

```hs

import Html exposing (Html,div,input,text,li,Attribute)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (on,keyCode,onInput)
import Html.Attributes exposing (type',value)
import Json.Decode as Json

main : Program Never
main =
  beginnerProgram { model = model, view = view, update = update }

type Msg = Input String | Fail | Enter

type alias Model ={list : List String, value : String}

model : Model
model = {list=[],value=""}


-----Update

update : Msg -> Model -> Model
update msg ({list,value} as model) =
  case msg of
    Input str -> {model | value = str}
    Enter -> {model | list = list ++ [value]
                    , value = ""}
    Fail -> model


---view

view {list,value} =
  div []
    [ listStr list
    , yourName value
    , textField value]


listStr model =
  let toList a = li [] [text a ]
  in div [] <| List.map toList model

yourName value =
  div [] [text <| "こんにちは　" ++ value ++ "　さん！"]

textField v =
  input [ type' "text"
        , onInput Input
        , value v
        , onEnter Fail Enter ] []


onEnter : msg -> msg -> Attribute msg
onEnter fail success =
  let
    tagger code =
      if code == 13 then success
      else fail
  in
    on "keyup" (Json.map tagger keyCode)

```

エントリポイントを見てみます。
Html.AppのbeginnerProgramという関数を使っています。

```
import Html.App exposing (beginnerProgram)

main : Program Never
main =
  beginnerProgram { model = model, view = view, update = update }

```

beginnerProgram 関数は引数にmodel、view、update関数をとります。
modelは状態の初期値、
viewは状態を画面に出す関数、
updateは(画面をクリックするなどして)イベントが起きた時の処理を書きます。

これらの関数を用意します。（とくに処理などがなければ、そのまま返すだけの関数でよいです。）

Html.Appにある関数は、Elmアーキテクチャという考え方にそっています。

このmodel、view、updateというapiでモジュール化して分割しよう。というのがElmアーキテクチャという構造化手法の基本形になります。

すこしコードを例に見てみます。
おおまかには、ユーザーの操作でviewでイベントが起きる→updateでそのイベント毎の処理をする→また画面に表示する→最初に戻る、という流れになってます。


###Msg

```hs
type Msg = Input String | Fail | Enter
```

この部分ではMsg（Message）というアプリケーション内で起こるイベントの型を定義しています。（構文Union Typeで）
名前はたぶん何でもいいんですが、Elmアーキテクチャという考え方で統一されているので可読性などから、Msgとしています。以降のmodelやviewも同様です。

上記例では、入力時の文字列　| 失敗 | エンターキー押した時、という感じです。


###Model

Modelでアプリケーション中の状態に当たる部分を定義します。

```hs
type alias Model ={list : List String, value : String}

model : Model
model = {list=[],value=""}

```

{list : 文字が並ぶ部分の状態、value　: text inputの状態}
を定義しています。（レコード表記という構文で）

model=は初期値を設定しています。

###update

```hs
update : Msg -> Model -> Model
update msg ({list,value} as model) =
  case msg of
    Input str -> {model | value = str}
    Enter -> {model | list = list ++ [value]
                    , value = ""}
    Fail -> model
```

update関数で、定義したMsgが起きた時の動作を定義します。（構文はパターンマッチとcase式）
Massage(イベント)とModelを受け取って新しいModelを返します。永続データ構造です。（構文はレコード表記）

update関数内だけでしかmodel(状態)を変更することは出来ません。

###view

```
---view

```

view関数でmodel(状態)を画面に表示します。


##Elmアーキテクチャ

ElmアーキテクチャとはElm言語上での構造化を行うときの手法、考え方、書き方指南のようなものです。
こちらのドキュメントが元になります。https://github.com/evancz/elm-architecture-tutorial

ある程度の機能のモジュール、コンポーネントを作成したら、init、model、view、update、Msg、Modelのような関数、型にわけ公開します。
このように公開すると、Elmの機能を使い木構造的な階層に構成することが出来ます。

```parentConponent.elm
--親を作るのに子を使っている例


import ChaildConponent1
import ChaildConponent2

type alias Model = {...
                   , content1 :: ChaildConponent1.Model
                   , content2 :: ChaildConponent2.Model
                   }  

type Msg = ...
            | Hoge ChaildConponent1.Msg
            | Huga ChaildConponent2.Msg

```


そして一番親の関数と型を、用意されているHtml.AppのbeginnerProgram関数や、program関数に渡します。（一番上の層まで同じ構造になります。）

新しいモジュールを作るときや、他者が作ったモジュールを使って新しいアプリケーションを作るとき、容易にスケールさせることが出来ます。


メモ：ElmアーキテクチャはElm内だけにとどまらず、ReduxやCycle.jsから参照されています。
Elm言語はv0.16以前はSignal（FRP）を使って仮想DOMで描画するので、Elm＋ElmアーキテクチャはReduxやCycle.jsと同じでした。
今のv0.17からはSignal（FRP）はなくなり、Cmd/Sub（Actor）という概念になりましたが、Elmアーキテクチャは健在でより記述が簡単になりました。

###２つのパターン
Elmアーキテクチャには２つのバージョンが有り、それぞれbeginnerProgram関数とprogram関数に対応しています。

一つは基本形で、以下の様な関数、型を用意します。
シンプルでわかりやすいのでまずこちらで慣れるといいと思います。

```hs
type alias Model = ...
type Msg = ...

model : model
view : model -> Html msg
update : msg -> model -> model

```

もう一つはCmd/Sub(旧Effects)が入ったバージョンです。
Cmd/Subとは（例えばDBアクセスのような）非同期処理や並行処理や副作用処理を表しています。
Cmd/Subバージョンは基本バージョンを含むので、実用的なアプリケーションならこちらを採用します。

```hs
type alias Model = ...
type Msg = ...

init : (model, Cmd msg)
update : msg -> model -> (model, Cmd msg)
view : model -> Html msg
subscriptions : model -> Sub msg

```

modelがinitに代わり、initとupdateが、ModelとCmd Msgをタプルで返すようになっています。
Cmdは「Elm内から起きる」非同期、副作用処理を表しています。（initにあるのはElmがロードされたタイミングに、updateにあるのは何かイベントが起きたタイミングに実行されます。）

Cmd/SubのSubとは、「外からElm内に」入ってくるものを指します。一定のタイミング（Time）であったり、マウスなどのインターフェイスの入力であったりします。
アプリケーション全体に影響するので、program関数に入れます。
