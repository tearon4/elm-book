#関数

関数周りの構文についてです。

##関数の定義と適用

関数を定義するには変数同様に、`=`イコールを使います。

関数名と引数を以下のように書きます。

```elm
{関数名}　{引数} ... = ｛関数の中身｝
```

例

```elm
twice n = 2 * n
tasu a b = a + b
```

関数を使用するには、定義した関数名と、関数に入れる値を並べます。すると処理が行われ結果が返ります。値に対して関数を適用するともいいます。

```elm
> twice n = 2 * n
<function> : number -> number
> twice 10
20 : number
> a = 9
9 : number
> twice a
18 : number
```

Elmでは中置き演算子も関数です。Basicsライブラリには以下のような関数が定義されています。

```elm
(+) : numbers -> numbers -> numbers
```

`+`にカッコがついて`(+)`と表記されています。`+`などの中置き演算子は`()`でくるむと、関数扱いになります。

```elm
> 5 + 6
11 : number
`
> (+) 5 6
11 : number

> List.foldl (+) 0 [1..4]   --関数を引数に取る関数に、(+)を渡している。
10 : number
```

##パターンマッチ

関数の引数部分で使うことが出来る構文に、パターンマッチとas構文というのがあります。

パターンマッチは、型に合わせて引数の表記を合わせると、型から値を取り出せるという構文です。

```elm
type Id = Id Int      -- Idデータ構築子で定義される、Id型。

getNum : Id -> Int    -- Id型を引数に取るgetNum関数
getNum (Id num) =
  num
```

上記の引数で`(Id num)`としている部分が、パターンマッチです。
numにはInt型が入っています。このように引数の書き方で、型から値を取り出すことが出来ます。

またレコード型や、タプル型の場合は以下のように取り出せます。

```elm
type alias User = { id : Int
                  , name : String }

getName : User -> String
getName {name} =
  name


type alias Position = ( Int , Int )


getX : Position -> Int
getX (x,y) =
  x
```

##as構文

asというキーワードを使うと、引数に改めて新しい名前を付けることが出来ます。
パターンマッチと併用すると、値を取り出しつつ、取り出さなかったように、関数内で使うことが出来ます。

```elm
model = {counter : Int}                        --counterというプロパティがある値

update msg ({counter} as model) =              -- パターンマッチとas構文。as構文とは引数部分に別名をつけることが出来る構文です。
             let counter' = counter + 1        --counter変数を使っている。
             in {model | counter = counter'}   -- model変数を使っている。

```


##関数の適用順

関数や演算子には適用する順番があります。
カッコを付けることで、優先順位を変えることが出来ます。

```elm
5 + 2 * 4 == 13
(5 + 2) * 4 == 28

twice (2 + 3)         -- 2 + 3 を行ってからtwiceを適用

```

以下のように３つ関数が並んでいると、左から順に解釈されます。

```elm
twice sqare a  ==
((twice sqare) a )
```

(<|)と(|>)という中置き演算子を使うと関数の適用順を変えることが出来ます。

```elm
(hoge (huga (hoo baa))) ==
hoge <| huga <| hoo baa

((getNantoka aresite) koresite) ==
getNantoka aresite |> koresite

```

##関数の部分適用

関数は引数に代入された時に、引数すべてを満たさない場合は、新たに残りの引数を受け取る関数になります。このことを部分適用出来るといいます。

elm-replで確認してみます。

```elm
> add n1 n2 = n1 + n2
<function> : number -> number -> number
```

まずaddという関数は引数に２つ数字を取ります。ここに引数一つだけ適用してみます。

```elm
> add 10
<function> : number -> number
```

すると、型が一つ消費され、新たにnumber -> numberという関数になっています。

ここに残りの引数を埋める事ができます。

```elm
> newAdd = add 10
<function> : number -> number
> newAdd 5
15 : number
> newAdd 6
16 : number

```

Elmではすべての関数は部分適用できるようになっています。
このことは、いろいろなところで記述を便利にしています。最初は型に注意して、使用していくといいでしょう。

```elm
> import List
> List.map (add 10) [1..5]
[11,12,13,14,15] : List number

```


##let in式

let in式を使うと、関数の内部で変数を定義できます。

```elm
f a b =
    let
      x = a * 8     --中でx、yを定義する
      y = b ^ 2     --先頭行は揃える
    in
      x + y         --内部変数を使う。
```

let句の中で変数を並べて定義して、定義した変数をin句内で使用することが出来ます。

let inの中の関数にも型表記を付けることが出来ます。

```elm
let
  name : String            --型表記
  name =
    "Hermann"

  increment : Int -> Int
  increment n =
    n + 1
in
  increment 10

```


##無名関数

名前のない関数を定義できます。

関数の名前が必要ない時や、省略して書きたい時、
関数だけの要素がほしい時に使います。

かっこで包んで、`\`バックスラッシュを書いて、引数を書かいて、イコールの代わりに矢印を使います。

```elm
(\a b -> a + b)
```

以下の２つの定義は同じものです。

```elm
tasu a b = a + b

tasu = (\a b -> a + b)

```

関数が必要なところに書くときに便利です。

```elm
List.indexdMap (\idx a -> idx * a) [2..5]

```
