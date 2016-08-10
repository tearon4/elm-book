## Primitives

Elmに用意されている基本的な型についてです。

####数字型(number)

`number`とは特殊な型で、`Int` と `Float`になる型です。
`Int` は自然数という型、 `Float`は実数という型です。 

```elm
> 1
1 : number
> 2.0
2 : Float
```

#### 文字列

文字列型です。`Char` と `String`

```elm
> 'a'
'a' : Char
> "Hello"
"Hello" : String
```

####String

```elm

```


#### Bool型
```elm
> True
True : Bool
> False
False : Bool
```


## コレクション型

#### Lists

List型は

```elm
> []
[] : List a
> [1,2,3]
[1,2,3] : List number
> ["a", "b", "c"]
["a","b","c"] : List String
```


```elm
> [1..4]
> [1,2,3,4]
> 1 :: [2,3,4]
> 1 :: 2 :: 3 :: 4 :: []
```

#### Tuples
タプル型とは、型を並べた型です。種類の型でもタプルにすることが出来ます。
'()'で囲みコンマで区切るとTuple型になります。

```elm
> (1, "2", True)
(1,"2",True) : ( number, String, Bool )
```


```elm
> (,,,) 1 True 'a' []
(1,True,'a',[]) : ( number, Bool, Char, List a )
```

複数の値を返却するときにタプルを使うことが出来ます。

```elm
(x, y) = (1, 2)
> x
1 : number
```

#### Records


```elm
myRecord =
 { style = "Blue",
   number = 1,
   isCool = True
 }
```


```elm
> myRecord.style
"Blue" : String
> .style myRecord
"Blue" : String
```


```elm
> updatedRecord = { myRecord | style = "Red", number = 10, isCool = False }
> myRecord.style
"Blue" : String
> updatedRecord.style
"Red" : String
```

パターンマッチすることが出来ます

```elm
{ style, number, isCool } = myRecord
> style
"Blue" : String
```

####　その他
コアライブラリには
Array　Dict　Setといった型があります。
