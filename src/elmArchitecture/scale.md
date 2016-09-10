##Elm-Architectureのモジュラリティ

Elm-Architectureで書かれた、init,update,Model等一連のセットをコンポーネントと呼びます。
Elm-Architectureで書かれたコンポーネント同士は木構造に組み合わせることが出来ます。

親コンポーネントを定義する時、コンポーネントを使って定義します。

```elm
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

Elm Packageにも、このように組み合わせてつかうコンポーネントが公開されています。

##Elm-Architectureを拡大していくには

コンポーネントの組み合わせ方はまだまだ議論や、例が少ない部分です。まず子コンポーネントを考えず一つのコンポーネントを大きくしていくと良いと思います。

おすすめの記事 :[再利用可能なコンポーネントはアンチパターン - ジンジャー研究室](http://jinjor-labo.hatenablog.com/entry/2016/08/03/031107)  
