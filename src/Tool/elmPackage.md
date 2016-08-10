##パッケージング:elm-package

elm-packageはElmのパッケージ管理システムです。

Elmに必要なパッケージをダウンロード＆インストールしたり、elm-package.jsonファイルでパッケージを管理したり、パッケージを公開したり出来ます。

パッケージはElm Packagesで探すことが出来ます。
[Elm Packages](http://package.elm-lang.org/)


コマンド

```
install
publish
bump
diff
```

###パッケージのインストール

```
#パッケージのインストール
elm-package install elm-lang/html

#-y　オプションをつけるとすべての質問にyesと答えます。
elm-package install elm-lang/html -y
```

###elm-package.jsonでライブラリの依存関係を管理する



```
#elm-package.jsonに記述してある依存ライブラリを自動インストール
elm-package install

```


###パッケージの公開方法

TODO