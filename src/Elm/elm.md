##Elmとは





##Hello World

早速Hello worldを書いてみましょう。公式サイトにも載っています。

インストールしたツールとコマンドを使います。
まず使うコマンドは、elm-packageです。elm-packageはパッケージをインストールしたり公開することが出来ます。

elm-lang/htmlというパッケージを、ローカルのプロジェクトにインストールします。
elm-lang/htmlライブラリは、Elmにおいて基本的なHTML表示用のライブラリです。中身は仮想DOMになっています。

以下のコマンドをプロジェクトディレクトリ下で実行してください。

```
elm-package install elm-lang/html -y
```

メモ：実行すると、elm-stuffというフォルダと、elm-package.jsonというファイルが作成されます。
elm-stuffフォルダにはパッケージがインストールされています。
elm-package.jsonはパッケージとの依存関係が書かれています。


次に`Main.elm`というファイルを作ります。

```hs:Main.elm

import Html exposing (Html,div,text)


main : Html a
main = div [] [text "hello world!!"]

```

elm-makeコマンドでこのファイルをコンパイルします。

```
elm-make Main.elm
```

出来たindex.htmlファイルをブラウザで開きます。するとhello worldと表示されたと思います。

簡単にhtmlファイルを作ることができました。

###絵を書く。

他に絵を描くように遊べるのがevancz/elm-graphicsパッケージです。v0.16以前のElmentsやCollage（canvasのラップ）があります。

またマークダウン記法で書きたいならevancz/elm-markdownがあります。

svgを書くならelm-lang/svgです。

Material Designならdebois/elm-mdl
Material Iconsならelm-community/elm-material-icons

といったパッケージがあります。


##マウスの座標を表示する

マウスについてのパッケージはelm-lang/mouseです。elm-packageでインストールします。

```
elm-package install elm-lang/mouse -y
```

中を見るとマウス座標はPosition型といい、
連続してPositionを返す関数はmoves関数と言うようです。

```hs
type alias Position =
{ x : Int
  , y : Int
}

moves : (Position -> msg) -> Sub msg
moves tagger =
  subscription (MySub "mousemove" tagger)

```

moves関数はSub msgという型を返します。
Subという型はprogram関数のsubscriptionsに渡します。
なので以下のようになります。

```hs
main : Program Never
main =
  program { init = init
          , view = view
          , update = update
          , subscriptions = \_ -> moves Move } --subscriptionsはModel -> Sub Msg。ラムダ式で達成してる。

type Msg = Move Position

```



最終的に以下のコードになります。

```hs


import Mouse exposing (moves,Position)
import Html exposing (Html,text)
import Html.App exposing (program)

main : Program Never
main =
  program { init = init
          , view = view
          , update = update
          , subscriptions = \_ -> moves Move }

type Msg = Move Position
type alias Model = Position

init : (Model , Cmd Msg)
init = {x = 0, y = 0} ! []

update : Msg -> Model -> (Model,Cmd Msg)
update msg model =
  case msg of
    Move position -> position ! []

view : Model -> Html Msg
view model = text <| toString model

```

!はPratform.Cmdの関数で、modelとCmdをタプルにしてくれる便利関数です。

```
(!) : model -> List (Cmd msg) -> (model, Cmd msg)
(!) model commands =
  (model, batch commands)
```

今回実行したいCmdはないのですべて空のリスト(何もなしになる)になっています。

```
init : (Model , Cmd Msg)
init = {x = 0, y = 0} ! []
```



##公式サイト

