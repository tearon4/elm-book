
#Cmd/Subバージョン

アプリケーションには、避けられない副作用処理があります。The Elm Architectureはそれらの処理に、Cmd/Subというインターフェースを提供しています。、マウスなどの入力や、DBアクセスや、httpアクセスや、別スレッドで実行されるTaskなどを扱えるようになります。

Cmd/Subは、どちらも別スレッド実行される非同期の処理と理解するといいと思います。Task型の理解が役に立ちます。

Cmd/Subは副作用の取り扱いをCmd/Sub利用者に見えないように行います。例えばwebsocketライブラリなどは、通信エラーになってもメインの処理とは別に独立して復旧したりするようになっているそうです。



##Cmd/Sub利用の仕方

###Cmd

Cmdは外にだす命令、コマンドという意味です。DBへの検索指示であったり、Taskの実行であったりといった、こちらから非同期で実行して結果が返ってくるものがCmd型になっています。

Cmdを発行できる場所は決まっています。init関数と、update関数の結果部分です。

```elm
init : (Model,Cmd msg)
update : Msg -> Model -> (Model,Cmd msg)
```

init関数に行いたいコマンドを渡した場合は、Modelの初期化が終わって「すぐ」に実行されます。例えば、ElmがDomに展開された後すぐhttpでサーバーに確認したいなどという時にinitに設定します。

update関数に設定した場合は、update処理の途中または結果時にCmdは実行されます。。updateの分岐の後、httpにアクセスしたり、といったことが出来ます。

Cmdが実行されると結果はMsg型になって、updateに(つまりアプリ内に)帰ってきます。dbアクセスの結果や、httpアクセスの結果などですね。なのでCmd型を作る関数はMsg型のデータ構築子を取るようになっています。

###Sub

Subは外から内に非同期にくるイベントを表しています。マウスやキーボードの入力などがそれにあたります。

まず、SubはsubscriptionsというHtml.Appの関数の結果になるようにします。

```elm
subscriptions : model -> Sub msg
```

例えば以下のようにsubscriptionsにマウスの移動入力Subを設定します。


```elm
subscriptions : Model -> Sub Msg
subscriptions model = Mouse.move GetPosition

main =
  program { ... , subscriptions = subscriptions}

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

`map`はCmd型の中を変化させます。

`batch`は、複数のCmd、Subを一つに合体します。アプリケーションにCmdSubが複数ある時や、他のThe Elm Architectureで書かれたコンポーネントを自分のコンポーネントに融合させる時に使います。
合体したCmdSubが複数同時に発生したらそれぞれがちゃんと発火します。

`none`は、何もないCmd、Subということです。Cmd、Subが無いときに設定します。

`(!)`は記述が簡単になる関数です。

```elm
init : (Model,Cmd msg)
init = model ! []           --空のリストだとCmd.noneになる。
```

上記の`(!)`の右側のリストにCmdを並べると、batchで融合してくれますし、`(model , nanntokaCmd)`みたいにわざわざタプル型を書かなくてすむようになる便利関数です。
