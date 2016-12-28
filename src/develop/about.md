#Elmを使った開発環境構築

ここではElmを使った開発環境を構築していきましょう。以下の２つのツールについて説明します。

* フォーマッタ(elm-format)
* フロントエンドのビルドツール(webpack)

elm-formatはElmソースコードをElm公式スタイルガイドのスタイルで整形してくれるツールです。
webpackはフロントエンドのソースコード全般の管理ツールです。

elm-formatを使ってElmソースコードを整形します。
webpackを使ってホットリロードによる開発と、ビルドを行います。

##elm-format

[avh4/elm-format](https://github.com/avh4/elm-format)

elm-formatはElmソースコードを公式スタイルガイドのスタイルで整形してくれるツールです。
エディタ用のプラグインも多数公開されているので、今回は保存するたびにelm-formatを使って自動で整形するようにします。

###インストール

まずelm-formatバイナリをダウンロードして、環境変数からパスを通します。
MacとLinuxとwindowsそれぞれのバイナリが公開されています。

###セッティング

elm-formatのドキュメントを読むと、エディタの対応状況とプラグイン名が載っています。
例えばAtomでは、atom-elm-formatかatom-beautifyとなっています。自分のエディタにあったプラグインをインストールして、elm-formatをセッティングしてください。

Atomで設定してみます。ctrl + shift + p から、open setting panelを選び、設定パネルのインストールからatom-beautifyをインストールします。
設定パネルのpackage欄からatom-beautifyを検索し選び、設定のElmの欄からelm-formatを選択してセーブ時にフォーマットを行うようにチェックを入れると完了です。

##webpack

webpackとは、フロントエンド環境にあるソースコード全般を管理するツールです。

フロントエンド環境にはHTMLやCSSやJSやElmといったコードがありますが、それらはHTMLならミニファイし、SCSSならコンパイル、JSならbabelでトランスパイラして、すべてHTMLにリンクして、適切な位置に配置する必要があります。とても面倒な作業が多いので、webpackにすべてやってもらおうというわけです。

他にも似たことが出来るGrantやgulpといったツールがありますが、今のところ自分の中ではwebpackを使うのが、一番安定、ドキュメントも多い、概ね簡単、と感じたのでおすすめしています。

###elm-webpack-starter

[moarwick/elm-webpack-starter](https://github.com/moarwick/elm-webpack-starter)

elm-webpack-starterの設定を見てみます。