[http://elm-lang.org](http://elm-lang.org)
公式サイトにはサンプルやドキュメントが豊富に用意されています。ブラウザエディタ上でElmを試すこともできます。
###公式サイトの各ページの説明
公式サイトには文章が揃っているので探検してみよう。
[examples](http://elm-lang.org/examples)
作例があります。

[docs](http://elm-lang.org/docs)
言語に関するドキュメントやお知らせ。
構文やパッケージデザイン、スタイルガイドなどがあります。

[community](http://elm-lang.org/community)
Mailing ListやSlackへのリンクがあります。

[Blog](http://elm-lang.org/blog)
今までのElmの各バージョン発表時のドキュメントなんかがあります。


##以下メモ


###Debug

```elm
import Debug(log,watch)

hoge = Debug.log "targetは"　<| target.....

```
`Debug`ライブラリの`log`という関数はasTextのコンソール版です。
引数の文字列と一緒にコンソールに表示します。デバッグに便利です。


###エディタ
主要なエディタには、シンタックスハイライトのプラグインがあるようです。

自分はatomを使っています。atomのElm用プラグインはモジュール内を検索し、関数とコメント部分を表示する機能があるので便利です。

（sublime,atomの場合、）Ctrl+pでプロジェクト内のファイル検索です。インストールしたElmパッケージをファイル検索して読むと、学習が捗ると思います。


###よく最初ミスったとこ
let の中の変数の先頭と、case式のパターンの先頭は揃えないとコンパイラが読み取らない。

```Haskell
main =
       let hoge =
           huga =
       in　...

case state of
    Nomal   ->
    Add   x ->
    _       ->
```


###その他

* リスト内包表記無い。

* 正格評価ですべて型付けされる。whereをなくしてletだけにして高速化している。

* v0.16から末尾再帰は最適化されるようになった。

* 代数データ型は引数のある関数のように扱えます。以下はよく見る入力の型を作る場面

```Haskell
data Action = Add Int | Nomal | ...

action : Signal Action
action = Add <~ count Mouse.clicks

```


##パッケージ
パッケージのサイト
http://package.elm-lang.org/
いろいろある、主要なのは

###描画
evancz/elm-graphics
evancz/elm-markdown
マークダウン
elm-lang/svg
svg
debois/elm-mdl　
elm-community/elm-material-icons
Material Designなら
Material Iconsなら


###アニメ
・elm-lang/animation-frame　
requestAnimationFrame()のパッケージ
・elm-community/easing-functions
easingのパッケージ
etaque/elm-transit-style

###CSS
・rtfeldman/elm-css
CSSを関数でかける。

###ルーター
いろいろ提案されていて公開されている（今のところ２つがv0.17に対応しているようだ）、まだ調べてない。

###日付フォーマット
mgold/elm-date-format

###form
いくつかあったはず、まだ調べてない。

###パーサーコンビネータライブラリ
・Bogdanp/elm-combine
・Dandandan/parser、

###その他
・evancz/focus　
レコードが３つ以上ネストした時はfocusライブラリかElmアーキテクチャを検証する。



## 参考になるサイト、動画、スライド
[http://elm-lang.org/](http://elm-lang.org/)
公式サイト。

[ML](https://groups.google.com/forum/#!forum/elm-discuss)
メーリングリスト。疑問、不満があれば、まずここで過去の議論を検索するといいです。大体あります。

[elm-todomvc](https://github.com/evancz/elm-todomvc/tree/trim)
Elm公式のElmで出来たTODOアプリ。Elmの書き方が詰まっています。頻繁に更新されています。

[uehaj's blog](http://uehaj.hatenablog.com/entry/2015/01/08/234207)
elmでやってみるシリーズ。Elmで何が出来るのか。

todo 探してくる

##まとめ
Elmはデザインが(好き嫌いではなくちゃんと測れるものとして)とても良いと思います。学習のしやすさへの苦心や、構文や技術の選択がこれは人類つかうやろうなぁと思います。

Elmが解決する問題領域はGUIです。複雑怪奇になりそうなその領域に、Elm＋Elmアーキテクチャというのを生み出しました。

Elmは純粋静的型付け関数型の構文を採用しています。ブラウザが仕様に仕様を重ねて例外だらけみたいなイメージなので純粋と合わないのではと、初めて見た時思いましたが関係ないです。コンパイルする時の話です。

キャッチコピーとして、Elmでコンパイルして出来たランタイムは壊れません。そのために言語側からと、ランタイム側から頑張っています。（生成されるJSは古い環境にも対応したものだったり、Maybe型を返したり、caseで網羅していないと起こるようにしたり）

Elmのデザインで好きなのが、思い切ったユーザーへの制限です。そのおかげでミニマムです。個人的にこのくらいのフレームもいい。

Elmはバージョンが上がるたびに破壊的な変更が入っています。今はまだ永遠のベータ版です。古いバージョンは使ってられませんので、バージョンアップを追える人が望ましい。ロードマップ的なものはあるのかないのかという感じです。

コンパクトで、見た目もスッキリしていて、簡単にブラウザでビジュアルになるので、Elmは面白い言語です。
Html勉強した人がそのままElmでプログラミングを覚える、ということもできると思ってます。

ぜひElmやってみてね。


##まとめ。Elmのデザインと、おすすめする人。しない人。
| Elm | おすすめする人。しない人。 |
|:-----------:|:------------:|
|ブラウザ開発言語 |フロントエンドの人。html,css,js知っている人。|
|学習が容易。すぐ画面になる。絵を作れる。|プログラミング初心者に。関数型言語の勉強に。|
|新しい言語|人に言語を覚えてもらうのは、思っている以上に難しい。少人数、小さなツールからがおすすめ。>electron|
|バージョンアップで変わる。|毎日ネット技術を追っている人がいいかもしれない。公式が発表する時にバージョンアップ情報確認するのが出来る人。|
|構文がHaskell|構文の情報はHaskellの方が多いので、Elm勉強時はHaskellの勉強も行うことになるので、Haskellへの入り口に。Haskell知っている人。Haskell勉強したい人。|
|純粋、静的、関数型言語|コンパイルする時に型の違いでコードの間違いを指摘される、出力されたランタイムは壊れることがない。そのあたり響く人。|
|ユーザーへの制約|コード内はなるべく手続き的な記述はできなくなっていたり、状態の更新がupdateだけだったり、型クラスがなかったり（これは先変わるかも）、Elmアーキテクチャオンリー、こういうスケールがいい人。いやなら別の言語（purescrip、ClojureScript、scalaJS、ghcjs...etc）がいいかも|
|ドキュメントは英語|でも自分はドキュメントも、Mailing Listも翻訳機能使って読んでるので日本語と変わらないと思われる。|
