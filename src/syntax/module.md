#module:モジュール

Elmのソースコードを分割する仕組みがモジュールです。

moduleという構文で、ファイルにモジュール名を付けて外部へ関数や型を公開します。

importという構文で、他のモジュールを呼び出し使用することが出来ます。

`exposing`以下で内外に公開するものを細かく指定することが出来ます。

```elm
module Main exposing (..)    --モジュールに名前を付ける。

import Html expoisng (div)   --外部のモジュールを呼び出して使えるようにする。

main = div [] []             --外部のモジュールから呼び出した関数を使う。

```


##moduleを使い、モジュール名を付けて、外に出すものを指定する。

Elmファイルにモジュール名を付けるには、以下の様な構文で書きます。

```elm
module {モジュール名} exposing ({このモジュールの外に出す型や関数を指定})
```

モジュール名をつけると、外部からそのモジュール名で関数等を呼び出せるようになります。
（elm-makeがモジュールをどう検索するかは、elm-makeのページを参照してください。）

モジュール名はファイル名と同じ名前にしないといけません。また名前は大文字から始まるようにします。
例えば、Mainモジュールを定義するには、Main.elm(またはmain.elm)ファイルとなります。


`exposing`の右側のかっこの中にどの関数を外に出すのか指定します。
指定した関数と型しか外部からは使えません。ここの指定方法はimportも同じです。

###モジュールの外に向けて公開する

例えば以下の型と関数がモジュール内で定義されているとします。

```elm
type Hoge = A | B
hello = ""
world = ""
```

外へ出す指定の例と、外に出ることになる型と関数の対応です。

```elm
module Main exposing (..)              -- Hoge , hello , world
module Main exposing (Hoge,hello)      -- Hoge , hello
mudule Main exposing (Hoge(A,B),hello) -- Hoge , A , B , hello
mudule Main exposing (hello)           -- hello
```

型とデータ構築子を外に出すには、Hoge(A,B)という書き方をしています。


##importを使い、外のモジュールを使う。

importで外部のモジュールの型や関数を使うことが出来ます。

```elm
import List
import List exposing (..)
import List exposing (map)
```

`exposing`によって、細かく指定することが出来ます。

`exposing`の無い時に、importするモジュールの関数や型を使うには、モジュール名.対象と書きます。

```elm
import Task      --Taskモジュールをimport
import List

List.map ...
Task.map ...
```

`as`を使い、モジュール名に別名をつけることが出来ます。
長い名前を省略したりできます。

```elm
import Html.App as Html

Html.program ...          --使う時
```

`exposing`を使うと、モジュール名を付けずに使用することが出来ます。

```elm
-- unqualified imports  モジュール名を付ける必要がなくなります。
import Hello exposing (..)                        -- Hoge , hello , world
import Hello exposing ( Hoge )                    -- Hoge
import Hello exposing ( Hoge(..) )                -- Hoge, A , B
import Hello as Helo exposing ( Hoge(A) )         -- Hoge, A

Hello.hello  ---頭にモジュール名をつけても使える。
```

import時、他のモジュールと名前が衝突することがあります。

```elm
import List exposing (..)
import Task exposing (..)

map ...     --Error!　map関数はListにもTaskにもある。

```

その時は、importする関数を制限したり、モジュール名も書いてコンパイラが判断つくようにします。

```elm
import List exposing (head) --そもそもmapを出さない。

List.map .....    --どのモジュールの関数かわかるようにする。

```
