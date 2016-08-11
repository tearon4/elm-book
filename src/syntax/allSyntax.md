##構文全体

簡単に全体を見てみます。

##コメント

一行コメント

```elm
-- comment !!
```

複数行コメント

```elm
{-
  piyo
  piyo  
-}
```

##リテラル

非負値(Bool)は「True」と「False」です。
メモ：0、1、Nothingは非負値になりません、区別されます。

```elm
True  : Bool
False : Bool
```

数値をそのまま書くとnumber(Int、Floatどちらにもなる特殊な型)、少数点をつけるとFloat型になります。

```elm
42    : number
3.14  : Float
```

シングルコーテーションで一文字を表現するChar型
ダブルコーテーションで文字列型（String）になります。

```elm
'a'   : Char
"abc" : String
```

複数行ある文字列型を扱うにはダブルコーテーションを３つ並べます。

```elm

mark : String
mark =
 """
## Usage
 * json
 * markdown
 * etc ..

"""

```

##List

'[]'でListになります。

```elm
[1..4]           
[1,2,3,4]
1 :: [2,3,4]
1 :: 2 :: 3 :: 4 :: []
```


##変数、関数の定義

変数

```elm
age = 10
word = "Hello World"

```

関数

```elm
add10 : Int -> Int
add10 n = n + 10

helloWorld name name2 = "hello , " ++ name ++ " " ++ name2

```

##関数の適用

関数を\`でくるむと中置き記法ができます。

```elm
max 5 10 ==
5 `max` 10

```

##型の表記

変数や関数には、型を明示することが出来ます。

```elm
age : Int
age = 15

word : String
word = "hello"

add10 : Int -> Int
add10 n = n + 10
```

##型の定義

新しい型を定義することができます。

```elm
type Id = Id Int
type Fruit = Orange | Peach
```

type alias を使うと型に別名を付ける事ができます。

```elm
type alias Age = Int
type alias Name = String

type User = User Age Name

isOver15 : Age -> Bool
```

##レコード型

レコード表記という構文を使うと、レコード型を定義できます。
レコード型はjavasciptのオブジェクトに近いものです。

```elm
type alias User = {id : Int , name : String}

init : User
init = {id = 10 , name = ""}
```

###レコード構文

レコード型で型を定義すると、自動で関数が用意されます。
レコード型には専用の更新用の構文があります。

値を取り出す。

```elm
> .hp {hp = 10}
10 : number
```

レコード型を更新する。

```elm
> hoge = {hp = 100}
{ hp = 100 } : { hp : number }
> {hoge | hp = hoge.hp + 20}
{ hp = 120 } : { hp : number }
```

##case式、if式、

case式とif式で処理を分岐します。

if式　
条件によって処理が分岐します。

```elm
if a < 200 then
    "ok"
else
    "予算over"

```

case式
パターンによって処理を分岐します。

```elm
case {知りたいもの} of
     {一つ目} -> ...
     {二つ目} -> ...

case n of
    2 ->
    8 ->
    _ -> --_（アンダーバー）はすべてにマッチします。
```

case式は型を必ず網羅しないといけません。

```elm
type Msg
    = Get
    | Move

update msg state =
  case msg of
    Get ->
      --
    Move ->
      --
```

##Let in 式

関数の中でletin式を使うと、内部変数を定義できます。

```elm
test a y =
      let
          x = a * 8
      in  x + y
```

##モジュール:module

Elmはソースコードを別ファイルに分け、読み込むことが出来ます。

```elm
module Test exposing (..) --モジュール名を付けて外にだす。

import Hoge exposing (hello) --モジュールをインポート

```

exposingの書き方で、どの関数や型構築子を出すか指定できます。

```elm
-- モジュール内で定義した型と値をエクスポート
module Hello exposing
    ( Hoge(A,B) --型とその構築子を指定
    , hello
    )

type Hoge
    = A
    | B
hello = ""
world = ""
```

import
モジュールをインポートします。書き方でインポートの仕方が変わります。

```elm
-- qualified imports
import String                       
import String as Str                
String.repeat ...

-- unqualified imports  モジュール名を付ける必要がなくなります。
import Hello exposing (..)                -- Hoge , hello , world
import Hello exposing ( Hoge )            -- Hoge
import Hello exposing ( Hoge(..) )        -- Hoge, A , B
import Hello exposing ( Hoge(A) )         -- Hoge, A
```


###関数の適用順、パイプ演算子

関数には適用される順番がありますが、それを操作するパイプ演算子(<|)、(|>)というのがあります。

```elm
hiku2  (add10 3) ==
hiku2 <| add10 3 ==

add10 3 |> hiku2

```

この演算子を使うと、わかりやすく処理の流れを書くことができます。

```elm
dot' =
  circle 10
    |> filled blue
    |> move (20,20)
    |> scale 2
```

###パターンマッチ

パターンマッチとは、表記を合わせれば型から値を取り出すことができる、という構文です。

```elm
type Id = Id Int

id : Id
id = Id 10

```

Id型を受け取って中の数字を取り出す関数は以下のように書けます。

```elm
getNum : Id -> Int
getNum (Id a) = a

```

引数部分がパターンマッチといわれる書き方で、aの部分にはIdの中身が勝手に入っています。

パターンマッチは関数の引数部分や、case式の部分で出来ます。

```elm
type alias Chara = { hp : Int}

HpToStr : Chara -> String
HpToStr {hp} = toString hp    ---レコード型をパターンマッチ

type Msg = Add Int

update msg state =
      case msg of                
        Add n ->              --case式内でパターンマッチ

```



##JavaScript とのやりとり : port

```elm
-- Elmに入ってくる値
port prices : (Float -> msg) -> Sub msg

-- Elmから出て行く値
port time : Float -> Cmd msg

```

Js側でportを使って値や関数を、送ったり受け取ったりすることが出来ます。

```js
var app = Elm.Example.worker();

app.ports.prices.send(42);               //JsからElmへ送る。
app.ports.time.subscribe(callback);      //ElmからJsへ来るので受け取る。
app.ports.time.unsubscribe(callback);
```
