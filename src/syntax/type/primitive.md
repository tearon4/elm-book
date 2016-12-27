#Primitives

Elmに用意されている基本的な型と、専用の構文を紹介します。

###Int（整数型）

```elm
> 4 % 3     ---(%)は割ったあまりを返す関数
1 : Int
```

###Float（実数型）
数字をドットで区切ると、Float型と認識されます。

```elm
> 5 / 6
0.8333333333333334 : Float
> pi
3.141592653589793 : Float
> 2.0
2 : Float
```


###number（数字型）

`number`とは特殊な型で、`Int` と `Float`どちらにもなる型です。内部で使われています。

```elm
> 1
1 : number
```

###Char

シングルクォーテーションで囲むとChar型になります。
Char型は一文字だけの文字用の型です。

```elm
> 'a'
'a' : Char
> "Hello"
"Hello" : String
```

###String

ダブルクォーテーションで囲むと、文字列の型になります。

```elm
> "hello"
"hello" : String
> String.join " " ["AA","BB","CC"]  --Stringのjoin関数は指定した文字を間に挟んでListの文字をくっつける関数
"AA BB CC" : String
```


###Bool型

「True」と「False」は真理値を表すBool型として最初から定義されています。

```elm
> True
True : Bool
> False
False : Bool
```

##コレクション型

専用の構文があるデータ構造を紹介します。

###List

Elmでは複数のデータを`[]`で囲んでコロンで区切るとList型になります。

List型は、沢山のデータを格納したり、それらに連続して処理したい時に最適です。
データがない場合は空のリストになります。

```elm
> []
[] : List a
> [1,2,3]
[1,2,3] : List number   --numberの入ったList
> ["a", "b", "c"]
["a","b","c"] : List String   --stringの入ったList
```

`::`は値をheadに加える演算子です。

```elm
--headに加える。さらに加えていく。
> 4 :: [1,2,3]
[4,1,2,3] : List number
> 6 :: 5 :: [4,1,2,3]
[6,5,4,1,2,3] : List number
```


###Tuple

`()`で囲み、型をコロンで並べるとタプル型になります。

タプルはListと違い複数の種類の型でもタプルにすることが出来ます。

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

### Records

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

更新構文を使うと、`++x`や`x = x + 1 `にあたるインクリメントが可能です。

```elm
{myRecord |number = myRecord.number + 1}
```

パターンマッチ出来る部分で、`{プロパティ名}`でパターンマッチして値を取り出すことが出来ます

```elm
{ style, number, isCool } = myRecord
> style
"Blue" : String
```
