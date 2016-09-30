
#Cmd/Subバージョン

アプリケーションには、避けられない副作用処理があります。Elm-Architectureはそれらの処理に、Cmd/Subというインターフェースを提供しています。、マウスなどの入力や、DBアクセスや、httpアクセスや、別スレッドで実行されるTaskなどを扱えるようになります。

Cmd/Subは、どちらも別スレッド実行される非同期の処理と理解するといいと思います。Task型の理解が役に立ちます。

Cmd/Subは副作用の取り扱いをCmd/Sub利用者に見えないように行います。例えばwebsocketライブラリなどは、通信エラーになってもメインの処理とは別に独立して復旧したりするようになっているそうです。



##Cmd/Sub利用の仕方

###Cmd

Cmdは外にだす命令、コマンドという意味です。DBへの検索指示であったり、Taskの実行であったりといった、こちらから非同期で実行して結果が返ってくるものがCmd型になっています。

Cmdを発行できる場所は決まっています。init関数と、update関数です。

```elm
init : (Model,Cmd msg)
```

init関数に行いたいコマンドを渡した場合、Modelの初期化が終わって「すぐ」に実行されます。例えば、ElmがDomに展開された後すぐhttpで確認したいなどという時にinitに設定します。


update関数の処理の途中で、Cmdを実行したいなら、updateに設定します。updateの分岐の後、httpにアクセスしたり、といったことが出来ます。

###Sub

Subは外から内に非同期にくるイベントを表しています。マウスやキーボードの入力とかがそうです。


```elm
subscriptions : model -> Sub msg
```

例えば以下のようにsubscriptions
に渡す関数を用意します。

```elm
subscriptions : Model -> Sub Msg
subscriptions model = Mouse.move GetPosition
```

そしてHtml.Appの関数に渡します。




##CmdとSubに用意されている関数

Cmdと、Subには同じ関数が用意されています。(Cmdだけ(!)演算子がある)

```elm
map
batch
none
(!)
```

mapはCmd型の中を変化させます。
batchは、複数のCmd、Subを一つに合体します。Elm-Architectureで作られたほかの部品を自分のアプリケーションに合体するときに使います。合体したCmdSubが複数同時に発生したらそれぞれがちゃんと発火します。
noneは、何もないCmd、Subを返します。Cmd、Subが無いときに設定します。

(!)はCmd.batchの省力記法用の関数です。

```elm
init : (Model,Cmd msg)
init = model ! []           --空のリストだとCmd.noneになる。
```
