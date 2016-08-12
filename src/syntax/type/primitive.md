## Primitives

Elmに始めから用意されている基本的な型を紹介します。詳しくはCoreライブラリ内の各モジュールの説明を参照してみてください。

####Int

`Int` は整数型です。

```elm
> 4 % 3     ---(%)は割ったあまりを返す関数
1 : Int
```

####Float

`Float`は実数型です。

```elm
> 5 / 6
0.8333333333333334 : Float
> pi
3.141592653589793 : Float
> 2.0
2 : Float
```

####数字型(number)

`number`とは特殊な型で、`Int` と `Float`どちらにもなる型です。

```elm
> 1
1 : number
```

#### Char

Charは一文字だけの文字という型です。

```elm
> 'a'
'a' : Char
> "Hello"
"Hello" : String
```

####String

Stringは文字列型です。

```elm
> "hello"
"hello" : String
> String.join " " ["AA","BB","CC"]  --Stringのjoin関数は指定した文字を間に挟んでListの文字をくっつける関数
"AA BB CC" : String
```


#### Bool型

真理値を表す型です。

```elm
> True
True : Bool
> False
False : Bool
```

## コレクション型

専用の構文があるデータ構造を紹介します。

#### Lists

沢山のデータを格納したり、連続して処理するのに最適なのがList型です。
複数のデータを`[]`で囲んでコロンで区切るとList型になります。
データがない場合は空のリストになります。

```elm
> []
[] : List a
> [1,2,3]
[1,2,3] : List number   --numberの入ったList
> ["a", "b", "c"]
["a","b","c"] : List String   --stringの入ったList
```

リストは先頭に当たるheadと、先頭以外に当たるtailという概念が連続した構造になっています。この構造が再帰関数と相性がよく、Listモジュールには連続した処理を行う関数がそろっています。

```elm
--headを取り出す。
> import List
> List.head [1,2,3]
Just 1 : Maybe.Maybe number
--tailを取り出す。
> List.tail [1,2,3]
Just [2,3] : Maybe.Maybe (List number)
```

`::`は値をheadに加える演算子です。

```elm
--headに加える。さらに加えていく。
> 4 :: [1,2,3]
[4,1,2,3] : List number
> 6 :: 5 :: [4,1,2,3]
[6,5,4,1,2,3] : List number
```

`[数字..数字]`と書くとその間を埋めたリストを自動で作ってくれます。

```
> [1..4]
> [1,2,3,4]
> 1 :: [2,3,4]   
> 1 :: 2 :: 3 :: 4 :: []
```

List用の関数はCoreライブラリのListを参照してください。

#### Tuples

'()'で囲み、型をコロンで並べるとタプル型になります。
Listと違い、複数の種類の型でもタプルにすることが出来ます。

```elm
> (1, "2", True)
(1,"2",True) : ( number, String, Bool )
```

`(,)`はタプルにする関数でもあります。

```elm
> (,,,) 1 True 'a' []
(1,True,'a',[]) : ( number, Bool, Char, List a )
```

下の例のように、イコールの右辺にタプルを返す値または関数、左辺に`()`で囲んだ変数、とすると変数にタプルの値を取り出すことが出来ます。主にlet式の中で使います。

```elm
(x, y) = (1, 2)
> x
1 : number
```

#### Records

`{}`で囲み、プロパティを並べると、レコード型になります。  

```elm
myRecord =
 { style = "Blue",
   number = 1,
   isCool = True
 }
```

レコード型のプロパティの値には`レコード.プロパティ名`でアクセスできます。
さらに`.プロパティ名`という関数でも値を取り出せます。

```elm
> myRecord.style
"Blue" : String
> .style myRecord
"Blue" : String
```

レコードのプロパティを更新する構文があります。
コロンを付けて続けると同時に複数のプロパティを更新できます。
`{元にするレコード | 更新したいプロパティ = 値}`

```elm
> updatedRecord = { myRecord | style = "Red", number = 10, isCool = False }
> myRecord.style
"Blue" : String
> updatedRecord.style
"Red" : String
```

更新構文を使うと、`++x`や`x = x + 1 `のようなインクリメントが可能です。

```elm
{myRecord |number = myRecord.number + 1}
```

パターンマッチ出来る部分で、`{プロパティ名}`でパターンマッチして値を取り出すことが出来ます

```elm
{ style, number, isCool } = myRecord
> style
"Blue" : String
```

###Elmの特別な型

number、 comparable、 appendableという多相な型を内部で使っていて、組み込みの関数はその型を使っています。

numberは`Int`と`Float`  
comparableは `String`, `Char`,`Int`, `Float`, `Time`,`taple`  
appendable は`List` `String`  

```elm
(+) : number -> number -> number
(<) : comparable -> comparable -> Bool
(++) : appendable -> appendable -> appendable
```

```elm
> [1,2,3] ++ [4,5,6]
[1,2,3,4,5,6] : List number
> "hello" ++ "world"
"helloworld" : String
```

####　その他

データ構造は様々な特性があるので、場合にあったものを選択する必要があります。
他にも`Array`、`Dict`、`Set`といった型がCoreライブラリにあります。
