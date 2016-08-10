#Javascriptと連帯する方法

このページでは、JSとElmの連帯する方法をまとめたいと思います。

以下のような方法があります。

* fullscreen/embed
* Port
* programWithFlags
* Native
* effect module


###fullscreen/embed



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

影響がElmに及ばないように、Effectモジュールという方法もあります。（まだよくわかってない）
