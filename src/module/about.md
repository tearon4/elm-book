#Coreライブラリ

このセクションは、ElmのCoreライブラリについての解説ページです。
だんだんページを増やしていきたいと思います。
今はTaskとDictとDebugのページがあります。

メモ：Elm0.17では、以下のライブラリと型が自動でimportされるので、以下の型はimportを書かなくても使うことができます。

```
import Basics exposing (..)
import List exposing ( List, (::) )
import Maybe exposing ( Maybe( Just, Nothing ) )
import Result exposing ( Result( Ok, Err ) )
import Platform exposing ( Program )
import Platform.Cmd exposing ( Cmd, (!) )
import Platform.Sub exposing ( Sub )

```

メモ：最初のコンパイル時にelm-makeを使いElmファイルをコンパイルしようとすると、Coreライブラリをダウンロードしますか、と聞かれます。ElmインストーラにはCoreライブラリが含まれていません。Coreライブラリをelm-packageでバージョン管理して扱うようにするためです。
