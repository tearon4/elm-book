# インストール

公式サイトから、WidowsとMac用のインストーラが公開されています。 
ダウンロードして起動するとインストールできます。

npmにもElmパッケージが公開されています。node.jsをインストールしている方は以下のようなコマンドで、簡単にインストールできます。

```
mkdir testproject
cd testproject

npm install -g elm
elm-make -h
```

# インストールされるコマンド


* elm-make
 *  elmのビルド
* elm-package
 *  パッケージのダウンロード、公開
* elm-reactor
 *  ファイルを監視して、自動リロード、タイムトラベリング機能をもったデバッガー
* elm-repl
 *  対話型実行環境