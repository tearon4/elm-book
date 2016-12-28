#型を定義するには

プログラムに合わせて、基本的な型を組み合わせて新しい型を定義することが出来ます。

新しい型を定義するには`type`と`type aliase`というキーワードを使います。

```elm
type Fruits = Orange | Melon | Apple
type Msg = Get String
type alias User = { id : Int , name : String } --レコード型という種類の型
type alias Age = Int
```

`type`は新しい型を定義するときに使います。

`type alias`は既存の型に別の型名を付けるときに使います。またレコード型を定義するときは特別にこちらを使います。

型名は大文字から始まる必要があります。

##データ構築子（コンストラクタ）

`type`で新しい型を定義するときは、必ず他と被らない新しいデータ構築子も定義される必要があります。

データ構築子を使うことで、定義した新しい型の値（インスタンス）を生成することが出来ます。


```elm
type User = User String   --User型を新しく定義！

user : User
user = User "elm"         --User型の値を生成！

type Fruits = Orange | Melon | Apple  --Fruits型を新しく定義！

fruits : Fruits
fruits = Orange          --Fruits型の値を生成！
```

データ構築子がどこになるのかというのを意識してみてください。

上の例では、`User`、`Fruits`が新しく定義した型で、そして`User`、`Orange`、`Melon`、`Apple`、の部分がそれぞれの型のデータ構築子になります。

型を定義した時は、一番左がデータ構築子になります。


```elm
type ID = ID                --IDがデータ構築子。

type Day = Day Int Int Int  --Dayがデータ構築子。型名と同じ名前でも別名でも構わない。

today : Day
today = Day 2016 8 10       --Dayデータ構築子を使ってDay型の値を作っている

nextday = Day 2016 8 11     --Day型の別の値

```

##type alias

`type alias`は型に別名をつけることが出来ます。
別名を付けることで、読みやすくすることが出来ます。

```elm
type alias Money = Float
type alias ItemList = List Item
type alias Position = (Int,Int)

getX : Position -> Int
getX (a,b) = a
```

##typeで作れる型

typeで作れる型についてもう少し詳しく見ていきます。

###直積型

```elm
type Action = Action
type Position = Position Int Int
```

データ構築子と既存の型を並べて、新しい型を定義できます。
集合の直積のような型なので直積型と呼ばれます。

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

`|`で定義した場合は`|`毎に左端がデータ構築子になります。（つまり直積型とユニオン型の組み合わせ）

```elm
type GameState = Start String | Main String | End Int  --StartとMainとEndがデータ構築子

type alias Hoge = Int
--type Huga = Test | Hoge   -- error!定義できない。データ構築子に既存のものは使えない。
```

Union typeはcase式を使うことで、処理を分岐することが出来ます。

```elm
type Fruits = Orange | Melon | Apple

grow : Fruits ->
grow fruits =
  case fruits of             --case式で分岐
    Orange ->
    Melons ->
    Apple ->
```


###再帰した型

Union typeは再帰した型を定義できます。

```elm
type List a = Cons a (List a) | Nil  --自分を使って型を定義している。Nilが終了

nil : List a
nil = Nil

list1 : List Int
list1 = Cons 1 Nil             --ListはConsを使って繋げたデータ型

list2 : List Int
list2 = Cons 2 (Cons 1 Nil)   --どんどん繋げる。
```


###型変数

上記で使っていましたが、型定義の時に型変数というのを使うことが出来ます。

型変数は、どの型をいれても良い空白スペースになっています。
型変数を使うと、IntやFloatそれぞれの型用に個別に定義する必要がなくなります。

```elm
type Container a = Container a    -- a が型変数

taged : Container Int
taged = Container 10

taged2 : Container String
taged2 = Container "hello"
```

上記のContainerは、Container Int、Container Stringとしても使うことが出来ます。

List型なども、`List a`として定義されており、`List Int`、`List Float`など、色々な型を格納するListになることが出来ます。

```elm
> [1,2,3]
[1,2,3] : List number
> ["a","b"]
["a","b"] : List String
```

##type aliasで作れる型

`type alias`構文では、型に別名を付けることと、レコード型を作ることが出来ます。

###レコード型

プロパティがあるレコード型というのを定義できます。

```elm
type alias User = { name : String }
type alias Blog = { id : Int , kizi : String }
type alias Position a = { a | x : Int , y : Int }
```
プロパティは直積型の場所に名前がついたもので、上記のnameやidといった小文字部分です。

例えば沢山の型を並べる必要がある場合、型の意味がわかりにくくなりますが、レコード型で定義するとプロパティを使ってわかりやすく型を作ることが出来ます。

```elm
---直積型の場合

type User = User Int String ( Int, Int )

user1 = User 1 "elm" ( 0, 0 )

---レコード型を使った場合
type alias User2 = { id : Int, name : String, position : ( Int, Int ) }

user2 = { id = 2, name = "elm2", position = ( 0, 0 ) }  -- 型の意味がわかりやすい
```


またレコード型は以下のようにデータ構築子を使った生成も出来ます。

```elm
type alias User = {name : String , id : Int}
user = User "k" 1                                -- データ構築子が自動で生成されている。
```

###プロパティへのアクセス関数

プロパティがある型には、自動でアクセス用の関数が作られます。

```elm
> user1 = {name = "hiro"}                  --レコード型を生成
{ name = "hiro" } : { name : String }      
> user1.name                               
"hiro" : String
> .name user1
"hiro" : String
>
```

###パターンマッチ

レコード型もパターンマッチをすることが可能です。

```elm
getPosition : Position a -> Int                --
getPosition {x} = x                            --パターンマッチ xプロパティを取り出す。
```


###構造的部分型

レコードの中の`a|`と言うのは、レコード型の場合の型変数です。

`{a| x:Int }`という型があった場合、この型は「xという名前のプロパティを持つ型」という意味になります。


```elm
type alias Position a = { a | x : Int , y : Int}

type alias Chara = Position { name :String }

chara : Chara
chara = {x=0 , y=0 , name = "piyo"}                --３つのプロパティ

getX : {a| x:Int } -> Int                      --xプロパティのある型を指定
getX target = target.x

```
