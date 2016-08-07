#コラム：Haskellとの違い
ElmはHaskellとどのように違うか、ということを考えてみました。


表記の違いについて

* Elmでの型の明記はコロンで、リストの表現は `::` になります。Haskellとは逆になっています。

```
answer : Int
answer = 42

1 :: [2,3,4]
```


* 型表記とレコード表記の違い。

列挙型、直和型（Union Type）定義を`type`で行い、型の別名付け、レコード表記を`type alias`で行います

```
type Bool = True | False   -- Elmでは | がある型をUnion Typeと読んでいる。
type Data = Data Int Int   -- 直積型
type alias Name = String   -- type aliasで型に別名をつけることが出来る。
```

Elmのレコード表記はが可能です。

```
type alias Position = { x : Int , y : Int}

position : Position
position = {x = 10, y = 10}
```

こうすると型は{a | x :Int , y : Int}という型になります。aというは型変数で、「x、yというプロパティがある型、」という意味になります。（構造的部分型とかoverload recordとかいうらしい）

こういう型も作れます。

```
type alias Position a = { a | x : Int , y : Int}

```

作った型は重ねることが出来ます。

```
type alias Chara = Position { name :String }

chara = {x=0,y=0,name = "piyo"}
```



* whereが無く、letだけです。

* 関数を並べるタイプのパターンマッチはないです。case式使います。

* headとtailがMaybeを返します。

```hs
head : List a -> Maybe a
tail : List a -> Maybe (List a)
```

* Elmでは型構築子のないレコード表記が一般的で、カプセル化したい時に型構築子バージョンにします。

```

type alias Obj = {pro : Int , pro2 : Int}

type
```


* Elmには型クラス構文とかがない。
型クラスがないので、例えばこの型はFunctorのインスタンスだ、とか、これらは(+)できる型だ、といったジェネリックなプログラミングとかが出来ないです。
実装される話もあるようですが、あまり乗り気ではないようです。そういう思考のフレームで使う道具にしている感じがします。

型クラス等がほしいときはpuresciptとか、scala-js、ghc-js、typescriptとかを検討したほうがいいかもしれません。

余談:Elmの組み込まれているジェネリックな関数について。
ジェネリックプログラミングする方法は用意されていませんが、"Time"型同士を(<)で比較したり、文字列同士を(++)したり、自分で定義した型をtoStringしたり出来るようになっています。

```

'a' < 'z'

"hello" ++ "world"

position = {x = 10 , y = 10}
toString position == "{x = 10 , y = 10}"

```

これらの関数の引数はcomparable、appendable、等となっています。
組み込まれている型は、裏でこれらに含まれていて以下のようになっています。

comparable `String`, `Char`,`Int`, `Float`, `Time`
appendable List String



* do構文がない。
色んな所で状態の変更がないようにと聞きました。
メモ：モナドな型には、returnやandThen(bind)な関数が個別に実装されていますので、それらを呼び出して使います。


* Elmは正格評価です。
