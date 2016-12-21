#Javascriptと連帯する方法まとめ

Elmにはまだまだライブラリが足りていません。しかしjavascript（以JS）には膨大なコードが世界に存在し今も生まれています。
現状Elmを使用すると、ElmからJSライブラリを使ったり、JS側に繋げたりする必要があります。

このページでは、「JSとElmを繋げる方法と部分」という視点でElmを横断します。

* fullscreen、embed、workerモード
* Port構文
* programWithFlags
* Nativeモジュール
* effect module

Elmは指定してコンパイルすると一つのJSファイルになりますが、これをElmランタイムといいます。（ElmをHTML出力した時は、Elmランタイムと、ランタイムを読み込むコードが入ったHtmlを出力しています。）

Elmランタイムに対していろいろなことが出来ます。
値を渡したり（programWithFlags）、ElmをどこかのDOMに適応したり（embedモード）、画面を出さずにElmランタイムを利用したり（workerモード）、Elm側でport構文を使って記述しておけば、JS側でsendやsubscribeといった関数でやりとりしたりできます。

サーバーサイドからElmに初期値を与えたい時はprogramWithFlagsを使います。

JSライブラリをElmで使いたい時は、基本的にport構文かNativeモジュールを使います。

##Elmランタイム(JSファイル)出力する

JSファイルとのよりとりの説明のために、ElmをElmランタイム(JSファイル)出力して、自分でfullscreenモードで起動するまでを書いてみます。
(fullscreenモードで起動するだけならElmをHTMLにコンパイルするだけでOKです。）


まずElmのMainになるモジュールの先頭行に、モジュール名をつけます。

```elm
module Example exposing (...)
```

次にJSファイルとしてコンパイルします。

```bash
elm-make Example.elm --output=Example.js
```

そのJSファイルを読み込むHTMLを書きます。そして指定したモードで起動します。

```html
...
<script type="text/javascript" src="Example.js"></script>
...

var elmApp =  Elm.Example.fullscreen()

```

これでElmが起動します。

呼び出し方は３つあります。
* fullscreen　--全画面
* embed　     --どこかのDOM内で展開
* worker　    --画面なし

##fullscreen、embed、workerモードでElmを起動する

###DOMに紐付けて起動する。(embed)

embedを使うと指定したDOMの内部にElmを展開できます。

```html
<div id="my-thing"></div>
<script src="my-thing.js"></script>
<script>
    var node = document.getElementById('my-thing');
    var app = Elm.MyThing.embed(node);
</script>
```

###workerモードで起動する。

画面がないモード(worker)で起動できます。

```js
var app = Elm.App.worker();
```

##Port構文

Port構文とは、Elmに用意されている外とやり取りするための構文です。
この構文で書くと、JS側(Elmランタイム)にsendやsubcribeといったやり取り用の関数が用意されます。


```elm
port hello : String -> Cmd msg
```

Elm側を書くと、JS側からはsubscribeと、sendという関数でやり取りを行います。

```js
app.ports.hello.subscribe(function(a) {
  console.log(a);
});

```

詳しくはElmの構文のportのページで解説しています。

##programWithFlags

programWithFlagsとは、Elmの初期化時にJS側の値を使う方法です。

```js
var elm = document.getElementById('elm')
var app = Elm.MyApp.embed(elm,{
    userID: 'Tom',
    token: '12345'})
```

Html.Appのページで解説しています。

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

The Elm ArchitectureのPub/Subライブラリの裏側にあるのが、Effectモジュールです。Pub、Subを提供するライブラリは、CmdとSubのリストと状態と、Taskをどう処理するかをEffectモジュールで管理します。この機能でNativeモジュールの副作用がElmに及ばないようにしたり、依存したりしないようにします。まだ理解が及んでいないのでわかりしだい書きたいと思います。

##まとめ

以上のような方法があります。  
NativeモジュールはさっとJSを使いたいときは便利です。しかし、Elmランタイムが壊れるバグに繋がったり、公式からユーザーへ配慮しないことを表明しているので、バージョンアップ時の互換性が保証されなかったりします。

port構文は堅実だがややJS側が面倒。と感じました。
