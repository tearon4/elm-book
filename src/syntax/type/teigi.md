#型を定義するには

実際のプログラムでは、プログラムに合わせた新しい型が必要になります。それには基本的な型を組み合わせ、型を新しく定義していく必要があります。


型を新しく定義するには`type`と`type aliase`を使います。

```elm
type Fruits = Orange | Melon | Apple
type Msg = Get String
type alias User = { id : Int , name : String } --レコード型という種類の型
type alias Age = Int
```

`type`は新しい型を作るときに使います。

`type alias` は既存の型に別の型名を付けるときに使います。またレコード型を作るときは特別にこちらを使います。

##型構築子（コンストラクタ）

上の例では、Fruits、Msg、User、Ageが新しく定義した「型名」で、そしてOrang、Melon、Apple、Get、の部分が「型構築子（コンストラクタ）」といいいます。

型構築子というのを理解するのが近道です。

`type`で新しい型を定義するときは、必ず他と被らない型構築子を定義する必要があります。

既存の型を組み合わせた型を定義した時は、一番左が新しく定義する型構築子になります。

```elm

type ID = ID                --IDが型構築子。

type Day = Day Int Int Int  --Dayが型構築子。型名と同じ名前でも構わない。

```

型構築子を関数のように使うと、定義した型となります。

```elm
today : Day
today = Day 2016 8 10   --Day型構築子を使ってDay型を作っている

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

型構築子と既存の型を横に並べて、新しい型を定義できます。
集合のA×Bのような型なので直積型と呼ばれます。

###Union type

`|`を使って型を定義する事ができます。この型はUnion type（ユニオン型、または直和型または代数的データ型）になります。（でも集合の直和とは違うものです。）

```elm
type　Bool =　Ture | False
```

上記の場合この型（Bool）は、TrueかFalseどちらかになる。という意味になります。フラグのイメージそのままです。

型構築子はやはり左端になります。`|`で定義した場合は`|`毎に左端が型構築子になります。`|`を使った型はtypeでしか定義できません。

```elm

type GameState = Start String | Main String | End Int

type alias Hoge = Int
--type Huga = Test | Hoge   -- error!定義できない。型構築子に既存のものは使えない。
```




###レコード型

###いろんな型を定義する。

型はUnion typeと直積型に分けられます。多分これらですべての型を表現できます。

```

```

##レコード型用の表記

```

```


##まとめ

```hs
type Msg = Add String | Error   --Union Type

type State = State (Int,Int)    --並べた型

type alias Position = (Int,Int) --名前の置き換え

type alias Model = {test : String}  --レコード型

```

##おまけ、型の定義失敗パターン

```
type A = ...
type Hoge = A | B | C
```

型構築子が新しい型ではない
