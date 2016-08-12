#Bogdanp/elm-combine : パーサーコンビネータ

パーサーコンビネータライブラリを使ってパーサーを書いてみましょう。

###コンビネータ

パーサーコンビネータのコンビネーターとは、関数を組み合わせて新しい関数を返す関数をそう呼びます。
例えば２つの関数をとって一つにする合成演算子(<<)はコンビネータです。

```elm
(<<) : (b -> c) -> (a -> b) -> (a -> c)
(<<) g f x =
  g (f x)
```

###パーサー

パーサーコンビネータのパーサーとは文字（記号）列を受け取って、頭から一文字づつ読んでいって、何かをするプログラムを指します。

例えば

* 文字列を、定めたルール・仕様・文法にそったものか判断する。（判定、構文解析）
* 文字列を、定めたルール・仕様・文法にそって別の文字列に変換する。（書き換え、コンパイラ、トランスパイラ、翻訳）
* 文字列を定めたルール・仕様・文法にそって実行、解釈する。（DSLとかevalとか）
* 文字列の中から特定の文字列を検索する（これは正規表現ライブラリの方が得意なことが多い、パーサーコンビネータだと書くの難しい）

といったプログラムです。

###パーサーコンビネータ

つまりパーサーコンビネータとは、関数を構成してパーサー関数を作る関数のライブラリです。
関数を組み合わせるようにパーサーを書くことが出来ます。

Elmパッケージライブラリには２つのパーサーコンビネータライブラリがあります。今回はエラー処理も場所もわかるBogdanp/elm-combineというのを例に説明します。パーサーコンビネータプログラミングは関数型プログラミングの練習にもなると思います。

メモ：パーサーコンビネータライブラリの多くは、Haskellのparsecライブラリを参考にしています。

メモ；他に似たツールとして「正規表現ライブラリ」と「パーサージェネレータ」があります。

正規表現は正規表現を渡すとパターンマッチを自動生成します。
パーサージェネレータは構文規則を渡すと、その構文解析器を自動生成します。
それらと比べると、パーサーコンビネータは一文字づつ文字列を読んでくプログラム（パーサー）を書きやすくするツールと言えます。


##実行

組み合わせて作ったパーサーを実行する方法を先に見てみます。  
parse関数で実行します。

```elm
parse : Parser res -> String -> (Result res, Context)

```

parse関数はパーサーと、解析する文字列を受け取ると、パーサーでパースを実行します。結果はResultとContextのタプルを返します。
Contextには、パースしたあと残った文字列と、どこまでパースしたかの数が入っています（次のパーサーの開始位置）。

例

```elm
targetStr = "aaaaa"

yourParser = many <| string "a"

result = parse yourParser targetStr   --(Ok ["a","a","a","a","a"],{ input = "", position = 5 })
```

パースに失敗すると、Errになります。

```elm
parse (string "ab") "abc"  --(Ok "ab",{ input = "c", position = 2 })
parse (string "ab") "x"    --(Err (["expected \"ab\""]),{ input = "x", position = 0 })
```

Errになるとエラー文が入っています。上記だと「ab」が必要と入っています。このエラー部分はいじることが出来ます。

##パーサを作るコンビネータ

パーサーコンビネータを見ていきます。


###succedd
必ず成功するパーサーを作る関数です。
必ず失敗するパーサを作る関数もあります。

```
succeed : res -> Parser res
```

```elm
parse (succeed "3") "" --  == Ok "3",{ input = "", position = 0 }
```

###string

渡した文字列との合致するかみるパーサーを以下略

```
string : String -> Parser String
```

```elm
parse (string "a") ""         -- == (Err (["expected \"a\""]),{ input = "", position = 0 })
parse (string "a") "a"        -- == (Ok "a",{ input = "", position = 1 })
parse (string "ab") "abcde"   -- == (Ok "ab",{ input = "cde", position = 2 })
parse (string "abc") "a"      -- == (Err (["expected \"abc\""]),{ input = "a", position = 0 })]

```

###regex

正規表現を使ったパーサー

```elm
regex : String -> Parser String
```
正規表現だと読み飛ばしてくれたりしますが、パーサーなので一文字づつに行う。

```elm
parse (regex "a+") "aaabbbcc"      -- == (Ok "aaa",{ input = "bbbcc", position = 3 })
parse (regex "a+") "bbbcccaaaddd"  -- == (Err (["expected input matching Regexp /^a+/"]),{ input = "bbbcccaaaddd", position = 0 })
parse (regex "a*") "cdef"          -- == (Ok "",{ input = "cdef", position = 0 })
```

###or

パーサーどちらかが成功しないかみる`or`パーサー。(<|>)は演算子バージョン。

```elm
or : Parser res -> Parser res -> Parser res
(<|>) : Parser res -> Parser res -> Parser res
```

```elm
p = or (string "a") (string "b")

parse p "a"      --  == (Ok "a",{ input = "", position = 1 })
parse p "b"      --  == (Ok "b",{ input = "", position = 1 })
parse p "c"      --  == (Err (["expected \"a\"","expected \"b\""]),{ input = "c", position = 0 })]
```

###many

受け取ったパーサーが０回かそれ以上連続でヒットするかみる関数です。
返すのはリストです。1回かそれ以上連続のmany1もあります。

```elm
many : Parser res -> Parser (List res)
```

```elm
pm = many (string "a")

parse pm ""  --   == (Ok [],{ input = "", position = 0 })
parse pm "z"  --  == (Ok [],{ input = "z", position = 0 })
parse pm "a"  --  == (Ok ["a"],{ input = "", position = 1 })
parse pm "aaa"  --== (Ok ["a","a","a"],{ input = "", position = 3 })
parse pm "aabaa" --==(Ok ["a","a"],{ input = "baa", position = 2 })]
```

###map

パース結果を変化させます。パースして取り出した文字等を、Elmの型に変化させたり、Elmの関数へマップする関数の一つになります。

```elm
map : (res -> res') -> Parser res -> Parser res'
```

```elm
parse (map String.toUpper (string "a")) "a" --== (Ok "A", { input = "", position = 1 })
```

##他にも

他にも沢山コンビネータがあります。いろいろ試してみてください。次は計算機を作るための言語の話です。
