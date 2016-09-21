#Port:JSとやり取りする

PortとはElmに用意されているJSとのやり取り用の構文と仕組みです。

```elm
port hello : String -> Cmd msg
port jsHello : (String -> msg) -> Sub msg
```

このように書けば、JSから利用できるインターフェースが用意されます。
JS側ではportを以下のように利用します。

```js
var elm = document.getElementById('elm');
var app = Elm.Test.embed(elm);

//Elm -> JS
app.ports.hello.subscribe(function(a) {
  console.log(a);
  app.ports.jsHello.send("Hi!");
});

setTimeout(function () {  　　　　//subscribeの外だと、setTimeoutで囲う必要があるっぽい。次のバージョンで直ります。
　　//JS -> Elm
   app.ports.jsHello.send("Elm! hellooooo");

}, 0);

```

ElmとJSの型は合わせる必要があります。以下が対応表です。

| Elm | Javascript |
|------------|-----|
|Bool  | Bool |
|String | String |
| Int Float | Number |
| List | array |
| Arrays | array |
| Tuples | array(固定長、複数の型)
| Records | object|
| Maybe (Nothing) | null|
| Maybe (Just 42) |  42 |
| Json.Encode.Value | JSON |


メモ：portを使っているパッケージはElm Packageで公開できません。（同時にJSのインストールも必要になるため）


##Portの書き方。

まず先頭行をmoduleからport moduleに変更します。

```elm
port module Test exposing (..)
```

##ElmからJsへ

```elm
port hello : String -> Cmd msg
```

portと書いて関数を定義します。
型を`送る型->Cmd msg`とします。
msgは小文字指定です。

そしてこの関数をCmdを取るinitや、updateで使います。（init等に関してはElm-Architectureへ）

例

```elm
init = "" ! [hello "Js! Hello!"]
```
（initに書くとElm初期化後すぐのタイミング時でJSへ値を送ります。）

JS側は`ports.定義した関数名.subscribe`に関数を登録して受け取ります。

```js
var elm = document.getElementById('elm');
var app = Elm.Test.embed(elm);

//Elmから受け取る！
app.ports.hello.subscribe(function(str) {
  console.log(str);
});
```

##JSからElmへ

Elm側

```elm
port jsHello : (String -> msg) -> Sub msg
```

```
port 関数名 ： (受け取る型-> msg) -> Sub msg
```
と書いて関数を定義します。(msgは小文字)

定義した関数をsubscriptionsで使います。(subscriptionsはElm-Architectureのページで解説しています。)

一引数目にMsgのデータ構築子を入れ使います。

```elm
type Msg = GetHello Strign                     --Msgの定義

port jsHello : (String -> msg) -> Sub msg      --JS -> Elm のport

main = program {subscriptions = subscriptions} --subscriptions関数に使う。

subscriptions : Model -> Sub Msg
subscriptions model = jsHello GetHello         --例。

```

JS側

JS側は、`app名.ports.関数名.send(送る値)`で送ります。

例

```js
app.ports.jsHello.send("hellooooo"); //Elmへ送る
```

メモ : 現在のバージョンでは、sendを以下のようにsetTimeoutで囲う必要があるようです。(Elm v0.17.1)(このページの先頭の例のようなsubscribe内のsendでは必要ない。)

```js
setTimeout(function () {
   app.ports.jsHello.send("hellooooo");
}, 0);

```

以上になります。他にJSとの連帯方法が知りたい場合は「Jsとの連帯方法まとめ」へ
