#elm-lang/html(2)


##main関数の型

Elmのエントリポイント（main関数）の型は、`Svg`や`Html`などの画面を表現する型か、`Program Never Model Msg`という型になります。

`Program Never Model Msg`という型はアプリケーション全体を表した特殊な型です。

この型を作る基本の関数がbeginnerProgram、program、programWithFlagsです。

##beginnerProgram

使用例

```elm
import Html exposing (beginnerProgram)

main : Program Never Int Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }  
```

beginnerProgram 関数は引数にmodel、view、update関数をとります。（とくに処理などがなければ、そのまま返すだけの関数でよいです。）

```elm
model : Model
view : Model -> Html a
update : Msg -> Model -> Model
```

*  modelはアプリケーションの状態の初期値、
*  viewはアプリケーション状態によって画面を作る関数、
*  updateは(画面をクリックするなどして)イベントが起きた時の処理を書きます。


##program

program関数です。非同期処理や外部からの入力に対応しています。

使用例

```elm
main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }
```

initやupdateがCmdを返すようになっていて、subscriptionsという関数が必要になります。


##programWithFlags

programWithFlagsは、Elmが起動する時にJSから初期値を受け取る場合に使います。

JSから渡されたデータをElmで画面に表示したりとか、サーバーから値をElmに設定しておく、といったことが出来ます。

JS側

JS側から、Elmを起動する際にJSオブジェクトを渡します。

```:html
 ..
<script type="text/javascript", src="javascripts/App.js">   //ElmをJSコンパイルして出来たJSを読み込む。
 ..

 var app = Elm.Main.fullscreen({JSオブジェクト});            //JSオブジェクトをElmに渡す。

```

JSオブジェクトの渡し方は起動モードに寄って違います。fullscreen以外のモードの場合では、`embed(node,JSオブジェクト)`、`worker(JSオブジェクト)`とします。


Elm側

Elm側で`programWithFlags`を使います。

するとinit関数の引数で、JS側の値をとることができます。

```elm
module Main exposing (..)         --モジュールに名前を付ける

import Html exposing (programWithFlags)

main =
  programWithFlags {init = init , update = update , view = view ,subscriptions = subscriptions}

init : List -> (Model,Cmd a)     ---JS側から渡される値が引数に。型を書く必要がある。
init list = {data = list } ! []
```

この時にElmとJSの型が合わない場合はエラーとなりElmは起動しません。型の対応はPortのページにある表を参考にしてください。
