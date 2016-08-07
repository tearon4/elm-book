#elm-make

elm-makeはElmで書かれた.elmファイルを依存関係を解決してコンパイルします。

elm make / elm-make

```
#elmファイルのコンパイル htmlファイルになる。
elm-make Hello.elm
```
デフォルトで、index.htmlというファイルになります。

outputオプションで、ファイルの名前や、どのファイルの種類か、どこに出力するかを指定することが出来ます。

```
elm-make Hello.elm --output Hello.js
```

#依存関係の解決

外部のモジュールを使っていたら、自動で検索してコンパイルします。

```
import Html  --elm-stuffフォルダの中に探しに。
import Hoge  --ユーザーが作ったモジュール
```

ユーザー定義のモジュールがあった場合、そのファイルを探しにいく必要があります。この時に検索する場所はelm-package.jsonで指定することができます。


```
"source-directories": [
"."
],

```
source-directoriesという項目で指定できます。
デフォルトで"."があって、これはこのjsonファイルがあるフォルダということです。これにtestフォルダを加えるなら以下のようにします。

```
"source-directories": [
    ".",
    "test"
],
```

```
test ------ Hoge.elm
Hello.elm
```
##コロンのついたモジュール名
フォルダ名と、モジュール名によっては、source-directoriesにフォルダを加えなくても検索が可能です。

フォルダ名をTestとします。
ファイルの関係は以下とします。

```
Test ------ Hoge.elm
Hello.elm
```

elm-package.jsonのsource-directoriesが以下になってるとします。

```
"source-directories": [
    "."
],

```

Hogeファイルのモジュール名を以下のようにフォルダ名.モジュール名にします。

```
module Test.Hoge exposing (..)
```

インポート側を以下のように書きます。

```
import Test.Hoge
```

すると検索されてコンパイル出来ます。
