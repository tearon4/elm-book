コラム：ElmとJavaScriptの対応

ここではElmとJavaScript（JS）の対応を考えてみます。JSは（ES２０１５）を想定しています。


###型とクラス

Elmでは型というものがあります。
JSにはクラスがそれに該当します。

###直積型

Elmで直積型な型を定義すると以下のようになります。

```elm
type User = User Int String

user : User
user = User 1 "akane"
```

型の部分に名前が付いたレコード型を定義します。これも直積型にあたります。

```elm
type alias User = { id : Int
                  , name : String}
user : User
user = {id = 2 , name = "akari"}

```

これらはJSで表現すると以下のようになります。

```js
class User {
  constructor(id,name){
    this.id = id;
    this.name = name;
    }
}

const user = new User(4,"karin")

```

idとnameプロパティがあるUserクラスです。（なおJSでは型が指定できないので、どんな値もid、nameに入ってしまう可能性はあります。）

###Union型

Elmの型定義では`|`を使って、Union型を定義することが出来ます。

```elm
type Bool = True | False
```

Union型は、`|`で区切られたコンストラクタ（データ構築子）のいずれかになる。という意味になります。
case式で、Union型を使って処理を分岐させることができます。

```elm
test : Bool -> ...
test isHare =
    case isHare of
        True ->                 -- case式では、`|`で区切られた型すべての分岐を網羅しないと、エラーになります。
        _ ->               
```

JSでUnion型を書くことはできません。
似せてコードで表現すると以下のようになります。

```js
class Bool {}  //Boolクラスを定義。このクラスを継承するのはTrueとFalseのみにする。

class True extends Bool {}        //Boolを継承。TrueとFalseがBool型だという表現

class False extends Bool {}

const isHare = new True()

// test : Bool -> ()
const test = (isHare) => {
  switch (isHare.constructor){          //型を調べる
    case True:                          //Trueならこの分岐
      console.log(isHare.constructor);
      break;
    case False:
      console.log(isHare.constructor);
      break;
  }
}

test(isHare);  // class True extends Bool {}
```

JSには、Bool型を継承するのをTrue、Falseのみに固定したり、case式でそれらがちゃんと網羅されているか調べてくれたりする機能はありません。（Scalaやtypescriptにはあるらしいです。）

###継承

Elmに継承はありません（たぶん）。
