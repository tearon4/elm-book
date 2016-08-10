##関数

関数を定義するには変数同様`=`を使い関数名と引数を書きます。

```elm
{関数名}　{引数必要なだけ} = 関数の中身
twice n = 2 * n
tasu a b = a + b
```

関数を使うには、定義した関数名と関数にいれる値を並べます。すると処理が行われ結果が返ります。

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

引数部分でパターンマッチを使うことが出来ます。（asを使うことで別名をつけることが出来ます。）

```elm
model = {counter : Int}

update msg ({counter} as model) =              -- パターンマッチとas構文
             let counter' = counter + 1
             in {model | counter = counter'}

```

演算子も関数です。

```elm
(+) : numbers -> numbers -> numbers
```

メモ；`+`にカッコがついて`(+)`と表記されています。`+`などの演算子は()でくるむと関数扱いになります。

```elm
> 5 + 6
11 : number
`
> (+) 5 6
11 : number

> List.foldl (+) 0 [1..4]   --関数を引数に取る関数に、(+)を渡している。
10 : number
```


##関数の適用順

関数や演算子には適用する順番があります。
カッコを付けることで、優先順位を変えることが出来ます。

```elm
5 + 2 * 4 == 13
(5 + 2) * 4 == 28

twice (2 + 3)

```

以下のように３つ関数が並んでいると、左から順に解釈されてしまいます。

```elm
twice sqare a  == 
((twice sqare) a )
```

(<|)と(|>)を使うと関数の適用順を変えることが出来ます。

```elm
(hoge (huga (hoo baa))) ==
hoge <| huga <| hoo baa

((getNantoka aresite) koresite) ==
getNantoka |> aresite |> koresite

```


##let in

let inを使うと、内部変数を定義できます。

```elm
f a b =
    let
      x = a * 8     --中でx、yを定義する
      y = b ^ 2     --先頭行は揃える
    in
      x + y
```

複雑な関数をわかりやすくします。

関数の返り値がタプルの場合、受け取ることが出来ます。

```elm
nantoka a = (0 , 0)

hoge : Model -> Model
hoge model =
  let (a,b) = nantoka kantoka   --タプルを受け取る
  in  a

```

let inの中の関数にも型表記を付けることが出来ます。

```elm
let
  name : String
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

関数の名前が必要ないとき、省略して書きたい時、
関数だけの要素がほしい時に使います。

かっこで包んで、`\`アンダーバーを書いて、引数を書かいて、イコールの代わりに矢印を使います。

```elm
(\a b -> a + b) 
tasu a b = a + b　==　
tasu = (\a b -> a + b)

```

関数が必要なところに書くと便利です。

```elm
List.indexdMap (\idx a -> idx * a) [2..5]

```
