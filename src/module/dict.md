#Dict : 辞書

辞書とは一意なキーと値をひも付けたデータ型です。キーと値が一対一で並んでいるので、キーで値を検索できます。

例えば、`Dict String User`という辞書の場合、`String`型を使えば、`User`型を検索できます。

Int, Float, Time, Char, String, tuples などの比較可能な型をキーにできます。

insert、remove、検索には*O(log n)* 時間かかります。


###関数


```elm
empty : Dict k v
```
emptyは空の辞書を作ります。


```elm
get : comparable -> Dict comparable v -> Maybe v
```

getはキーでの検索結果を返します。
キーが見つからない場合はNatingを返します。辞書にキーがあるかわからないときに便利です。


```elm
member : comparable -> Dict comparable v -> Bool
```

memberはキーが辞書にあるかどうかを確認します。


```elm
size : Dict k v -> Int
```

sizeは辞書内のキーと値のペアの数を返します。


```elm
isEmpty : Dict k v -> Bool
```

isEmptyは空かどうかを返します。


```elm
insert : comparable -> v -> Dict comparable v -> Dict comparable v

```

insertはキーと値のペアを挿入します。キーが存在する場合、値を置き換えます。


```elm
remove : comparable -> Dict comparable v -> Dict comparable v

```

removeはキーと値のペアを削除します。キーが見つからない場合は何もしません。

```elm
update : comparable -> (Maybe v -> Maybe v) -> Dict comparable v -> Dict comparable v

```
updateは与えられた関数で更新します。


```elm
singleton : comparable -> v -> Dict comparable v

```
一つのキーと値のペアの辞書を作ります。


```elm
union : Dict comparable v -> Dict comparable v -> Dict comparable v

```

unionは２つの辞書を合体させます。もしキーの衝突がある場合は、一引数目の辞書が優先されます。


```elm
intersect : Dict comparable v -> Dict comparable v -> Dict comparable v

```

キーが両方の辞書にある値がのこります。値はひとつ目の辞書の値


```elm
diff : Dict comparable v -> Dict comparable v -> Dict comparable v

```
ふたつ目の辞書にないキーと値のペアが保存されます。



```elm
merge
  :  (comparable -> a -> result -> result)
  -> (comparable -> a -> b -> result -> result)
  -> (comparable -> b -> result -> result)
  -> Dict comparable a
  -> Dict comparable b
  -> result
  -> result
```

mergeは２つの辞書を合体します。キーが左の辞書のみある時、２つ辞書ともにある時、右の辞書のみの時の関数をとります。

変換



```elm
map : (comparable -> a -> b) -> Dict comparable a -> Dict comparable b

```

mapは辞書の中のすべての値に関数を適用します。


```elm
foldl : (comparable -> v -> b -> b) -> b -> Dict comparable v -> b
foldr : (comparable -> v -> b -> b) -> b -> Dict comparable v -> b

```

foldlはキーの順番に畳み込みます。


```elm
filter : (comparable -> v -> Bool) -> Dict comparable v -> Dict comparable v

```

述語を満たすキーと値の辞書を返します。


```elm
partition : (comparable -> v -> Bool) -> Dict comparable v -> (Dict comparable v, Dict comparable v)

```

述語で分割します。２つの辞書を返します。一つめの辞書はTrueになったもの、それ以外はふたつ目の辞書になります。
