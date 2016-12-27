#elm-lang/html

elm-lang/htmlパッケージは、ElmでHTMLを作るときの基本のパッケージになります。

HTMLのような自然な記述で書くことが出来ます。

使用例ハローワールド

```elm
import Html exposing (div,text)

main =
  div [] [text "Hello World"]
```

Htmlライブラリは[virtual-dom](https://github.com/Matt-Esch/virtual-dom)（仮想DOMのライブラリ）をElm用にそのままラップしたものなので、仮想DOMの機能を使うことが出来ます。

クリックできるHTMLなど、イベント系を使うときはElm Architectureのドキュメントも参考にしてみてください。

使い方の参考になるよい作例として、Elm公式のexsampleページや、Elm公式のTODOリスト[evancz/elm-todomvc](https://github.com/evancz/elm-todomvc)があります。

パッケージのインストールコマンド

```
elm-package install elm-lang/html --y
```



##Htmlモジュール

Htmlモジュールは、基本になるモジュールでHtml型があって、divタグなどのHTMLを作る関数があります。

例えばdiv関数は以下のように定義されています。

```elm
div : List (Attribute msg) -> List (Html msg) -> Html msg
div =
  node "div"
```

一引数目で、属性を設定できます。（属性を作る関数はHtml.Attributesモジュールにあります。）
二引数目は、子供のHtmlをListで渡すことができます。  


hello worldというhtmlを作るコードです。

```elm
import Html exposing (div,text)

hello =
  div [] [text "hello"] ---textは何もタグで囲まれていない文字列Html a を作る

world =
  div [] [text "world"]

main =
  div [] [ hello
         , world]

```

結果のイメージになります。

```html
<div>
    <div>hello</div>
    <div>world</div>
</div>
```

例えばid属性があるinputタグを作るには以下のようになります。

```elm
import Html exposing (input)
import Html.Attributes exposing (id)

main = input [id "Input"] [] ---id は id属性を作る関数
```

```html
<div>
  <input id="Input">
</div>
```

ほかにもいろんなタグを作る関数が揃ってます。


##Html.Attributesモジュール


HTMLに属性を付けるには、Html.Attributesモジュールにある関数で作ることができます。

class属性、id属性をつけてみます。

```elm
import Html exposing (div)
import Html.Attributes exposing (class,id)

main : Html
main = div [class "test"  
           ,id "a"]
           []
```

結果HTMLイメージ

```html
<div>
    <div class="test" id="a"></div>
</div>
```

上記のようにclass,id属性をつけて、別途CSSファイルを読みこめば、ちゃんとCSSも適用されます。

CSSは、Html.Attributesモジュールにあるstyle属性を使うと、HTMLに直接インラインでCSSを付けることができます。

```elm
style : List (String, String) -> Attribute msg
```


##Html.Eventsモジュール

Html.Eventsモジュール内ある関数を使って、Htmlにイベントの属性を付けることが出来ます。

例えばクリックイベントを付けるにはonClick関数を使います。

```elm
onClick : msg -> Attribute msg
onClick msg =
  on "click" (Json.succeed msg)
```

onclick関数は一引数目にMsg型のデータ構築子を渡す必要があります。イベントを付けたHtmlに発火が起きると、Msg（メッセージ）がupdateに渡ります。

```elm
type Msg = Click
         | Enter

hello : Html Msg
hello =
    div [onClick Click] [text "hello"]     ---Clickすると……

update msg model =
    case msg of
         Click -> ...                      ---updateにMsgが渡るので、ここの処理が起きる
```


##Html.Lazy

Html.Lazyモジュールにあるlazy関数を使うことで、仮想DOMの力を発揮させて、効率の良い描画ができます。
指定した値が変化した時だけ、その部分を再描画する事ができます。

```elm
lazy : (a -> Html) -> a -> Html
lazy = VirtualDom.lazy
```

一引数目にviewの関数、二引数目の値が変更した時だけviewを更新します。
