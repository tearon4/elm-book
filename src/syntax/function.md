#関数

関数周りの構文についてです。

##関数の定義と適用

関数を定義するには変数同様`=`を使い関数名と引数を書きます。

```elm
{関数名}　{引数} ... = ｛関数の中身｝
twice n = 2 * n
tasu a b = a + b
```

関数を使うには、定義した関数名と、関数に入れる値を並べます。すると処理が行われ結果が返ります。

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

##引数部分で使うことが出来る構文

パターンマッチとas構文

引数部分にはパターンマッチという、特定の表記を合わせると、型から値を取り出せる構文を使うことが出来ます。

as構文とは引数部分に別名をつけることが出来る構文です。

```elm
model = {counter : Int}

update msg ({counter} as model) =            -- パターンマッチとas構文
             let counter' = counter + 1      --counter変数を使っている。
             in {model | counter = counter'} -- model変数を使っている。

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
      x + y         --内部変数を使う。
```

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

関数の名前が必要ない時、省略して書きたい時、
関数だけの要素がほしい時に使います。

かっこで包んで、`\`アンダーバーを書いて、引数を書かいて、イコールの代わりに矢印を使います。

```elm
(\a b -> a + b)
tasu a b = a + b　==　
tasu = (\a b -> a + b)

```

関数が必要なところに書くときに便利です。

```elm
List.indexdMap (\idx a -> idx * a) [2..5]

```
