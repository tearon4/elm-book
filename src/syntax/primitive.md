## Primitives

Elmに用意されている基本的な型についてです。

#### 数字型(number)
`Int` と `Float`があります。 `number`とは特殊な型で、`Int` と `Float`になる型です。

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


Single quotes are for `char` only
```elm
> 'ab'
-- SYNTAX PROBLEM --
> "ab"
"ab" : String
```

#### Booleans
```elm
> True
True : Bool
> False
False : Bool
```

#### Other
`comparable` - `ints`, `floats`, `chars`, `strings`, `lists`, `tuples`
<br/>
`appendable` - `strings`, `lists`, `text`.
<br/>


## Collections
#### Lists

```elm
> []
[] : List a
> [1,2,3]
[1,2,3] : List number
> ["a", "b", "c"]
["a","b","c"] : List String
```

List型を作る方法です。

```elm
> [1..4]
> [1,2,3,4]
> 1 :: [2,3,4]
> 1 :: 2 :: 3 :: 4 :: []
```

#### Tuples
タプル型とは、型を並べた型です。この時種類の型でもタプルにすることが出来ます。
'()'で囲みコンマで区切るとTuple型になります。

```elm
> (1, "2", True)
(1,"2",True) : ( number, String, Bool )
```


```elm
> (,,,) 1 True 'a' []
(1,True,'a',[]) : ( number, Bool, Char, List a )
```

複数の値を返却するときタプルを使うことが出来ます。

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

Accessing records
```elm
> myRecord.style
"Blue" : String
> .style myRecord
"Blue" : String
```

Updating records returns a new record
```elm
> updatedRecord = { myRecord | style = "Red", number = 10, isCool = False }
> myRecord.style
"Blue" : String
> updatedRecord.style
"Red" : String
```

Destructuring
```elm
{ style, number, isCool } = myRecord
> style
"Blue" : String
```

#### Other
Core library also has:
 * [Array](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Array)
 * [Dict](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Dict)
 * [Set](http://package.elm-lang.org/packages/elm-lang/core/3.0.0/Set)
