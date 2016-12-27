
#Cmd/Sub

The Elm Architectureで非同期、副作用のある処理を管理する仕組みがCmd/Subです。

Cmd/Subは、The Elm Architectureで集めた副作用の取り扱いをThe Elm Architecture利用者に見えないように行います。例えばイベント登録が必要なSubが重なったら一つにしてくれたり、websocketライブラリは、通信がエラーになって接続が切れても、メインの処理とは別に独立して復旧したりするようになっています。

##Cmd

Cmdは外にだす命令、コマンドという意味です。Taskの実行といった、こちらから非同期で実行するものをCmd型になるようになっています。

Task型の実行関数

```elm
perform : (a -> msg) -> Task Never a -> Cmd msg
```

CmdをElmに渡す場所は決まっています。init関数と、update関数の結果部分です。

```elm
init : (Model,Cmd msg)
update : Msg -> Model -> (Model,Cmd msg)
```

init関数でコマンドを渡した場合は、Modelの初期化が終わって「すぐ」に実行されます。

update関数に設定した場合は、update処理の途中または結果時にCmdは実行されます。

Cmdが実行されると、結果はMsg型になってupdateに帰ってきます。なのでCmd型を作る関数は、Msg型のデータ構築子を取るようになっています。

Httpのリクエスト発行関数。結果を受け取るMsgを渡す必要がある。
```elm
send : (Result Error a -> msg) -> Request a -> Cmd msg
```


##Sub

Subは外から内に非同期にくるイベントを表しています。マウスやキーボードの入力などがそれにあたります。

Subはsubscriptions関数でElmに渡すようにします。

```elm
subscriptions : model -> Sub msg

main =
  program { ... , subscriptions = subscriptions}
```

例えば以下のようにsubscriptionsにマウスの移動入力Subを設定します。

```elm
subscriptions : Model -> Sub Msg
subscriptions model =
  Mouse.move GetPosition
```

Subの結果もまた、Msgのデータ構築子になって、updateに入ってきます。


##CmdとSubに用意されている関数

Cmdと、Subには同じ関数が用意されています。(Cmdだけ(!)演算子がある)

```elm
map
batch
none
(!)
```

`map`は主に、Elm Architectureを重ねる場合に、子Elm ArchitectureのMsgを親に合わせて変化させる時に使います。

`batch`は、複数のCmd、Subを一つに合体します。アプリケーションにCmdSubが複数ある時に使います。
合体したCmdSubが複数同時に発生したら一つづつそれぞれが発火します。

`none`は、何もないCmd、Subということです。Cmd、Subが無いときに設定します。

`(!)`は記述が簡単になる関数です。`(!)`の右側のリストにCmdを並べると、batchで融合してくれます。タプルで書く手間が省けます。

```elm
init : (Model,Cmd msg)
init = model ! []           --空のリストだとCmd.noneになる。
```
