#コラム：Haskellから見たElm

ElmとHaskellはどのように違うか、ということを考えてみました。（あまりHaskell知らないので間違っているかもしれません。。）


###表記の違い

Elmでの型の明記はコロンで、リストの表現は `::` になります。Haskellとは逆になっています。

以下はElmです。

```elm
answer : Int
answer = 42

1 :: [2,3,4]
```

・where構文は無く、let式だけです。

・関数を並べるタイプのパターンマッチはないです。case式を使います。

・headとtailがMaybeを返します。

```elm
head : List a -> Maybe a
tail : List a -> Maybe (List a)
```

・do構文がない。
色んな所で状態の変更がないようにするためと聞きました。

・elmのreplでは、:typeとか打たなくても改行で型が出ます。letとか書かなくても変数とか定義できます。

###型表記の違い。

列挙型、代数的データ型の定義を`type`で行い、型の別名付け、レコード型の定義を`type alias`で行います

```elm
type Bool = True | False   -- Elmでは | がある型をUnion Typeと読んでいる。
type Data = Data Int Int   -- 直積型
type alias Name = String   -- type aliasで型に別名をつけることが出来る。
```

###レコード表記の違い。

Elmではレコード型に型構築子を付けなくても定義できます。

```elm
type alias Position = { x : Int , y : Int}  --.x .y関数も作られます。

--type alias User = User { name : String }    --型構築子を付けるとエラーになる。

position : Position
position = {x = 10, y = 10}  

position2 : Position
position2 = Position 5 5   ---レコード表記しないでも型を作ることが出来ます。(型構築子が自動生成されてる？)
```

Elmのレコード型はオブジェクトにすこし近いです。(構造的部分型？)

こういう型が作れます。

```elm
type alias Position a = { a | x : Int , y : Int}

```

レコードの中の`a|`と言うのは、ここに型が入ることが出来るということです。
これを使うと重ねることが出来ます。

```elm
type alias Position a = { a | x : Int , y : Int}

type alias Chara = Position { name :String }    --別名つける方のtype alias

chara : Chara
chara = {x=0,y=0,name = "piyo"}                --３つのプロパティ

getPosition : Position a -> Int                --レコードの部分用の関数
getPosition {x} = x
```

レコードの更新構文

```elm
position = {x = 0, y = 0}
{ position | x = position.x + 1}　  -- == {x = 1 , y = 0}  x = x + 1 みたいなもの
```


###Elmには型クラス構文とかがない。

型クラスがないので、ジェネリックなプログラミングが出来ないです。
実装される話もあるようですが、あまり乗り気ではないようです。そういう思考のフレームで使う道具にしている感じがします。

型クラス等がほしいならpuresciptとか、scala-js、ghc-js、typescriptとかを検討したほうがいいかもしれません。。


###余談：Elmの特別な型

Elmではジェネリックプログラミング出来ないのですが、number、 comparable、 appendableという上位の型を内部で使っていて、組み込みの関数はその型を使っています。

numberは`Int`と`Float`
comparableは `String`, `Char`,`Int`, `Float`, `Time`,`taple`
appendable は`List` `String`

```
(+) : number -> number -> number
(<) : comparable -> comparable -> Bool
(++) : appendable -> appendable -> appendable
```


###Elmは正格評価です。


あと思いついたら追記します。
