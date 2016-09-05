#Javascriptと連帯する方法

Elmにはまだまだライブラリが足りていません。しかしjavascript（以JS）には膨大なコードが世界に存在し今も生まれています。
Elmを使用すると、ElmからJSライブラリを使ったり、JS側に繋げたりする必要が出てきます。

このページでは、Elmにある、JSとElmを繋げる方法と部分という視点でElmを横断します。

* fullscreen、embed、workerモード
* Port構文
* programWithFlags
* Native
* effect module


Elmは指定してコンパイルすると一つのJSファイルになりますが、これをElmランタイムといいます。（ElmをHTML出力した時は、Elmランタイムと、ランタイムを読み込むコードが入ったHtmlを出力しています。）

Elmランタイム出力すれば、Elmランタイムに対していろいろなことが出来るようになっています。
値を渡したり（programWithFlags）、ElmをどこかのDOMに適応したり（embedモード）、画面を出さずにElmランタイムを利用したり（workerモード）、Elm側でport構文を使って記述しておけば、JS側でsendやsubscribeといった関数でやりとりできます。

JSライブラリを使うときは、基本的にport構文かNativeモジュールを使います。

##fullscreen、embed、workerモードでElmを起動する

準備

ElmのMainになるモジュールの先頭行に、モジュール名をつけます。

```elm
module Example exposing (...)

```

次にJSファイルとしてコンパイルします。

```bash
elm-make Example.elm --output=Example.js
```

そのJSファイルを読み込むHTMLを書いて、指定したモードで起動します。

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


##Port構文

Port構文とは、Elmに用意されている外とやり取りするための構文です。

```elm
port hello : String -> Cmd msg
```

このようにElm側は書き、JS側からはsubscribeと、sendという関数でやり取りを行います。

```js
app.ports.test.subscribe(function(a) {
  console.log(a);
});
```

詳しくはElmの構文のportのページで解説しています。

##programWithFlags

programWithFlagsとは、Elmの初期化時にJS側の値を使う方法です。Html.Appのページで解説しています。

```js
var elm = document.getElementById('elm')
var app = Elm.MyApp.embed(elm,{
    userID: 'Tom',
    token: '12345'})
```

##Nativeモジュール

coreライブラリ内を見ると、Nativeというフォルダがあります。これがNatveモジュールです。Nativeモジュール内のJSは直接Elmランタイムの中に展開されます。なので単純にJSをElmでラップして使うことが出来ます。

しかし注意として、Elm公式はNativeモジュールを使うことを非推奨にしています。それはElm内に将来的にランタイムの堅実さを壊すものを入れたくないことや、Elmのコンパイル結果がJS以外（webassemblyなど）になることを見越しているから、などが理由です。

とはいえ、すぐにJSのapiをElmで叩いたりしたい時などに必要になったりします。

###利用の仕方

elm-package.jsonに以下のオプションを加えます。するとNativeモジュールがコンパイル出来ます。

```
"native-modules": true,
```

Nativeモジュールを書くときは以下の様な書式で書きます。｛ユーザー名｝とかは置き換えてください

```js
var _{ユーザー名}${パッケージ名}$Native_{ライブラリ名} = function(elm) {

    var test = "hello"

    return  { test: test };
}();
```

##Effect Module

PubSubの裏側、Effectモジュールです。Pub、Subを提供するライブラリは、CmdとSubのリストとTaskをどう処理するかをEffectモジュールで管理します。しかしまだ理解が及んでいないのでわかりしだい書きたいと思います。

##まとめ

以上のような方法があります。  
NativeモジュールはさっとJSを使いたいときは便利です。しかし、Elmランタイムが壊れるバグに繋がったり、公式からユーザーへ配慮しないことを表明しているので、バージョンアップ時の互換性が保証されなかったりします。

port構文は堅実だがややJS側が面倒。と感じました。
