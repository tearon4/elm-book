##The Elm Architectureのモジュラリティ

Model、Msg、Update、Viewのセットをコンポーネントと呼びます。
The Elm Architectureでできたコンポーネント同士は木構造に組み合わせ、大きくすることが出来ます。

以下が例です。

```elm
import Child1                         --子供のコンポーネントをインポートします。
import Child2


type Model =
  {child1 : Child1.Model}  　　　　　　--Model型に、子供コンポーネントのModelを使います。

type Msg   = A Child1.Msg             -- Msg型を子供のコンポーネントのMsg型を使って定義します。
           | B Child2.Msg

update : Msg -> Model -> (Model , Cmd Msg)
update msg model =
     case msg of
       A child1msg ->
         let (childModel , childCmd) = Child1.update child1msg model.child1  --子供のMsgとmodelを子供のupdateに渡しています。
         in {ciled1 = cildModle } ! [cildCmd]                --親と組み合わせます
       B ...

view : Model -> Html Msg
view model =
  div [] [Html.map A Child1.view]  --子供のviewのMsgをHtml.map関数で、親のMsgにします。

```

このようにThe Elm Architectureコンポーネントの定義に、The Elm Architectureを使うことができます。
Elm Packageにも、コンポーネント形式のものが公開されています。

##The Elm Architectureで開発していく中で

しかしコンポーネント単位の分割の仕方、組み合わせ方はまだまだ議論や、例が少ない部分です。一つのプロジェクトでは最初からコンポーネントを複数に分割することは考えず、必要になるまで一つのコンポーネントを大きくしていく方向が良いと思います。Elmだとコンパイラがよく見てくれるのでのびのび書いて大丈夫です。

おすすめの記事 :

[再利用可能なコンポーネントはアンチパターン - ジンジャー研究室](http://jinjor-labo.hatenablog.com/entry/2016/08/03/031107)  

[[Elm]Statefulな親子コンポーネントとSubscriptionの扱いを整理してみます - Qiita](http://qiita.com/hosomichi/items/1a1d3c513e211e6bdd9f)
