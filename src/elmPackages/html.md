#elm-lang/html : Html

elm-lang/htmlパッケージの説明になります。
このパッケージのライブラリを使うことでElmでHtmlを作ることが出来ます。

Htmlライブラリは[virtual-dom](https://github.com/Matt-Esch/virtual-dom)をElm用にそのままラップしたものなので、仮想DOMという描画方法を自然に使うことが出来ます。

イベントを使うときは、Elm-Architectureにそって使うので、Elm-Architectureのページも参考にしてみてください。
よい作例として、Elm公式のexsampleページや、Elm公式のTODOリスト[evancz/elm-todomvc](https://github.com/evancz/elm-todomvc)があります。

パッケージのインストールコマンド

```
elm-package install elm-lang/html --y
```

使用例ハローワールド

```hs
import Html exposing (div,text)

main = div [] [text "Hello World"]
```

以下モジュールごとの説明になります。

##Htmlモジュール

基本になるモジュールで、Html型があります。

直接使うことは無いですがベースになっているnode関数です。

```hs
node : String -> List (Attribute msg) -> List (Html msg) -> Html msg
node = VirtualDom.node
```

一引数目は、htmlタグの種類を文字列で指定、  
二引数目で、属性と値を設定します。（Html.Attributesモジュールに作る関数があります。）  
三引数目は、子のHtmlです。  

このnodeタグをラップした関数が用意されています。
divタグを作るには、div関数を使います。

```hs
div : List (Attribute msg) -> List (Html msg) -> Html msg
div = node "div"
```

helloというhtmlを作るコードです。

```hs
import Html exposing (div,text)

main = div [] [text "hello"] ---textは何もタグで囲まれていない文字列Html a を作る

```

結果のイメージになります。

```html
<div>
    <div>heloo</div>
</div>
```

inputタグを作ってみます。

```hs
import Html exposing (input)
import Html.Attributes exposing (id)

main = input [id "Input"] [] ---id は id属性を作る関数
```

```html
<div>
  <input id="Input">
</div>
```

HTMLを作ることが出来ました。
ほかにもいろんなタグを作る関数も揃ってます。


##Html.Attributesモジュール

Html.Attributesモジュールにある関数で、Htmlに属性を付けます。

class属性、id属性をつけてみます。

```hs
import Html exposing (div)
import Html.Attributes exposing (class,id)

main : Html
main = div [class "test"  
           ,id "a"]
           []
```

```html
<div>
    <div class="test" id="a"></div>
</div>
```

このようにclass,id属性をつけて、別途cssファイルを読みこめば、ちゃんとcssも適用されます。

今度はstyle属性をつけて、cssを直接domに適応してみます。

文字列を改行を設定するcssをつけてみます。

```hs
style : List (String, String) -> Attribute msg
```

```hs
import Html exposing (div)
import Html.Attributes exposing (style)

break = ("word-break","break-all")
spaceWrap = ("white-space","pre-wrap")
width = ("width","100px")
lineBreak = style [spaceWrap,break,width]

main = div [lineBreak] [text "helllllllloooooooooooo"]

```

メモ：文字列中の改行がそのまま適応されるpreタグというのもあります。
画面の枠にそって自動で収まるようにするには、flexというcssもあります。

メモ：書くときの注意

Htmlの規格通り一つのタグに２つ同じ属性をつけたりは出来ません。

```hs
a = style[("width","100px")]
g = style[("height","100px")]

main = div [width',height'][]

<div><div style="height: 100px;"></div></div>

main = div[on "keydown" ...
          ,on "keydown" ...] ---こっちだけになる

```

メモ：SassやPostCss、外部のCSSの管理方法も含めるとCSSには色々な適用の仕方、運用方法があり議論があるところです。Elm内で、styleを使いCSSを適用する方法はHTMLにインライン展開されます。これはHtmlが不格好になり、速度が遅くなるそうですが、EｌｍでCSSを記述するとCSSが意図とは違うタグを汚染したりといったことがなくElm内でCSSを管理できます。プロトタイピングには最適かと思います。CSSの文字列をすべて関数に置き換えたパッケージも公開されています(seanhess/elm-style)。googleのMaterial Design LiteをElmで使えるようにしたパッケージもあります。(debois/elm-mdl)



##Html.Eventsモジュール

Html.Eventsモジュール内ある関数を使って、HtmlにイベントのAttributeを付けることが出来ます。

例えばクリックイベント付けるにはonClick関数を使います。

```elm
onClick : msg -> Attribute msg
onClick msg =
  on "click" (Json.succeed msg)
```

イベントを付ける関数はon関数が元になっています。

```hs
on : String -> Json.Decoder msg -> Attribute msg
```

一引数目は、イベントの種類の指定。(例えば"input"、"click"、"keydown"、、、)  
二引数目に、Json.Decoderを入れ、eventオブジェクトをデコードして値を取り出します。

Jsonデコーダを入れると、イベントオブジェクトから指定した値を取り出せます。`event.target.value`の値が欲しいなら`targetValue`、`event.KeyCode`なら`keyCode`といったデコードが、このモジュール内に用意されています。自分で作るには、CoreライブラリのJsonモジュールを使います。

イベントが発生して取り出した値はデータ構築子に渡され、updateに渡ります。Elm-Architectureのページも参考にしてみてください。


##Html.Lazy

Html.Lazyモジュールにあるlazy関数を使うことで、仮想DOMの力を発揮させて、効率の良い描画ができます。
指定した値が変化した時だけ、その部分を再描画する事ができます。

```hs
lazy : (a -> Html) -> a -> Html
lazy = VirtualDom.lazy
```

一引数目にviewの関数、二引数目の値が変更した時だけviewを更新します。
