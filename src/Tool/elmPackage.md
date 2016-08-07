##elm-package

elm-packageはElmのパッケージ管理システムです。

Elmに必要なパッケージをダウンロード＆インストールしたり、elm-package.jsonファイルでパッケージを管理したり出来ます。

コマンド

```
install
publish
bump
diff
```

使い方

```
#パッケージのインストール
elm-package install elm-lang/html

#-y　オプションをつけるとすべての質問にyesと答えます。
elm-package install elm-lang/html -y

#elm-package.jsonに記述してあるライブラリを自動インストール
elm-package install

```

パッケージはElm Packagesで探すことが出来ます。
[Elm Packages](http://package.elm-lang.org/)
