#コラム：Haskellから見たElm

ElmはF#やOcamlやHaskellを参考にしています。
ElmとHaskellはどのように違うか、ということを考えてみました。（あまりHaskell知らないので間違っているかもしれません。。）


###表記の違い

・Elmでの型の明記はコロンで、リストの表現は `::` になります。Haskellとは逆になっています。

以下はElmです。

```elm
answer : Int
answer = 42

1 :: [2,3,4]
```

・where構文は無く、let式しかありません。

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

列挙型、代数的データ型の定義を`type`で行い、  
型の別名付け、レコード型の定義を`type alias`で行います

```elm
type Bool = True | False   -- Elmでは | がある型をUnion Typeと読んでいる。
type Data = Data Int Int   -- 直積型
type alias Name = String   -- type aliasで型に別名をつけることが出来る。
```

###レコード表記の違い。

Elmのレコード型はオブジェクトにすこし近いです。(構造的部分型？)

```elm
type alias Position = { x : Int , y : Int}  
type alias User = {name : String}   -- == type User = User String

> position = {x = 10, y = 10}                  --型を明示していない場合
{ x = 10, y = 10 } : { x : number, y : number' }　--「xとyプロパティのある型」みたいなあつかい


position : Position
position = {x = 10, y = 10}  

position2 : Position
position2 = Position 5 5   ---レコード表記しないでも型を作ることが出来ます。
```


こういう型が作れます。

```elm
type alias Position a = { a | x : Int , y : Int}

```

レコードの中の`a|`と言うのは、ここに型が入ることが出来るということです。
これを使うとレコードを部分的に定義できます。

```elm
type alias Position a = { a | x : Int , y : Int}

type alias Chara = Position { name :String }

chara : Chara
chara = {x=0,y=0,name = "piyo"}                --３つのプロパティ

getPosition : Position a -> Int                --
getPosition {x} = x                            --パターンマッチ

getX : {a| x:Int } -> Int                      --xプロパティのある型を指定
getX target = target.x

```

レコードの更新構文

```elm
position = {x = 0, y = 0}
{ position | x = position.x + 1}　  -- == {x = 1 , y = 0}  x = x + 1 みたいなもの
```

##main（エントリポイント）の型の違い

Elmはmainの型がSvg a、Html a、Program aという型になります。SvgやHtmlというように、Elmは画面構成用の言語です。
Program a というのはアプリケーション一単位という型で、専用の関数で作るのですが、作るのにはview関数、update関数、初期化関数、Msg型というのを用意する必要があります。ユーザー操作でアプリケーション状態を変更するには「update関数でしか出来ない」など、フレームワークとなっています。


###Elmには型クラス構文とかがない。

型クラスがないので、ジェネリックプログラミングみたいなことが出来ないです。
実装される話もあるようですが、あまり乗り気ではないそうです。

型クラス等がほしいならpuresciptとか、scala-js、ghc-js、typescriptとかを検討したほうがいいかもしれないです。


###余談：Elmの特別な型

Elmでは、number、 comparable、 appendableという多相な型を内部で使っていて、組み込みの関数はその型を使っています。

numberは`Int`と`Float`  
comparableは `String`, `Char`,`Int`, `Float`, `Time`,`taple`  
appendable は`List` `String`  

```elm
(+) : number -> number -> number
(<) : comparable -> comparable -> Bool
(++) : appendable -> appendable -> appendable
```

```elm
> [1,2,3] ++ [4,5,6]
[1,2,3,4,5,6] : List number
> "hello" ++ "world"
"helloworld" : String
```


###Elmは正格評価です。
