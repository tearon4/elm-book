#module

Elmのモジュールシステムについての説明になります。
Elmでは一行目にmoduleのような文字と
importという文字で依存パッケージの記述をします。


```
module Main exposing (..)

import Html expoisng ()

```

Elmファイルにモジュール名を付けるには以下の様な構文で書きます。

```
module {モジュール名} exposing ({外に出す型や関数})
```
例

```
module Main exposing (..)
module Main exposing (Hoge,hello)
mudule Main exposing (Hoge(A,B),hello)

```

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
