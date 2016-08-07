#関数の定義

関数を定義するには変数同様`=`を使います。

```

{関数名}　{引数...} = 関数の中身

```

変数を何も無いところから定数を返す関数、と見る流儀もあるそうです。

演算子も関数です。

```
(+) : numbers -> numbers -> numbers
```

メモ；`+`にカッコがついて`(+)`と表記されています。`+`などの演算子は()でくるむと関数扱いになります。

```
5 + 6
(+) 5 6

List.foldl 0 (+) [1..4] ==
```


#()と(<|) (|>)

関数や演算子には適用する順番があります。
カッコを付けることで、優先順位を変えることが出来ます。

```
5 + 2 * 4 == 13
(5 + 2) * 4 == 28

hoge (a b)

```

以下のように３つ並んだ物があると、左から順に解釈されます。

```
hoge a b  ==
((hoge a) b)
```

(<|)と(|>)を使うと関数の適用順を変えることが出来ます。

```
(hoge (huga (hoo baa))) ==
hoge <| huga <| hoo baa

((getNantoka aresite) koresite) ==
getNantoka |> aresite |> koresite

```
処理の流れをわかりやすくします。


#let in

let inを使うと、内部変数を定義できます。

```
let
  x = 3 * 8
  y = 4 ^ 2
in
  x + y
```

let inを使うことで、複雑な関数をわかりやすくします。

```

hoge : Model -> Model
hoge model =
  let (a,b) = hantoka kantoka --関数の返り値がタプルのばあい、パターンマッチで受け取ることが出来ます。
  in {model | a = a}

```

let inの中の関数にも型表記を付けることが出来ます。

```
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


#無名関数

関数だけ、
