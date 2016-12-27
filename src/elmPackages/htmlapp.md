#elm-lang/html(2)


##Elmのエントリポイント（main）の型

Elmのエントリポイント（main）の型は、`Svg`や`Html`などの画面を表現する型か、`Program Never Model Msg`という型にしなければなりません。

`Program Never Model Msg`という型はアプリケーション全体を表した特殊な型です。
この型を作る基本の関数がHtmlにあるbeginnerProgram、program、programWithFlagsです。これらの関数はThe Elm Architectureというアプリケーションアーキテクチャにそっています。


##beginnerProgram

使用例

```elm
import Html exposing (beginnerProgram)

main : Program Never Int Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }  
```

beginnerProgram 関数は引数にmodel、view、update関数をとります。（とくに処理などがなければ、そのまま返すだけの関数でよいです。）

*  modelは状態の初期値、
*  viewは状態を画面に出す関数、
*  updateは(画面をクリックするなどして)イベントが起きた時の処理を書きます。


##program

program関数です。非同期処理や外部からの入力に対応したバージョンです。

```elm
program
  : { init : (model, Cmd msg)
    , update : msg -> model -> (model, Cmd msg)
    , subscriptions : model -> Sub msg
    , view : model -> Html msg
    }
  -> Program Never
program app =
  programWithFlags
    { app | init = \_ -> app.init }

```

使用例

```elm
main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }
```

initやupdateがCmdを返すようになっていて、subscriptionsという関数が必要になります。


##programWithFlags

programWithFlagsは、Elmが起動する時にJSから初期値を受け取る場合に使います。

例えば、JSから渡されたデータをElmで画面に表示したりとか、サーバーから値をElmに設定しておく、といったことが出来ます。

```elm
programWithFlags
  : { init : flags -> (model, Cmd msg)
    , update : msg -> model -> (model, Cmd msg)
    , subscriptions : model -> Sub msg
    , view : model -> Html msg
    }
  -> Program flags
programWithFlags =
  VirtualDom.programWithFlags
```

JS側

JS側から、Elmを起動する際にJSオブジェクトを渡します。

```html
 ..
<script type="text/javascript", src="javascripts/App.js">   //ElmをJSコンパイルして出来たJSを読み込む。
 ..

 var app = Elm.Main.fullscreen({JSオブジェクト});            //JSオブジェクトをElmに渡す。
```

fullscreen以外のモードの場合では、`embed(node,JSオブジェクト)`、`worker(JSオブジェクト)`とします。


Elm側

Elm側でprogramWithFlagsを使います。
するとinit関数の引数で、JS側の値をとることができます。

```elm
module Main exposing (..)         --モジュールに名前を付ける

import Html exposing (programWithFlags)

main =
  programWithFlags {init = init , update = update , view = view ,subscriptions = subscriptions}

init : SList -> (Model,Cmd a)     ---JS側から渡される値が引数に。型を書く必要がある。
init list = {data = list } ! []
```

この時にinitに書く型は、Portのページの対応表を参考してください。
ElmとJSの型が合わない場合はエラーとなり、Elmは起動しません。
