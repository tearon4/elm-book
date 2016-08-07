#module

Elmのソースコードを分割するシステムについて説明します。

moduleという構文でファイルにモジュール名を付けて、importという構文で他のモジュールを呼び出し使用することが出来ます。

```
module Main exposing (..)  -- モジュールに名前を付ける。

import Html expoisng (div) -- 外部のモジュールを呼び出して使えるようにする。

main = div [] [] --呼び出した関数を使う。

```
moduleでモジュール名を付けて、importで外部のモジュールを読み込みます。
exposing以下で、読み込んだり外部に出したりする関数、型を細かく指定することが出来ます。


importの記述のしかたで、ソースコード内で使うための記述のしかたが変わります。



モジュール名はファイル名と同じ名前にしないといけません。
例えば、Main.elmファイルなら、Mainとなります。

例外でルートになるファイル（elm-makeに指定するファイル）にはモジュール名を付けなくても、自動でMainというモジュール名になります。

モジュール名のついたElmファイルは、elm-makeが検索して自動でリンクしてコンパイルしてくれるわけですが、
検索する場所は、elm-packageファイルで設定することが出来ます。
検索する場所にある、フォルダに入れたモジュールは、モジュール名をファルダ名.モジュール名とする必要があります。



#module

Elmファイルにモジュール名を付けるには以下の様な構文で書きます。

```
module {モジュール名} exposing ({このモジュールの外に出す型や関数をかく})
```

例えば、モジュールにMainという名前を付けて、helloという関数を外に出したいなら、



```
module Main exposing (..)
module Main exposing (Hoge,hello)
mudule Main exposing (Hoge(A,B),hello)

```
importという文字で依存パッケージの記述をします。

フォルダを作ってモジュールを分けるには

```
module Test.A exposing (..)
```
フォルダ名、コロン、モジュール名と書くと、ルートから検索できる

```
"source-directories": [
    "."
],
```

import

```
import Html
import Html expoisng (div)
import Html exposing (Html,div)
import Html.App exposing (..)
import Html.App as Html exposing (..)

Html.Attribute
Html

```



#JavascriptからElmビルドjsを呼び出すとき。

ElmをJsファイル出力すれば、Jsから呼び出すことができます。

以下の様なElmファイルがあった時

```
module Main exposing (..)

```
