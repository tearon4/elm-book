#elm-lang/html : Html

elm-lang/htmlパッケージの説明になります。
ElmでHTMLを作るときの基本のパッケージになります。

Htmlライブラリは[virtual-dom](https://github.com/Matt-Esch/virtual-dom)をElm用にそのままラップしたものなので、仮想DOMという描画方法を自然に使うことが出来ます。

Htmlをクリック出来るようにするなどイベント系を使うときは、Elm-Architectureのページも参考にしてみてください。
使い方の参考になるよい作例として、Elm公式のexsampleページや、Elm公式のTODOリスト[evancz/elm-todomvc](https://github.com/evancz/elm-todomvc)があります。

パッケージのインストールコマンド

```
elm-package install elm-lang/html --y
```

使用例ハローワールド

```hs
import Html exposing (div,text)

main = div [] [text "Hello World"]
```


##Htmlモジュール

基本になるモジュールで、Html型があって、divタグなどのHTMLを作る関数があります。

例えばdiv関数は以下のようになっています。

```hs
div : List (Attribute msg) -> List (Html msg) -> Html msg
div =
  node "div"
```

一引数目で、属性と値を設定できます。Html.Attributesモジュールに作る関数があります。
二引数目は、子供のHtmlをListで渡すことができます。  


hello worldというhtmlを作るコードです。

```hs
import Html exposing (div,text)

hello = div [] [text "hello"] ---textは何もタグで囲まれていない文字列Html a を作る

world = div [] [text "world"]

main = div [] [ hello , world]

```

結果のイメージになります。

```html
<div>
    <div>hello</div>
    <div>world</div>
</div>
```

例えばidがあるinputタグを作るには以下のようになります。

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

ほかにもいろんなタグを作る関数が揃ってます。


##Html.Attributesモジュール


HTMLに属性を付けるには、Html.Attributesモジュールにある関数で作ることができます。

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

このようにclass,id属性をつけて、別途cssファイルを読みこめば、ちゃんとCSSも適用されます。

CSSについて言えば、Html.Attributesモジュールにあるstyle属性を使うと、HTMLに直接インラインでCSSを付けることができます。

```hs
style : List (String, String) -> Attribute msg
```

文字列の改行を設定するcssをつけてみます。


```hs
import Html exposing (div)
import Html.Attributes exposing (style)

break = ("word-break","break-all")
spaceWrap = ("white-space","pre-wrap")
width = ("width","100px")

lineBreak = style [ spaceWrap , break , width ]

main =
   div [lineBreak]
       [text "helllllllloooooooooooo"]

```

メモ：余談ですけど、改行に関しての追加の情報で、flex-boxというCSSを使うと、画面の枠にそって自動で改行します、また、テキストの改行がそのまま適応されるpreタグというのもあります。

メモ：style書くときの注意

Htmlの規格通り一つのタグに２つ同じ属性をつけたりは出来ません。

```hs
a = style[("width","100px")]
g = style[("height","100px")]

main = div [width',height'][]

<div><div style="height: 100px;"></div></div>

main = div[on "keydown" ...
          ,on "keydown" ...] ---こっちだけになる

```

メモ：CSSには色々な適用の仕方、運用方法があり議論があるところです。幾つか紹介しておきます。

例えば、Elm内でstyle関数を使いCSSを適用する方法はHTMLにインライン展開されますが、これはHtmlが不格好になり、速度が遅くなるそうです。
ですがこの方法を使うと、Elm内でCSSを管理することができます。CSSが意図とは違うタグを汚染したりといったことがなく、Elm内で変数を使って組み合わしたり、再利用したり出来るというわけです。

CSSを文字列で書くと、タイポなどをElmコンパイラが発見できずちゃんと適用されているかはブラウザで確認しながらになります。なのでCSSの文字列をすべて関数に置き換えたパッケージも公開されています(seanhess/elm-style)。

著者が最近使うのは、googleのMaterial Design LiteというCSSフレームワークをElmで使えるようにしたパッケージです。(debois/elm-mdl)。ここにもCSSを拡張するための関数があって使っています。

id関数やclass関数を使ってid、classを付けて、CSSファイルを別途読み込む方法もあります。普遍的な方法で、コードの見た目もかなり普通のHTMLに近づくきがします。


##Html.Eventsモジュール

Html.Eventsモジュール内ある関数を使って、Htmlにイベントの属性を付けることが出来ます。

例えばクリックイベントを付けるにはonClick関数を使います。

```elm
onClick : msg -> Attribute msg
onClick msg =
  on "click" (Json.succeed msg)
```

一引数目にMsg型のデータ構築子を渡す必要があります。
これでイベントが起きた時に、Msg（メッセージ）が起きます。

Msgがあると、updateに渡ります。Elm-Architectureのページも参考にしてみてください。


##Html.Lazy

Html.Lazyモジュールにあるlazy関数を使うことで、仮想DOMの力を発揮させて、効率の良い描画ができます。
指定した値が変化した時だけ、その部分を再描画する事ができます。

```hs
lazy : (a -> Html) -> a -> Html
lazy = VirtualDom.lazy
```

一引数目にviewの関数、二引数目の値が変更した時だけviewを更新します。
