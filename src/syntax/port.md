##Port:Jsとやり取りする

PortとはElmに用意されているJsとのやり取り用の構文と仕組みです。

```elm
port hello : String -> Cmd msg
port jsHello : (String -> msg) -> Sub msg
```

このように書けば、JSから利用できるインターフェースが用意されます。
Js側ではportを以下のように利用します。

```js
var elm = document.getElementById('elm');
var app = Elm.Test.embed(elm);

//Elm -> Js
app.ports.hello.subscribe(function(a) {
  console.log(a);
  app.ports.jsHello.send("Hi!");
});

setTimeout(function () {  　　　　//subscribeの外だと、setTimeoutで囲う必要があるっぽい。次のバージョンで直ります。

　　//Js -> Elm
   app.ports.jsHello.send("Elm! hellooooo");

}, 0);

```

ElmとJsの型は合わせる必要があります。以下が対応表です。

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


メモ：portを使っているパッケージは公開できません。（同時にjsのインストールも必要になるため）


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
（initに書くとElm初期化後すぐのタイミング時でjsへ値を送ります。）

js側は`ports.定義した関数名.subscribe`に関数を登録して受け取ります。

```js
var elm = document.getElementById('elm');
var app = Elm.Test.embed(elm);

//Elmから受け取る！
app.ports.hello.subscribe(function(str) {
  console.log(str);
});
```

##JsからElmへ

Elm側

```
port 関数名 ： (受け取る型-> msg) -> Sub msg
```
と書いて関数を定義します。(msgは小文字)

例
```elm
port jsHello : (String -> msg) -> Sub msg
```

定義した関数をsubscriptionsで使います。
一引数目にJsからくる値をMsgにする関数（つまりはMsgのデータ構築子）を入れ使います。

```elm
type Msg = GetHello Strign  --受け取るMsgを定義！

subscriptions : Model -> Sub Msg
subscriptions model = inComingHello GetHello  --Msgを渡して受け取る！

main = program {subscriptions = subscriptions}
```

JS側

js側は、`app名.ports.関数名.send(送る値)`で送ります。
例
```js
app.ports.jsHello.send("hellooooo"); //Elmへ送る
```

あと今のところ、sendをsubscribeの中に書かない場合は、以下のようにsetTimeoutで囲う必要があるようです。(Elm v0.17.1)

```js
setTimeout(function () {
   app.ports.jsHello.send("hellooooo");
}, 0);

```

以上になります。他にJSとの連帯方法が知りたい場合は「Jsとの連帯方法まとめへ」
