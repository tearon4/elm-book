#新しい型を定義する
型を定義してみます。

```
type Fruit = Orange |
```

```
type {定義する型の名前} = {型構築子}（を一個以上） {既存の型}(を定義に使う場合は後ろに0個以上続ける)
```

型構築子（コンストラクタ）というのが重要です。新しい型を定義するのは新しい形構築子を

#(|)を使った型定義
(|)を使って型を定義すると、


#いろんな型を定義する。
型はUnion type（代数型）と直積型に分けられます。多分これらですべての型を表現できます。

Union type（ユニオン型）を定義する。

```
type　Bool =　Ture | False
```

直積型の型を定義する。

直積型とは集合論でA ×　B等と表現されるような、集合を掛け合わせた集合のような型です。

```

```

#レコード表記

#ここまでのまとめ

```hs
type Msg = Add String | Error   --Union Type

type State = State (Int,Int)    --並べた型

type alias Position = (Int,Int) --名前の置き換え

type alias Model = {test : String}  --レコード表記

type alias Model = Model {test : String} --カプセル化した書き方

```

#おまけ、型の定義失敗パターン

```
type A = ...
type Hoge = A | B | C
```
