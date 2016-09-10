
#Cmd/Subバージョン

アプリケーションには、避けられない副作用処理があります。Elm-Architectureはそれらの処理に、Cmd/Subというインターフェースを提供しています。、マウスなどの入力や、DBアクセスや、httpアクセスや、別スレッドで実行されるTaskなどを扱えるようになります。

Cmd/Subは、どちらも別スレッド実行される非同期の処理と理解するといいと思います。Task型の理解が役に立ちます。

Cmd/Subは副作用の取り扱いをCmd/Sub利用者に見えないように行います。例えばスレッドを起動する処理はそれ自体が副作用で、生成したスレッドを管理しないといけません。そういった面倒な処理を裏（Cmd/Subを提供するライブラリ製作者）にまかせて、ライブラリ利用者はCmd/Subを使うだけでいいのです。

そしてCmd/Subは、副作用の処理が失敗してもメインのシステムには影響がないようになっていて、（Cmd/Subライブラリの作者がそういった処理を書けば）メインの処理とは独立に復旧するようになっています。

余談：reduxやcycle.jsといったフレームワークの作者がElm-Architectureを参考にした時は、Cmd/Subバージョンが確立する前でした、なので非同期処理については各フレームワークによってばらつきがあるようです。

##Cmd/Sub利用の仕方

###Cmd

Cmdは外にだす命令、コマンドという意味です。DBへの検索指示であったり、Taskの実行であったりといった、こちらから非同期で実行して結果が返ってくるものがCmd型になっています。

Cmdを発行できる場所は決まっています。init関数と、update関数です。

```elm
init : (Model,Cmd msg)
```

init関数に行いたいコマンドを渡した場合、Modelの初期化が終わって「すぐ」に実行されます。例えば、ElmがDomに展開された後すぐhttpで確認したいなどという時にinitに設定します。


update関数の処理の途中でDBやHttpにアクセスしたいときは、updateが返すCmd型に設定します。

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
batchは、複数のCmd、Subを一つに合体します。Elm-Architectureで作られたほかの部品を自分のアプリケーションに合体するときに使います。合体したCmdSubが複数同時に発生したら最初のものが優先されます。
noneは、何もないCmd、Subを返します。Cmd、Subが無いときに設定します。

(!)はCmd.batchの省力記法用の関数です。

```elm
init : (Model,Cmd msg)
init = model ! []           --空のリストだとCmd.noneになる。
```


##Elm-Architectureのモジュラリティ

Elm-Architectureで書かれた、init,update,Model等一連のセットをコンポーネントと呼びます。
Elm-Architectureで書かれたコンポーネント同士は木構造に組み合わせることが出来ます。

親コンポーネントを定義する時、コンポーネントを使って定義します。

````elm
import Child1
import Child2

type Msg   = A Child1.Msg             -- 子供のコンポーネントを使って定義します。
           | B Child2.Msg

type Model = {child1 : Child1.Model}  

update msg model =
     case msg of
       A child1msg ->let child = Child1.update child1msg --子供のMsgは子供のupdateに食わせます。

view = div [] [HtmlApp.map A Child1.view]  --子供のviewのMsgはHtml.Appでキャッチします。

```

Elm Packageにもコンポーネントが公開されています。

##Elm-Architecture

Elmは型付けもあって、updateや型は作ろうと思った通り大きくすることが出来ます。

コンポーネントの組み合わせ方はまだまだ議論や、例が少ない部分です。
おすすめの記事 :[再利用可能なコンポーネントはアンチパターン - ジンジャー研究室](http://jinjor-labo.hatenablog.com/entry/2016/08/03/031107)  
