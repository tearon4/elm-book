
Cmd/Subバージョンについて見て行きましょう。

#Cmd/Sub

The Elm Architectureで非同期や副作用のある処理を管理する仕組みがCmd/Subです。

このCmd/Subに乗せてElmランタイムに副作用のある概念を渡すと、それらに付随する面倒だったり特有だったりする処理を裏で行って、Elm内に持ち込まないようにしています。
（例えばイベント登録が必要なものだったら、増えないように一つにしてくれたり、通信がエラーになって接続が切れても独立して復旧したり）

##Cmd

Cmdは外にだす命令、コマンドという意味です。

Cmdは主にportとTask型で使います。Task型を実行する関数は以下のようになっています。（Task型の場合は結果を得るために命令を実行するので、結果を受け取るMsgを渡す必要があります）


```elm
perform : (a -> msg) -> Task Never a -> Cmd msg
```

こういった関数で作ったCmdをElmランタイムに実行してもらうためには、最終的にporgram関数の、init関数と、update関数に渡す必要があります。

```elm
init : (Model,Cmd msg)
update : Msg -> Model -> (Model,Cmd msg)

main =
  program { init = init , update = update}
```

init関数で渡した場合は、Modelの初期化が終わって「すぐ」、初期化とほぼ同時に実行されます。アプリケーションの最初に欲しい値をDBやTimeから用意する場合などに使います。
update関数で渡した場合は、update処理の結果時にCmdは実行されます。


##Sub

Subは外から内に非同期にやってくるイベントを表しています。マウスやキーボードの入力などがそれにあたります。

Subはsubscriptions関数でElmランタイムに渡します。

```elm
subscriptions : model -> Sub msg

main =
  program { ... , subscriptions = subscriptions}
```

以下は、マウスの移動入力Sub。マウスが動くたびにマウスのポジションがMsgになってupdateにやって来るようになります。

```elm
type Msg =
       GetPosition

subscriptions : Model -> Sub Msg
subscriptions model =
  Mouse.move GetPosition
```

##CmdとSubに用意されている関数

Cmdと、Subには同じ関数が用意されています。(Cmdだけ(!)演算子がある)

例：Cmd側

```elm
map : (a -> msg) -> Cmd a -> Cmd msg
batch : List (Cmd msg) -> Cmd msg
none : Cmd msg
(!) : model -> List (Cmd msg) -> (model, Cmd msg)
```

`map`は主に、Elm Architectureを重ねる場合に、子Elm ArchitectureのMsgを親に合わせて変化させる時に使います。

```elm
type Msg =
     ChildMsg Child.Msg

subscriptiions model =
   Sub.map ChildMsg Child.subscrptions      --子供のSubの結果を親のMsgにラップする

```

`batch`は、複数のCmd、Subを一つに合体します。アプリケーションにCmdSubが複数ある時に使います。
合体したCmdSubが複数同時に発生したら一つづつそれぞれが発火します。

```elm

type Msg =
     | ParentMsg
     | ChildMsg Child.Msg


subscriptions : Model -> Sub Msg  
subscriptions model =
  Sub.batch [                                   --ParentとChildMsgのSubが、batchで融合してMsgになっているのがわかるかな？
     sub Parent
    ,Sub.map ChildMsg Child.subscrptions
   ]

```

`none`は、何もないCmd、Subということです。Cmd、Subが無いときに設定します。

`(!)`は記述が簡単になる関数です。

```elm
(!) : model -> List (Cmd msg) -> (model, Cmd msg)
(!) model commands =
  (model, batch commands)
```

`(!)`の右側のリストにCmdを並べると、batchで融合してくれます。タプルで書く手間が省けます。

```elm
init : (Model,Cmd msg)
init = model ! []           --空のリストを渡すと自動でCmd.noneになる。
```
