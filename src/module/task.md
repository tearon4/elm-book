#Task:非同期処理

Task型は、Elmで非同期処理を扱う為の型です。

非同期の処理とは、同期の処理(上から下まで順に実行される処理)ではない処理のことを言います。例えば、Httpライブラリを使った通信がそれに当たります。通信行った時は、通信結果が帰っている間はじっと固まって待っているわけなく、ユーザの操作を続行したりといった処理を行います。そして通信結果が帰ってきたら、結果を表示したり、結果を使った続きの計算を行います。この動作は通信に関する処理がメインの処理から非同期に行われています。

そういったどこでも見る当たり前の挙動ですが、非常にバグを作りやすい場所でもあります。なので各言語はインターフェイスとなる概念を導入しています。ElmではTask型がそれに当たります。

Task型には、「非同期処理」である他に、「処理がエラーになる可能性がある」、「計算ステップの集まり」といった性質ともとれるものがあります。それを理解すると使いこなせると思います。

メモ:Task型は、C#の「Task」や、javascriptの「Promise」と似ていますので、そちらのドキュメントも参考になると思います。

使用例

```elm
type Msg =
      Get ...
    | ...  
    | GetErr String

getJson : Cmd Msg
getJson =
    get (jsonDecoder) "test.json"   --ローカルのjsonにアクセスする。getは返り値がTask型
    |> Task.mapError toString
    |> perform GetErr Get           --実行。Cmdになる。

init = "" ! [getJson]               --initにCmdを渡すと、初期化後すぐのタイミングでhttpアクセスして値を取ってくる。
```

#計算のひと塊

Task型は「タスク」という名前の通り計算のステップという性質があります。

##Task型を作る。

Task型を作ってみます。succeed関数を使うと、（成功した）Task型を作れます。

```
> import Task
> initialTask = Task.succeed 10
<task> : Task.Task a number

```

map関数を使うと、Task型の中身に関数をかける事ができます。

```
> Task.map ((*) 10) initialTask
<task> : Task.Task a number
```

これでTask型の中身の`10`に`* 10`したことになります。mapは中の値を変化させるだけで時間は経ってないという扱いになります。

##Task型は計算のまとまり

ここからTaskの計算のステップについて説明します。
タスクの「終わったあと」に、計算の結果をうけて新たに計算するandThenを使います。

```elm
andThen : Task x a -> (a -> Task x b) -> Task x b
```

andThenは二引数目がTask型を返しているのがポイントです。
Task型をandThen関数で繋いでいくことが出来ます。
書いてみます。

```elm
mapdTask = Task.map ((*) 10) initialTask    --Taskがあるとします

mapdTask `andThen` (\n ->succeed <| n + 5)  --その計算(Task)の結果の値を使って計算

```

こうして出来たTask型は、「あるタスクの後+5する」Taskということです。


最後にTask型を「実行」すれば定義した計算が行われます。実行するにはTask.perform関数を使いCmdにしてThe Elm Architectureに渡す必要があります。

```elm
getJson : Cmd Msg
getJson =
    ((get (Decode.list Decode.string) "test.json"|> Task.mapError toString) --通信するTask
    `Task.andThen`
    (\str ->
      Task.succeed (nannka str)))    -- その後にその値を使い何かする！
    |> perform GetErr Get            -- それらのTaskを実行する！

init = "" ! [getJson]                -- できたCmdを渡す。
```

perform関数には、エラー時と成功時のMsgのデータ構築子を渡す必要があります。上記ではGetErrとGetがそれに当たります。
Cmd型についてはThe Elm Architectureのページを参考にしてください。

##エラーを返すかもしれない処理

Taskはエラーを返すかもしれない処理という性質があります。
例えば、httpアクセスならアクセスエラーがあります。

TaskのandThenは、前のTaskが「成功」ならその値を使ってそのまま計算を続行し、「エラー」なら計算せずエラーを受け渡します。

```elm
getJson : Cmd Msg
getJson =
    ((get (Decode.list Decode.string) "test.json"|> Task.mapError toString) --アクセスするタスクがエラーになると
    `Task.andThen`
    (\str ->
      Task.succeed (nannka str)))            --ここはスキップする。
    |> perform GetErr Get                    --通信時のエラーが返る。

```

Taskのエラー用の関数について説明します。

エラー時のみ復旧する処理などを入れたい場合はandThenのエラー版、onError関数を使いエラー時用のTaskをつなげておきます。

mapError関数を使うとTaskのエラーを変化させることが出来ます。
以下では、Taskの階層の中でエラーを文字列にして、どこのエラーかわかりやすくしています。

```
getJson : Cmd Msg
getJson =
    ((get (Decode.list Decode.string) "test.json" |> Task.mapError (\_ -> "通信エラー！"))  --getのTaskのエラーを変化。
    `Task.andThen`
    (\str ->
      Task.succeed (nannka str) |>Task.mapError (\_ ->"ここで失敗" )))  --次のTaskはこのエラーを返す。
    |> perform GetErr Get
```

エラーになっても問題ないならエラー時でもsucceedで成功を返したり、上の例の場合getJsonを行ってエラーの場合、update関数で処理に使えたり、viewにエラー文字を表示できたりすることを狙ってGetErrという定義したMsgが変えるようになっています。

そのようにTaskのエラー処理を定義できます。

##非同期処理

Taskは非同期に処理されます。
