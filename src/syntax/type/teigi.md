#型を定義するには

実際のプログラムでは、プログラムに合わせた新しい型や、基本的な型を組み合わせた型を使います。
それには型を新しく定義する必要があります。
型を定義するには`type`と`type aliase`を使います。

```elm
type Fruits = Orange | Melon | Apple
type Msg = Get String 
type alias User = { id : Int , name : String } --レコード型という種類の型
type alias Age = Int
```

`type`は新しい型を作るときに使います。
`type alias` は既存の型に別の型名を付けるときに使います。レコード型を作るときは特別こちらを使います。

##型構築子（コンストラクタ）

上の例では、Fruits、Msg、User、Ageが新しく定義した「型名」で、そしてOrang、Melon、Apple、Get、が「型構築子（コンストラクタ）」といいいます。

型構築子というのを理解するのが近道です。

`type`で新しい型を定義するときは、必ず他と被らない型構築子を定義する必要があります。
並べた型については後で解説しますが、そういった既存の型を組み合わせた型を定義した時は、一番左が新しく定義する型構築子になります。

```elm
type Day = Day Int Int Int  --Dayが型構築子。型名と同じ名前でも構わない。

```

定義した型構築子を使うと、定義した型になるという関係です！

```elm
today : Day
today = Day 2016 8 10

init : Fruits
init = Orange
```

##直積型

既存の型を横に並べて、新しい型を定義できます。

```
today = Day 2016 8 10
```



##Union type

`|`を使って型を定義すると、

Union type（ユニオン型）を定義する。

```
type　Bool =　Ture | False
```

##いろんな型を定義する。

型はUnion typeと直積型に分けられます。多分これらですべての型を表現できます。

直積型とは集合論でA ×　B等と表現されるような、集合を掛け合わせた集合のような型です。

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

