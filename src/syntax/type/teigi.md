#型を定義するには

実際のプログラムでは、プログラムに合わせた型を基本的な型を組み合わせ、新たに定義していく必要があります。

新しい型を定義するには`type`と`type aliase`を使います。

```elm
type Fruits = Orange | Melon | Apple
type Msg = Get String
type alias User = { id : Int , name : String } --レコード型という種類の型
type alias Age = Int
```

`type`は新しい型を作るときに使います。

`type alias` は既存の型に別の型名を付けるときに使います。またレコード型を作るときは特別にこちらを使います。

##データ構築子（コンストラクタ）

上の例では、Fruits、Msg、User、Ageが新しく定義した「型名」で、そしてOrang、Melon、Apple、Get、の部分が「データ構築子（コンストラクタ）」といいいます。

`type`で新しい型を定義するときは、必ず他と被らないデータ構築子を定義する必要があります。

データ構築子がどこになるのかというのを意識して見てください。

既存の型を組み合わせた型を定義した時は、一番左がデータ構築子になります。

```elm
type ID = ID                --IDがデータ構築子。

type Day = Day Int Int Int  --Dayがデータ構築子。型名と同じ名前でも構わない。

```

データ構築子を関数のように使うと、定義した型に成ります。

```elm
today : Day
today = Day 2016 8 10   --Dayデータ構築子を使ってDay型を作っている

init : Fruits
init = Orange

```

##type alias

`type alias`は型に別名をつけることが出来ます。
別名を付けてわかりやすく出来ます。

```elm
type alias Money = Float
type alias ItemList = List Item
type alias Position = (Int,Int)

getX : Position -> Int
getX (a,b) = a
```

##typeで作れる型

###直積型

```elm
type Action = Action
type Position = Position Int Int
```

データ構築子と既存の型を並べて、新しい型を定義できます。
集合のA×Bのような型なので直積型と呼ばれます。

```elm
initPosition : Position
initPosition = Position 0 0
aPosition : Position
aPosition = Position 90 23
```

###Union type

`|`を使って型を定義する事ができます。この型はUnion type（ユニオン型、または直和型）といいます。（でも集合の直和とは違うものです。）typeでしかUnion typeを定義できません。

```elm
type　Bool =　Ture | False
```

上記の場合この（Bool）型は、TrueかFalseどちらかになる。という意味になります。フラグのイメージそのままです。

`|`で定義した場合は`|`毎に左端がデータ構築子になります。

```elm
type GameState = Start String | Main String | End Int  --StartとMainとEndがデータ構築子

type alias Hoge = Int
--type Huga = Test | Hoge   -- error!定義できない。データ構築子に既存のものは使えない。
```

Union typeは再帰した型を定義できます。場合分けしたした型のうち、終了にあたる型がある必要があります。

```elm
type List a = Cons a (List a) | Nil  --自分という型を使って定義している。Nilが終了

nil : List a
nil = Nil

list1 : List Int
list1 = Cons 1 Nil

list2 : List Int
list2 = Cons 2 (Cons 1 Nil)   --再帰したデータ構造
```

木構造などの再帰したデータ構造を定義できます。

Union typeはcase式でスイッチすることが出来ます。

```elm
type Fruits = Orange | Melon | Apple

grow fruits =
  case fruits of
    Orange ->
    Melons ->
    Apple ->
```

###型変数

型定義の時に、型変数というのを使うことが出来ます。

```elm
type Container a = Container a

taged : Container Int
taged = Container 10

taged2 : Container String
taged2 = Container "hello"
```

##type aliasで作れる型

###レコード型

プロパティがあるレコード型というのを定義できます。

```elm
type alias User = {name : String}
type alias Blog = {id : Int , kizi : String}
type alias Position a = { a | x : Int , y : Int}
```


プロパティがある型には、自動でアクセス用の関数が作られます。

```elm
> user1 = {name = "hiro"}                  --レコード型を定義
{ name = "hiro" } : { name : String }      --
> user1.name                               --
"hiro" : String
> .name user1
"hiro" : String
>
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

getX : {a| x:Int } -> Int                      --xプロパティのある型を指名
getX target = target.x

```

レコード型は直積型を定義するのと同じになってます。

```elm
type alias User = {name : String} -- == type User = User String
init = User "k"                   -- 型構築子が自動で生成されている。
```


##まとめ

```hs
type Msg = Add String | Error   --Union Type

type State = State (Int,Int)    --並べた型

type alias Position = (Int,Int) --名前の置き換え

type alias Model = {test : String}  --レコード型

```
