辞書とは一意なキーと値をひも付けたデータ型です。
キーには型を使うことが出来ます。
例えばInt, Float, Time, Char, String, tuples などの比較可能な型になります。


インサート、リムーブ、検索には*O(log n)* 時間かかります。
辞書同士の`(==)`による比較は信頼出来ないのでしないでください。


もし`(Dict String User)`という辞書の場合なら、`String` (例えば名前で)ユーザーデータを探せます


空の辞書を作ります。

```
empty : Dict k v
```

キーに関連付けられた値を取得します。キーが見つからない場合はNatingを返します。辞書にキーがあるかわからないときに便利です。

```
get : comparable -> Dict comparable v -> Maybe v
```

キーが辞書にあるかどうかを確認します。
```
member : comparable -> Dict comparable v -> Bool

```

辞書内のキーと値のペアの数を返します。

```
size : Dict k v -> Int
```

空かどうかを返します。

```
isEmpty : Dict k v -> Bool
```


キーと値のペアを挿入します。キーが存在する場合、値を置き換えます。

```
insert : comparable -> v -> Dict comparable v -> Dict comparable v

```


キーと値のペアを削除します。キーが見つからない場合は何もしません。

```
remove : comparable -> Dict comparable v -> Dict comparable v

```

与えられた関数と一緒にキーを更新します。

```
update : comparable -> (Maybe v -> Maybe v) -> Dict comparable v -> Dict comparable v

```

一つのキーと値のペアの辞書を作ります。

```
singleton : comparable -> v -> Dict comparable v

```

２つの辞書を合体させます。もし衝突がある場合は、一引数目の辞書が優先されます。

```
union : Dict comparable v -> Dict comparable v -> Dict comparable v

```






ふたつ目の辞書にもある値がのこります。優先されるのはひとつ目の辞書の値

```
intersect : Dict comparable v -> Dict comparable v -> Dict comparable v

```

ふたつ目の辞書にないキーと値のペアが保存されます。

```
diff : Dict comparable v -> Dict comparable v -> Dict comparable v

```

２つの辞書を合わせる最も一般的な方法。キーのための３つの関数をていきょうします。

左の辞書のみ
２つ辞書ともに
右の辞書のみ

それらはあなたがほしいものを構築するとき、すべてを走査します。


```
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


辞書の中のすべての値に関数を適用

```
map : (comparable -> a -> b) -> Dict comparable a -> Dict comparable b

```

キーの順番に叩き込む。

```
foldl : (comparable -> v -> b -> b) -> b -> Dict comparable v -> b

foldr : (comparable -> v -> b -> b) -> b -> Dict comparable v -> b


```


述語を満たすキーと値を残す

```
filter : (comparable -> v -> Bool) -> Dict comparable v -> Dict comparable v

```

述語で分割。一つめの辞書にTrueになったもの、残りはふたつ目の辞書になる。

```
partition : (comparable -> v -> Bool) -> Dict comparable v -> (Dict comparable v, Dict comparable v)

```
