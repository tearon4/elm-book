
###Haskellとの違い
Haskellとの違いについて

* まずdo構文と、型クラスがないです。

* Elmは正格評価です。

* 型定義は`type`と`type alias`です。

```Haskell
type Bool = True | False
type alias Name = String
```

* 型の明記はコロンです。リストの表現は `::` です。

```Haskell
answer : Int
answer = 42
```

```Haskell
1 :: [2,3,4]
```

* headとtailがMaybeを返す。

```hs
head : List a -> Maybe a
tail : List a -> Maybe (List a)
```

* where無いletだけ。

* 関数を並べるタイプのパターンマッチはない。case式使う。

* ジェネリックな関数

toString
