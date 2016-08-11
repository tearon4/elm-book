
#Cmd/Subバージョン

アプリケーションには、避けられない副作用処理がつきもので、現行のElm-Architectureはそれらの処理に、Cmd/Subというインターフェースを提供しています。

Cmd/Subを使うと、マウスなどの入力や、DBアクセスや、httpアクセスや、別スレッドで実行されるTaskなどを扱えます。

Cmd/Subを利用するには、どちらも別スレッド実行される非同期の処理と理解するといいと思います。なのでTask型の理解が役に立ちます。

Cmd/Subは副作用の取り扱いをCmd/Sub利用者に見えないように行います。例えばスレッドを起動する処理はそれ自体が副作用で、生成したスレッドを管理しないといけません。そういった面倒な処理を裏（Cmd/Subを提供するライブラリ製作者）にまかせて、ライブラリ利用者はCmd/Subを使うだけでいいのです。

そしてCmd/Subは、副作用の処理が失敗してもメインのシステムには影響がなく、メインの処理とは独立に復旧するようになっています。

余談：reduxやcycle.jsといったフレームワークの作者がElm-Architectureを参考にした時は、Cmd/Subバージョンが確立する前でした、なので非同期処理については各フレームワークによってばらつきがあるようです。

##Cmd/Sub利用の仕方

###Cmd

Cmdは外にだす命令、コマンドという意味です。DBへの検索指示であったり、Taskの実行であったりといった、こちらから非同期で実行して結果が返ってくるものがCmd型になっています。

Cmdを発行できる場所は、init関数と、update関数です。

```elm
init : (Model,Cmd msg)
```

init関数に行いたいコマンドを渡すと、Modelの初期化終わってすぐに実行されます。ElmがDomに展開された後すぐhttpで確認したいなどという時にinitに設定します。

update関数に渡すと、処理の途中で発行されます。

###Sub

Subは外から内にくるイベントを表しています。マウスの入力とかがそうです。


```elm
subscriptions : model -> Sub msg
```

例えば以下のようなのを用意します。

```elm
sub model = Mouse.move GetPosition
```

Subを返す関数は受け取る型構築子を渡すことが多いと思います。

##CmdとSubに用意されている関数

Cmdは、Subには同じ関数が用意されています。

```elm
map
batch
none
(!)
```

noneは、何もないCmd、Subを返します。Cmd、Subが無いときに設定します。
batchは、複数のCmd、Subをがっちゃんこして一つにして自分のアプリに送ります。合体したCmdSubが同時に発生したら最初のものが優先されます。
(!)はbatchの省力記法用の関数です。

```elm
init : (Model,Cmd msg)
init = model ! []
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
