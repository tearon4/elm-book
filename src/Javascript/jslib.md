#JavaScriptライブラリを読み込む

外部のJavaScriptのライブラリを使うには、portとNativeモジュールという方法があります。
portは


###JSファイルとして出力、読み込む

まずElmのMainになるモジュールの先頭行に、モジュール名をつけます。

```Example.elm
module Example exposing (...)

```

次にJsファイルとしてコンパイルします。

```
elm-make Example.elm --output=Example.js
```

そしてHtmlファイルを用意して、出来たJSを読み込んで起動するコードを書きます。

```html
...
<script type="text/javascript" src="Example.js"></script>
...

var elmApp =  Elm.Example.fullscreen()

```

これでElmが起動します。

呼び出し方は３つあり
fullscreen　--全画面
embed　--どこかのDOM内で展開
worker　--画面なし



###DOMに紐付けて起動する。

embedを使うとどこかのDOMにElmを展開できます。
tutorialから拝借したコード。

```html
<div id="my-thing"></div>
<script src="my-thing.js"></script>
<script>
    var node = document.getElementById('my-thing');
    var app = Elm.MyThing.embed(node);
</script>
```


###Elmアプリケーションの初期値をjavascriptから渡す

サーバーが生成するトークンを受け渡すとか、Elm内から用意できない初期値をJS側からElmに渡せます。

```js

var elmApp =  Elm.Example.fullscreen({userId : 42})

```

この場合Html.AppのprogramWithFlags関数を使います。

```hs

main : Program { userID : Int}
main = programWithFlags { init = init
                        , ...

```

するとinit関数の引数にレコード型で渡ります。

###portを使ってJSとのやり取りする

Elmの外のjsから受け取ったり、送るのに使うのが、portです。
portを付けて関数を定義します。


```Haskell
--Sub 主に外からElmに影響があるもの

port userID :　Sub String　

port prices : (String -> msg ) -> Sub Float -- msg用の値を受け取れる

--Cmd はElm内から発生するコマンド

port hoge : Cmd Float　　　　　　　
port hoge = 　...

update msg model =
       case msg of
         ... -> model ! hoge

```


```javascript

// TODO:
```

portは前のバージョンでは、mainモジュール以外だと書けなかったが今は書けるようになった。
portを使っているパッケージは公開できない。（同時にjsのインストールも必要になるため）
