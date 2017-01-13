
Cmd/Subバージョンについて見て行きましょう。

#Cmd/Sub

The Elm Architectureで非同期、副作用のある処理を管理する仕組みがCmd/Subです。

このCmd/Subに乗せてElmランタイムに非同期、副作用を渡すと、副作用の取り扱いをThe Elm Architecture利用者に見えないように裏でうまく処理してくれます。

例えばイベント登録が必要なSubが重なったら一つにしてくれたり、websocketライブラリは、通信がエラーになって接続が切れても、メインの処理とは別に独立して復旧したりするようになっています。

##Cmd

Cmdは外にだす命令、コマンドという意味です。

Cmd型を返すTask型を実行する関数は以下のようになっています。Cmdの実行結果はMsg型になってアプリケーションに帰ってくるので、Cmd型を作る関数はMsg型のデータ構築子を取るようになっています。


```elm
perform : (a -> msg) -> Task Never a -> Cmd msg
```

CmdをElmに渡す場所は、init関数と、update関数の結果部分です。

```elm
init : (Model,Cmd msg)
update : Msg -> Model -> (Model,Cmd msg)
```

init関数でコマンドを渡した場合は、Modelの初期化が終わって「すぐ」に実行されます。
update関数に設定した場合は、update処理の結果時にCmdは実行されます。


##Sub

Subは外から内に非同期にやってくるイベントを表しています。マウスやキーボードの入力などがそれにあたります。

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

Subの結果もまた、Msgのデータ構築子になって、updateに帰ってきます。


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

`batch`は、複数のCmd、Subを一つに合体します。アプリケーションにCmdSubが複数ある時に使います。
合体したCmdSubが複数同時に発生したら一つづつそれぞれが発火します。

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
