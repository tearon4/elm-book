#Html.App


##Program aとは

Elmのエントリポイント（main）の型は、`Svg`や`Html`などの画面を表現する型か、`Progam a`という型にしなければなりません。

`Program a`を渡せば、何かしらの動作があるアプリケーションになります。
`Program a`という型はアプリケーション全体を表した特殊な型で、Program型をつくるには現状、Html.AppにあるbeginnerProgram、program、programWithFlags関数を使います。これらの関数はThe Elm Architectureという考えにそっています。


##Html.App

###beginnerProgram

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

###program

program関数です。引数に用意するのは、The Elm Architectureの非同期処理や外部からの入力に対応したバージョンです。

```
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

initやupdateがCmdを返すようになっていて、subscriptionsという関数が必要になります。


###programWithFlags

programWithFlagsは、Elmが起動する時、JSから初期値を渡す場合に使います。

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

渡すinit関数をflagsを受けるようにします。

```
init : { userID : String, token : String } -> ...
init flag = ...
```

JS側から初期値を渡します。

```js

// Program { userID : String, token : String }

var app = Elm.MyApp.fullscreen({
    userID: 'Tom',
    token: '12345'
});

// embedの場合

var elm = document.getElementById('elm')
var app = Elm.MyApp.embed(elm,{
    userID: 'Tom',
    token: '12345'})

```
