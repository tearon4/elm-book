##構文

Elmの公式サイトに構文全体を見渡せるページがあるので、目を通してみると良いです。[http://elm-lang.org/docs/syntax](http://elm-lang.org/docs/syntax)
またElmの構文はHaskellに似ているので、Haskellのチュートリアルサイトや入門本も参考になると思います。

ここでも簡単に全体を見てみます。
各構文の詳しい説明は次ページ以降で。

##コメント

一行コメント

```
-- comment !!
```

複数行コメント

```
{-
  piyo
  piyo  
-}
```

ドキュメント用コメント

-->elm-docへ

##リテラル

非負値(Bool)は「True」と「False」。
メモ：0、1、Nothingは非負値になりません、区別されます。

```
True  : Bool
False : Bool
```

数値をそのまま書くとnumber(Int、Floatどちらにもなる特殊な型)、少数点をつけるとFloat型になります。

```
42    : number
3.14  : Float
```

シングルコーテーションで一文字を表現するChar
ダブルコーテーションで文字列型（String）

```

'a'   : Char
"abc" : String

```

複数行ある文字列型を扱うにはダブルコーテーションを３つ並べます。

```

mark =
 """
## Usage
 * json
 * markdown
 * etc ..

"""

```

###List

'[]'でListになります。

```
[1..4]           
[1,2,3,4]
1 :: [2,3,4]
1 :: 2 :: 3 :: 4 :: []
```


##変数、関数の定義

変数

```
age = 10
word = "Hello World"

```

関数

```
add10 : Int -> Int
add10 n = n + 10

helloWorld name name2 = "hello , " ++ name ++ " " ++ name2

```

#型の表記

変数や関数には、型を明示することが出来ます。

```

age : Int
age = 15

word : String
word = "hello"

add10 : Int -> Int
add10 n = n + 10

```

#型の定義

新しい型を定義することができます。

```
type Id = Id Int
type Fruit = Orange | Peach

```
type alias を使うと型に別名を付ける事ができます。

```
type alias Age = Int
type alias Name = String

type User = User Age Name

isOver15 : Age -> Bool

```


レコード表記という構文を使うと、名前を振った直積型を定義できます。

```
type alias User = {id : Int , name : String}

init : User
init = {id = 10 , name = ""}
```

#case式、if式、
条件によって処理を分けたい時に使うのが、case式とif式です。

if式

```
if a < 1 then
    "It's zero"
else
    "Non-zero"

-- Multi-line.
if y > 0 then
    "Greater"   
else if x /= 0 then
    "Not equals"
else
    "silence"


```

case式

```
type User
    = Activated
    | Deleted

update state =
  case state of
    Activated ->
      -- do something
    Deleted ->
      -- do again
```

#Let in 式

```
let
  x = 3 * 8
  y = 4 ^ 2
in
  x + y
```



#モジュール

Elmはソースコードを別ファイルに分け、読み込むことが出来ます。モジュールと言います。

```
module Test exposing (..) --モジュール名を付けて外にだす。

import Hoge exposing (hello) --モジュールをインポート

```

exposingの書き方で、どの関数や型構築子を出すか指定できます。

```
-- モジュール内で定義した型と値をエクスポート
module Mymodule exposing (Type, value)

--
module Mymodule  exposing
    ( Error(Forbidden, Timeout) --型とその構築子を指定
    , Stuff(..)
    )

type Error
    = Forbidden String
    | Timeout String
    | NotFound String
```

import
モジュールをインポートします。書き方でインポートの仕方が変わります。

```
-- qualified imports
import String                       --モジュール名.関数名等 String.toUpper, String.repeat
import String as Str                --モジュールにつけた別名.関数名等 もできるように Str.toUpper, Str.repeat

-- unqualified imports  モジュール名を付ける必要がなくなります。
import Mymodule exposing (..)                 -- Error, Stuff
import Mymodule exposing ( Error )            -- Error　のみ
import Mymodule exposing ( Error(..) )        -- Error, Forbidden, Timeout　型とその構築子すべて
import Mymodule exposing ( Error(Forbidden) ) -- Error, Forbidden
```


###関数の適用順、パイプ演算子

関数には適用される順番がありますが、それを操作するパイプ演算子(<|)、(|>)というのがあります。

```hs

hiku2 (add10 3) == hiku2 <| add10 3 == add10 3 |> hiku2

```

この演算子を使うと、わかりやすく処理の流れを書くことができます。

```
dot' =
  circle 10
    |> filled blue
    |> move (20,20)
    |> scale 2
```

###パターンマッチ

パターンマッチとは、表記を合わせれば型から値を取り出すことができる、という構文です。

例えばId型というのを定義して、Id 10というId型の値を作ってみます。

```
type Id = Id Int

id : Id
id = Id 10

```

Id型を受け取って中の数字を取り出す関数は以下のように書けます。

```

getNum : Id -> Int
getNum (Id a) = a

```

引数部分でId aと書いてありますが、これがパターンマッチといわれる書き方で、aの部分にはIdの中身が勝手に入っています。

パターンマッチは関数の引数部分や、case式の部分で出来ます。

```
type Chara = {hp : Int}

HpToStr : Chara -> String
HpToStr {hp} = toString hp

type Msg = Add Int

case msg of
    Add n ->

```


###レコード構文

型を定義するとき、レコード型といわれる書き方で型を定義できます。
レコード型で型を定義すると、自動で関数が用意されます。
レコード型には専用の更新用の構文があります。

レコード型の値を宣言

```
a = { name = "kiyohiko" , hp = 10}
```

型をレコード型で定義

```
type User = {hp : Int , name : String}

```

値を取り出す。

```
.hp {hp = 10}

```

レコード型を更新する。

```
 a = {hp = 100}
 {a | hp = 20}
```


##JavaScript とのやりとり

```
-- Elmに入ってくる値
port prices : (Float -> msg) -> Sub msg

-- Elmから出て行く値
port time : Float -> Cmd msg

```

Js側でportを使って値や関数を、送ったり受け取ったりすることが出来ます。

```

var app = Elm.Example.worker();

app.ports.prices.send(42);
app.ports.prices.send(13);

app.ports.time.subscribe(callback);
app.ports.time.unsubscribe(callback);
```
