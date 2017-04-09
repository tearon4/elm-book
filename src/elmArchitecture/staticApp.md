##ElmのHTMLライブラリを使って、画面に絵をかいてみよう。

次にElmのHTMLライブラリを使って、ブラウザに絵や文字を描いてみましょう。描いたものを動かしたい！と、思ったら次のページに進んでください。

HTMLを駆使して描くので、HTMLの知識も必要になってきます。ここでは最小限の説明しかできないので気になったところがあったら、各自調べてみてください。

では、以下のようなコードを書いて、保存してください。名前は何でも構いませんがモジュール名と合わしてください。

```elm
module ElmWorld exposing (..)  -- モジュール名は好きな名前で

import Html exposing (..)

main : Html msg
main =
　　text "hello"
```


###文字を書く

文字を表示してみましょう。

```elm
div [] [text "hello"]
```

text関数は、HTMLでの基本的な文字列を表しています。HTMLでマークアップされる文字列を指定する時はこの関数を使います。

イメージ

```html
<div>
  hello
</div>

```

###CSSを適用する

Elmの中で文字列でCSSを作り、style属性で指定すると、CSSを適用できます。


```
import Html exposing (..)
import Html.Attributes exposing (style)

div [style [("")]] []

```

HTMLにCSSを適用するには、style属性にCSSコードを直接指定する(インラインCSS)か、class属性、id属性でHTMLに識別子を付けて、CSSを読み込むかする必要があります。

上記の方法はインラインCSSになります。


CSSを読み込む場合は、id、class属性を指定して、

```
div [id "test"] []

div [class "hoge"] []
```

ElmをJSで出力して、HTMLで読み込みます（-> ElmをJS出力して使う（未リンク））。HTMLがCSSファイルを読み込めば、適用されます。

##Elmで手軽なゲームを作る準備

HTMLでゲームっぽい素材を作る方法を示します。HTMLのdiv要素に、CSSを使って、四角く色を指定して、大きさや場所を指定します。

メモ:しかしながら本来のHTMLの使い方から外れたやり方だったりします。本当は、canvas要素などを使います。今回はElmにまだ公式のcanvasライブラリがないことと、手軽さからdiv要素をcssで形を作ったり、移動させることにします。

###四角のHTMLを作る。

小さなゲームなどを作れるように、四角の形をHTMLで表示してみたいと思います。

ブラウザ画面に四角く表示される形を作るには、`width`と`height`というCSSを使うと、作ることが出来ます。


```elm
sizeCSS : Int -> Int -> List ( String, String )
sizeCSS x y =
    [ ( "width", toString x ++ "px" )
    , ( "height", toString y ++ "px" )
    ]
```

Elmの中でCSSを扱う時は、上記のように`List ( String, String)`で分離しておくと組み合わせしやすいです。


```elm

cellSize : Int
cellSize =
    20


mainCell : ( Int, Int ) -> Html msg
mainCell position =
    div
        [ style <| sizeCSS cellSize cellSize ]
        []

```

大きさを指定しただけでは、白くて見えないので、背景色も指定します。

```elm

colorCss : String -> List ( String, String )
colorCss str =
    [ ( "background-color", str ) ]


cellSize : Int
cellSize =
    20


mainCell : Html msg
mainCell =
    div
        [ style <|
            divSize cellSize cellSize
                ++ colorCss "#89f442"
        ]
        []
```

これで画面に四角が表示されたと思います。

他の色を手っ取り早く知りたい時は、Googleでcolor pickerと検索すると出てきます。



###絶対値で作ったものを配置する。

作った四角を色々な場所に移動させてみましょう。HTML+CSSには、本当に多様な配置指定の方法があります。ゲームなどで画面上の物を動かす時は、絶対値座標が便利です。

positionと、top、leftという要素を使います。

```elm

relative : List ( String, String )
relative =
    [ ( "position", "relative" ) ]


absolute : List ( String, String )
absolute =
    [ ( "position", "absolute" ) ]

positionCss : ( Int, Int ) -> List ( String, String )
positionCss ( x, y ) =
    [ ( "top", toString y ++ "px" )
    , ( "left", toString x ++ "px" )
    ]
        ++ absolute

```

`position : relative`を親要素に、子要素に`position : absolute`を指定します。すると、子要素のtopとleftの場所が親要素を元にした絶対値座標指定になります。

以下イメージ

```elm

gameView =
  div [ style <| fieldCss ++ divSize fieldX fieldY ]
      [ div [style <| absolute ] []]

```

ゲーム画面のdivの中に作った四角を配置するといいでしょう。

###絶対値座標、かつ中央表示する。

例えばゲーム画面の真ん中に、「ゲームスタート」など表示するには、絶対値座標で中央表示します。

```elm
absoluteCentering : List ( String, String )
absoluteCentering =
    [ ( "left", "50%" )
    , ( "top", "50%" )
    , ( "transform", "translate(-50%,-50%)" )
    ]
        ++ absolute
```

###ボタンと入力欄を作る。

後々のため入力欄を作ってみましょう。
