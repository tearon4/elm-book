辞書:Dict

辞書とは一意なキーと値をひも付けたデータ型です。キーと値が一対一で並んでいるので、キーで値を検索できます。
Int, Float, Time, Char, String, tuples などの比較可能な型をキーにできます。


insert、remove、検索には*O(log n)* 時間かかります。辞書同士の`(==)`による比較は信頼出来ないのでしないでください。

例

もし`Dict String User`という辞書の場合、`String` （例えば名前）を使えば、`User`ユーザーデータを検索できます。

###関数

空の辞書を作ります。

```elm
empty : Dict k v
```

キーに対応した値をとります。
キーが見つからない場合はNatingを返します。辞書にキーがあるかわからないときに便利です。

```elm
get : comparable -> Dict comparable v -> Maybe v
```

キーが辞書にあるかどうかを確認します。

```elm
member : comparable -> Dict comparable v -> Bool

```

辞書内のキーと値のペアの数を返します。

```elm
size : Dict k v -> Int
```

空かどうかを返します。

```elm
isEmpty : Dict k v -> Bool
```


キーと値のペアを挿入します。キーが存在する場合、値を置き換えます。

```elm
insert : comparable -> v -> Dict comparable v -> Dict comparable v

```


キーと値のペアを削除します。キーが見つからない場合は何もしません。

```elm
remove : comparable -> Dict comparable v -> Dict comparable v

```

与えられた関数と一緒にキーを更新します。

```elm
update : comparable -> (Maybe v -> Maybe v) -> Dict comparable v -> Dict comparable v

```

一つのキーと値のペアの辞書を作ります。

```elm
singleton : comparable -> v -> Dict comparable v

```

２つの辞書を合体させます。もし衝突がある場合は、一引数目の辞書が優先されます。

```elm
union : Dict comparable v -> Dict comparable v -> Dict comparable v

```






ふたつ目の辞書にもある値がのこります。優先されるのはひとつ目の辞書の値

```elm
intersect : Dict comparable v -> Dict comparable v -> Dict comparable v

```

ふたつ目の辞書にないキーと値のペアが保存されます。

```elm
diff : Dict comparable v -> Dict comparable v -> Dict comparable v

```

２つの辞書を合体します。キーが左の辞書のみある時、２つ辞書ともにある時、右の辞書のみの時の関数をとります。


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

変換


辞書の中のすべての値に関数を適用します。

```elm
map : (comparable -> a -> b) -> Dict comparable a -> Dict comparable b

```

キーの順番に畳み込みます。

```elm
foldl : (comparable -> v -> b -> b) -> b -> Dict comparable v -> b
foldr : (comparable -> v -> b -> b) -> b -> Dict comparable v -> b

```

述語を満たすキーと値の辞書を返します。

```elm
filter : (comparable -> v -> Bool) -> Dict comparable v -> Dict comparable v

```

述語で分割します。２つの辞書を返します。一つめの辞書はTrueになったもの、それ以外はふたつ目の辞書になります。

```elm
partition : (comparable -> v -> Bool) -> Dict comparable v -> (Dict comparable v, Dict comparable v)

```
