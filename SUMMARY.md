# Summary


### Part I　インストールと、周辺ツール


* [はじめに](README.md)
* [Elmについて](src/Elm/aboutElm.md)
* [Elmのインストール](src/install/zyunbi.md)
    * [インストール](src/install/install.md)
    * [Hello World](src/install/hello.md)
* [同封されているツールについて](src/Tool/tool.md)
    * [elm-make:コンパイル](src/Tool/make.md)
    * [elm-package:パッケージング](src/Tool/elmPackage.md)
    * [elm-repl:REPL](src/Tool/repl.md)
    * [elm-reactor:ファイル監視サーバー](src/Tool/reactor.md)

### Part II　構文について


* [Elmの構文](src/syntax/syntax.md)
    * [全体](src/syntax/allSyntax.md)
    * [型・型推論・型検査](src/syntax/type/type.md)
    * [基本の型](src/syntax/type/primitive.md)
    * [関数](src/syntax/function.md)
    * [新しい型を定義する](src/syntax/type/teigi.md)
    * [Module:モジュールシステム](src/syntax/module.md)
    * [Port:JSとやり取りする](src/syntax/port.md)
    * [コラム:HaskellからみたElm](src/syntax/fromHaskell.md)

### Part Ⅲ　The Elm Architecture


* [The Elm Architecture](src/elmArchitecture/about.md)
    * [Cmd/Sub](src/elmArchitecture/cmdSub.md)
    * [The Elm Architectureのモジュラリティ](src/elmArchitecture/scale.md)


### Part Ⅳ　Coreライブラリとパッケージについて

* [Coreライブラリ](src/module/about.md)
    <!-- * [Basics](src/module/basics.md) -->
    <!-- * [List](src/module/List.md) -->
    * [Task:非同期処理](src/module/task.md)
    <!-- * [Error](src/Error/err.md) -->
    * [Dict:辞書](src/module/dict.md)
    <!-- * [Json](src/module/json.md) -->
    * [Debug:デバッグ](src/module/debug.md)
* [Elm Packageで公開されているパッケージ](src/elmPackages/about.md)
  * [elm-lang/html](src/elmPackages/html.md)
  * [elm-lang/html(2)](src/elmPackages/htmlapp.md)
  <!-- * [Test](src/Test/test.md) -->
  * [Bogdanp/elm-combine:パーサーコンビネータ](src/elmPackages/combinater.md)

### Part Ⅴ　発展的な話題とリンク

* [開発環境構築](src/develop/about.md)
* [ElmのCI設定](src/develop/ciSetting.md)
* [参考になるリンク集](src/etc/sankou.md)
