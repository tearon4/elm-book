##The Elm Architectureのモジュラリティ

The Elm Architectureで書かれた、init,update,Model等一連のセットをコンポーネントと呼びます。
The Elm Architectureコンポーネント同士は木構造に組み合わせることが出来ます。

以下が例です。

```elm
import Child1
import Child2

type Msg   = A Child1.Msg             -- 子供のコンポーネントを使って定義します。
           | B Child2.Msg

type Model = {child1 : Child1.Model}  --子供のコンポーネントのmodel部分を作る。

update msg model =
     case msg of
       A child1msg ->let child = Child1.update child1msg model.child1--子供のMsgとmodelは子供のupdateに食わせます。

view = div [] [HtmlApp.map A Child1.view]  --子供のviewのMsgはHtml.Appでキャッチします。

```

このようにThe Elm Architectureコンポーネント同士は融合させることができます。
Elm Packageにも、このように使ういろいろなコンポーネント形式のものが公開されています。

##The Elm Architectureで開発していく中で

しかしコンポーネント単位の分割の仕方、組み合わせ方はまだまだ議論や、例が少ない部分です。一つのプロジェクトでは最初からコンポーネントを複数に分割することは考えず、必要になるまで一つのコンポーネントを大きくしていく方向が良いと思います。Elmだとコンパイラがよく見てくれるのでのびのび書いて大丈夫です。

おすすめの記事 :[再利用可能なコンポーネントはアンチパターン - ジンジャー研究室](http://jinjor-labo.hatenablog.com/entry/2016/08/03/031107)  
