#Port

ElmでJavaScript(以下JS)を使う方法には、PortとNativeモジュールとprogramWithFlagsの３つがあります。（違いについては最後に。）

PortはElmに用意されているJSとやり取りする仕組みです。
Elmで以下のように名前と型だけの関数を用意し、Cmd/Subとして実行します。

```elm
port hello : String -> Cmd msg
port jsHello : (String -> msg) -> Sub msg
```

するとJS側で以下のように利用できます。

```js
const elm = document.getElementById('elm');
const app = Elm.Test.embed(elm);   //Elmアプリケーションを起動

//ElmからJSへはsubscribe
app.ports.hello.subscribe(function(fromElm) {

  console.log(fromElm);
  //JSからElmへはsend
  app.ports.jsHello.send("Hi!");

});

//JSからElmへsend
app.ports.jsHello.send("Elm! hellooooo");


```

結構簡単です。

##型の対応表

ElmとJSの型の対応表です。

| Elm        | Javascript |
|------------|------------|
| Bool       | Bool       |
| String     | String     |
| Int Float  | Number     |
| List       | array      |
| Arrays     | array      |
| Tuples     | array(固定長、複数の型)|
| Records    | object     |
| Maybe (Nothing) | null  |
| Maybe (Just 42) |  42   |
| Json.Encode.Value | JSON |


#Portの書き方。

Portを書いてみます。

###port moduleに変更する

まず先頭行を`module`から`port module`に変更します。（よく忘れてコンパイラに怒られる。）

```elm
port module Test exposing (..)
```

メモ：port moduleを使っているパッケージはElm Packageで公開できません。同時にJSのインストールも必要になるからです。


#ElmからJSへCmdを出す

Elmから、外のJSを呼び出します。

###Elm側

```
port 関数名 : 送る型 -> Cmd msg
```

```elm
port hello : String -> Cmd msg
```

portと書いて関数名と型を定義します。この時、型は`送る型->Cmd msg`とします。（msgは小文字で書かなければなりません。）

そしてこの関数をinit関数や、update関数で使います。

```elm
init = "" ! [hello "Hello!JS!"]
```
initに書くと、Elm初期化後すぐのタイミングでJSへ値を送ります。

###JS側

JS側は`ports.定義した関数名.subscribe`として、関数を登録して受け取ります。(portsの「s」をよく忘れる)

```js
var elm = document.getElementById('elm');
var app = Elm.Test.embed(elm);

//Elmから受け取る！
app.ports.hello.subscribe(function(str) {
  console.log(str);
});
```

これでElmから好きなタイミングでJSコードを呼び出すことが出来ました。

##JSからElmに送る

次は反対にJS側からElmに値を渡して、Elmは受け取ります。

###Elm側

```elm
port 関数名 ： (JSからやってくる型-> msg) -> Sub msg
```

```elm
port jsHello : (String -> msg) -> Sub msg
```


と書いて関数を定義します(msgは小文字)。

JSからやってくる値はElmではMsgになります。なので`Msg`型を定義します。
そしてportで定義した関数を以下のように使います。

```elm
type Msg = GetHello Strign                     --Msgの定義

port jsHello : (String -> msg) -> Sub msg      --JS -> Elm のport

main = program {... , subscriptions = subscriptions} --subscriptions関数に使う。

subscriptions : Model -> Sub Msg
subscriptions model = jsHello GetHello         --例。

update msg model =
  case msg of
    GetHello str -> ...                        --JSからの値はMsgになる。

```

###JS側

JS側は、`app名.ports.関数名.send(送る値)`でElmに送ります。

例

```js
app.ports.jsHello.send("hellooooo"); //Elmへ送る
```

###PortとNativeモジュール

programWithFlagsはElmに初期値を渡す仕組みです。

PortはJSで出来たある程度の機能を、Elmから呼び出すのに適しています。

Nativeモジュールは、JSで出来たElmモジュールで、JS関数をElmでラップしてつかうような方法です。

NativeモジュールはJSの関数やapiのラップに使うと思います。それでだいたい主要なWeb apiはライブラリとして公開されているので、「JSコード使いたい」と思ったときはだいたいPortで済むはずとなっています。

Nativeモジュールは非サポート（使い方を公開しない、apiがアナウンス無しで変わる）になっていて、公式側からのみ提供する、といった方針になっています。またNativeを使ったパッケージは現在Elmパッケージから公開出来ないようになっています。

この理由は（自分の解釈でまとめると）、NativeモジュールはJSコードをElmランタイムに直接展開するので、ユーザーに開放してライブラリが増えていくとランタイムが壊れやすくなっていってしまう。ElmはJS以外（webassembly）も見ているのでJSのapiをいろんなライブラリが、別にそれぞれラップしたコード使うみたいなことがないように必要最小限にしたい。といったあたりです。

しかしながらTestコード上など、Nativeの方が便利な場面Portで冗長になる場面もあります。以下のリンクが参考になります。
参考：[Elmを本番運用するためのツールあれこれ - Qiita](http://qiita.com/ento/items/10401fb27ca604491c10)
参考：[Elm 0.17~0.18版 NativeModuleの書き方 - Qiita](http://qiita.com/k-motoyan/items/24f8b5f27ab828efb024)

Portで呼んだJSコードはElm化出来る/されるかもしれないので、あとで移行しやすいような関数名とか付けると、すこし良いかもしれません。

Nativeで副作用のある関数をラップするときは、副作用をElmに持ち込まないように、また使いやすいようにTask化すると良いかもしれません。
