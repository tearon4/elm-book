ボツ

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
