#Javascriptと連帯する方法

このページでは、JSとElmの連帯する方法をまとめたいと思います。

以下のような方法があります。

* fullscreen/embed
* Port
* programWithFlags
* Native
* effect module


###fullscreen/embed

ElmをJs出力し、Html側に読み込むコードと起動するコードを書きます。この時、fullscreenで起動するか、embedで何処かのDOMに埋め込むか、workerで画面を出さないか選ぶことができます。

```js
<script type="text/javascript" src="Example.js"></script>
...

var elmApp =  Elm.Example.fullscreen()

```
####fullscreenで起動する
まずElmのMainになるモジュールの先頭行に、モジュール名をつけます。

```elm
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

呼び出し方は３つあります。
* fullscreen　--全画面
* embed　--どこかのDOM内で展開
* worker　--画面なし

####DOMに紐付けて起動する。(embed)

embedを使うと指定したDOMの内部にElmを展開できます。

```html
<div id="my-thing"></div>
<script src="my-thing.js"></script>
<script>
    var node = document.getElementById('my-thing');
    var app = Elm.MyThing.embed(node);
</script>
```


###Port

Portとは、Elmに用意されているJsとのやり取り用の構文です。

```elm
port hello : String -> Cmd msg
```

このようにElm側で書き、Js側ではsubscribeと、sendでやり取りします。

```js
app.ports.test.subscribe(function(a) {
  console.log(a);
});
```

syntaxのportのページで解説しています。

###programWithFlags

programWithFlagsとは、Elmの初期化時にJs側の値を使う方法です。Html.Appのページで解説しています。

```js
var elm = document.getElementById('elm')
var app = Elm.MyApp.embed(elm,{
    userID: 'Tom',
    token: '12345'})
```

###Nativeモジュール
coreライブラリ内を見ると、Nativeというフォルダがあります。これがNatveモジュールで、直接Elmランタイムの中にJavascriptを展開するように書くことが出来ます。

便利ですが、将来的にランタイムが壊れやすくなる要素を組み入れたくないElmはNativeモジュールを非推奨にしています。
とはいえ、すぐにJavascript用apiをElmで叩いたり必要になったりもします。

やり方TODO

###Effect Module
PubSubの裏側、Effectモジュールという方法もあります。（まだよくわかってない）
