コラム：ElmとJavaScriptの対応

###タイプとクラス

JSにはクラスというものがあります。
Elmでは型がそれに該当します。

###直積型

Elmで直積型な型を定義してみます。

```elm
type User = User Int String

user1 = User 1 "akane"
```

レコード型にした場合。

```elm
type alias User = { id : Int
                  , name : String}

user2 = {id = 2 , name = "akari"}
user3 = User 3 "arisu"

```

JSでは以下のようになります。

```js
class User {
  constructor(id,name){
    this.id = id;
    this.name = name;
    }
}

const user4 = new User(4,"karin")

```

###Union型

Elmの型定義では`|`を使って、Union型を定義することが出来ます。

```
```

Union型は、case式で分岐が出来る型です。

Elmは純粋関数型言語という区分になる。JavaScript(JS)はオブジェクト指向プログラミング言語と呼ばれる。
Elmは静的型付けという区分になる。JSは動的型付けである。
