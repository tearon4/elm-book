#Javascriptと連帯する方法

このページでは、JSとElmの連帯する方法をまとめたいと思います。

以下のような方法があります。

* fullscreen/embed
* Port
* programWithFlags
* Native
* effect module


##fullscreen/embed

ElmをJSで出力し、起動する方法です。

ElmをJS出力した後、Html側に読み込むコードと起動するコードを書きます。この時、fullscreenで起動するか、embedで何処かのDOMに埋め込むか、workerで画面を出さないか選ぶことができます。

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

次にJSファイルとしてコンパイルします。

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


##Port

Portとは、Elmに用意されている外とやり取りするための構文です。

```elm
port hello : String -> Cmd msg
```

このようにElm側は書き、JS側からはsubscribeと、sendという関数でやり取りを行います。

```js
app.ports.test.subscribe(function(a) {
  console.log(a);
});
```

syntaxのportのページで解説しています。

##programWithFlags

programWithFlagsとは、Elmの初期化時にJS側の値を使う方法です。Html.Appのページで解説しています。

```js
var elm = document.getElementById('elm')
var app = Elm.MyApp.embed(elm,{
    userID: 'Tom',
    token: '12345'})
```

##Nativeモジュール

coreライブラリ内を見ると、Nativeというフォルダがあります。これがNatveモジュールで、直接Elmランタイムの中にJavascriptを展開することが出来ます。

ElmはNativeモジュールを非推奨にしています。jsだけじゃなくwebassemblyを見越していること、Elm内に将来的にランタイムの堅実さを壊すものを入れたくないこと、などが理由です。

とはいえ、すぐにJavascript用apiをElmで叩いたりしたい時などに必要になったりします。

###利用の仕方

elm-package.jsonに以下のオプションを加えます。するとNativeモジュールがコンパイル出来ます。

```
"native-modules": true,
```

Nativeモジュールは以下の様な書式になります。｛ユーザー名｝とかは置き換えてください

```
var _{ユーザー名}${パッケージ名}$Native_{ライブラリ名} = function(elm) {

    var test = "hello"

    return  { test: test };
}();
```

##Effect Module

PubSubの裏側、Effectモジュールです。Pub、Subを提供するライブラリは、CmdとSubのリストとTaskをどう処理するかをEffectモジュールで管理します。しかしまだ理解が及んでいないのでわかりしだい書きたいと思います。

##まとめ

以上のような方法があります。  
Nativeモジュールは楽ですが、Elmランタイムが壊れるバグに繋がり、バージョンアップ時の互換性が保証されない。  
portは堅実だがややJS側が面倒。と感じました。
