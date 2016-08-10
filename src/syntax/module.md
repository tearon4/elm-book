#モジュール:module

Elmのソースコードを分割する仕組みについて説明します。

moduleという構文でファイルにモジュール名を付けて外部へ関数や型を公開して、  
importという構文で他のモジュールを呼び出し使用することが出来ます。

```elm
module Main exposing (..)    --モジュールに名前を付ける。

import Html expoisng (div)   --外部のモジュールを呼び出して使えるようにする。

main = div [] []             --外部のモジュールから呼び出した関数を使う。

```

`module`でモジュール名を付けて、`import`で外部のモジュールを読み込みます。
`exposing`以下で細かく指定することが出来ます。
importの記述のしかたで、ソースコード内で使うための記述のしかたが変わります。

##module

Elmファイルにモジュール名を付けるには以下の様な構文で書きます。

```
module {モジュール名} exposing ({このモジュールの外に出す型や関数を指定})
```

モジュール名をつけると、外部からそのモジュール名で関数等を呼び出せるようになります。
（コンパイラがモジュールをどう検索するかは、elm-makeのページを参照してください。）

モジュール名はファイル名と同じ名前にしないといけません。
例えば、Main.elmファイルなら、Mainとなります。


`exposing`の右側のかっこの中にどの関数を外に出すのか指定します。
指定した関数と型しか外部からは使えません。ここの指定方法はimportも同じです。


例えば以下の型と関数が定義されているとします。

```elm
type Hoge = A | B
hello = ""
world = ""
```

指定の仕方と対応です。

```elm
module Main exposing (..)              -- Hoge , hello , world
module Main exposing (Hoge,hello)      -- Hoge , hello
mudule Main exposing (Hoge(A,B),hello) -- Hoge , A , B , hello
mudule Main exposing (hello)           -- hello
```

型と型構築子を外に出すには、Hoge(A,B)としなければならないことに注意です。


##import 

importで外部のモジュールの型や関数を使うことが出来ます。


`exposing`の無い時は、モジュール名.対象と書きます。

```elm
import Task
import List

List.map ...
Task.map ...
```

`as`を使い、モジュール名に別名をつけることが出来ます。
長い名前を省略したりできます。

```elm
import Html.App as Html
Html.program ...
```

`exposing`を使うと、モジュール名を付けずに使用することが出来ます。

```
-- unqualified imports  モジュール名を付ける必要がなくなります。
import Hello exposing (..)                        -- Hoge , hello , world
import Hello exposing ( Hoge )                    -- Hoge
import Hello exposing ( Hoge(..) )                -- Hoge, A , B
import Hello as Helo exposing ( Hoge(A) )         -- Hoge, A

Hello.hello  ---頭にモジュール名をつけても使える。
```

import時、他のモジュールと名前が衝突することがあります。その時はモジュール名をつけるなどして区別させます。