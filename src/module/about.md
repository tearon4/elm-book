#Coreライブラリ

このセクションは、Elmの組み込みのライブラリ（Coreライブラリ）についての解説ページです。
だんだんページを増やしていきたいと思います。
今はTaskとDictとDebugのページがあります。

メモ：Elm0.18では、以下のライブラリと型が自動でimportされるので、以下の型はimportを書かなくても使うことができます。

```elm
import Basics exposing (..)
import List exposing ( List, (::) )
import Maybe exposing ( Maybe( Just, Nothing ) )
import Result exposing ( Result( Ok, Err ) )
import String
import Tuple

import Debug

import Platform exposing ( Program )
import Platform.Cmd exposing ( Cmd, (!) )
import Platform.Sub exposing ( Sub )
```

ライブラリには必要最低限の関数しかありません。より発展的な関数が必要なら、Elm Packagesに「｛Coreモジュール名｝-extra」という名前で、Coreライブラリの拡張ライブラリが公開されているので参照してみてください。


メモ：elm-makeを使いElmファイルを初めてコンパイルしようとすると、Coreライブラリをダウンロードしますか、と聞かれます。これは、Coreライブラリも他のライブラリと同じように、パッケージシステムを使ってバージョン管理するためにElmインストーラに含めていないためです。
