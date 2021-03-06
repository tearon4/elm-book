#elm-reactor:ファイルをコンパイルして表示するサーバー

elm-reactorを使うと、ブラウザで画面を確認しながら、Elmファイルを編集することが出来ます。
ブラウザのリロードボタンを押すと、Elmファイルを再コンパイルして結果のHTMLを表示します。

以下のコマンドで起動します。

elm reactor / elm-reactor

```bash
elm-reactor
```

するとサーバーが立ち上がります。

```bash
elm reactor 0.17.0
Listening on http://localhost:8000/
```

デフォルトでlocalhost:8000で立ち上がるので、そのアドレスにブラウザでアクセスします。

するとファイルが欄になって並んでいるので、目的のElmファイルをクリックします。するとElmファイルのコンパイルが始まります。
コンパイルエラーになったらブラウザ画面にエラーが表示されます。
再コンパイルするにはリロードボタンを押します。

終了するにはCtrl + c を二回押します。


##デバッグ機能

elm-reactorはデフォルトで、デバッグ機能を使えるようになりました。この機能により、Msgの発火や状態の変化を追えるようになりました。
また状態の履歴をインポート&エキスポートすることも出来ます。

Elmファイルをelm-reactorで開くと、右下に「Explor History」というボタンが見えます。

ここをクリックすると専用のブラウザが開きます。ここにMsgがあるたびにMsgと状態の履歴が並びます。
