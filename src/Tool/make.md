#コンパイルする:elm-make

elm-makeはElmで書かれた.elmファイルを依存関係を解決してコンパイルします。

コマンド(mac / win)
elm make / elm-make

```
#elmファイルのコンパイル。htmlファイルになります。
elm-make Hello.elm
```
デフォルトで、index.htmlというファイルになります。

outputオプションで、ファイルの名前や、どのファイルの種類か、どこに出力するかを指定することが出来ます。

```
#jsファイルで出力します。
elm-make Hello.elm --output Hello.js

#別名、指定の場所で出力します。
elm-make Hello.elm --output ../dist/test.html

```

##依存関係の解決

外部のモジュールを使っていたら、elm-makeは自動で検索してコンパイルします。

```
import Html  --elm-stuffフォルダの中に探しに。
import Hoge  --ユーザーが作ったモジュール
```

elm-makeが検索する場所をelm-package.jsonで指定することができます。


```
...
"source-directories": [
"."
],

```

source-directoriesという項目で指定できます。
デフォルトで`"."`が指定されています。これはこのelm-package.jsonファイルがあるフォルダを検索するということです。
これにtestフォルダを加えるなら以下のようにします。

```
"source-directories": [
    ".",
    "test"
],
```

ファイルの場所が以下のような状態ならこれでHogeモジュールを検索できます。
```
test ------ Hoge.elm
Hello.elm
```
##コロンのついたモジュール名

モジュール名を「フォルダ名.モジュール名」にすると、source-directoriesにフォルダを加えなくても検索が可能です。

例として、フォルダ名をTestとします。
ファイルの位置関係を以下とします。

```
Test ------ Hoge.elm
Hello.elm
```

elm-package.jsonのsource-directoriesはデフォルトのままです。

```
"source-directories": [
    "."
],

```

Hogeファイルのモジュール名を以下のように「フォルダ名.モジュール名」にします。

```
module Test.Hoge exposing (..)
```

インポート側(Hello.elm)の記述も以下のように「フォルダ名.モジュール名」にします。

```
import Test.Hoge
```

すると検索されてコンパイル出来ます。
