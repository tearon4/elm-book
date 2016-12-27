#Task:非同期処理

Task型は非同期処理を扱う為の型です。

非同期の処理とは、同期の処理(上から下まで順に実行される処理)ではない処理のことを言います。例えば、Httpライブラリを使った通信がそれに当たります。通信を行った時は、通信を行っている間はじっと固まって待っているわけなく、ユーザの操作を続行したりといった処理を行います。そして通信結果が帰ってきたら、結果を使った続きの処理を行います。この動作は通信に関する処理がメインの処理から非同期に行われています。

そういったどこでも見る当たり前の挙動ですが、非常にバグを作りやすい場所でもあります。なので各言語はインターフェイスとなる概念を導入しています。ElmではTask型がそれに当たります。

Task型は最初は難しいかもしれませんが、「非同期処理」、「処理がエラーになる可能性がある」、「計算ステップの集まり」、「副作用をラップする」という性質を理解すると使いこなせると思います。

またTask型は、C#の「Task」や、javascriptの「Promise」と似ていますので、それらのドキュメントも参考になると思います。

##非同期処理

非同期的な処理を定義したり、扱ったりすることが出来ます。

例

```elm
heavyTask : Task x String
heavyTask =
    Process.sleep 5000               ---Process.sleepは指定した時間後にTaskを実行するようにする関数
        |> Task.map (always "完了！")

```

上記の関数は処理に５秒位掛かる非同期的な処理です。

このTaskをinitの部分で`Task.perform`を使って実行します。
すると、Elmアプリケーションを起動したあとすぐにこの処理が始まります。終わるのは５秒後です。
その間アプリケーションのメインの処理(update)は固まったりせず、動かすことができます。

５秒後に処理が終わると、結果はMsgになって返ってきます。その後メインの処理に移ります。

```elm
type Msg
    = TaskResult String   ---結果を受け取るMsg

heavyTask : Task x String
heavyTask =
    Process.sleep 2000
        |> Task.map (always "完了！")

init : ( Model , Cmd Msg)
init =
    0 ! [ Task.perform TaskResult heavyTask ]

```

様々な処理がTask型になっています。DBへのアクセスであったり、Httpでの通信であったりです。これらは、メインの処理を邪魔せず実行することが出来ます。

##Task型を作る。

Task型を作ってみます。succeed関数を使うと、（成功した）Task型を作れます。

```
> import Task
> task = Task.succeed 10
<task> : Task.Task a number

```

##map

map関数を使うと、Task型の中身に関数をかけ変化させることが出来ます。

```
> Task.map ((*) 10) task
<task> : Task.Task a number
```

これでTask型の中身の`10`に`* 10`したことになります。mapは中の値を変化させるだけで時間は経ってません。

##Task型は計算のまとまり

タスク内の計算が終わったあとに、その計算の結果をうけてまたTaskにする、という風にステップにすることが出来ます。
タスクを連続させタスクを大きくできます。

```elm
andThen : Task x a -> (a -> Task x b) -> Task x b
```

andThenは二引数目がTask型を返しているのがポイントで、Task型をandThen関数で繋いでいくことが出来ます。


```elm
task2 =
    Task.map ((*) 2) task

task3 =
    task2
        |> Task.andThen (\n -> Task.succeed (n + 5))  --Task型内の結果を受け取って新しいTaskを作る。
```

mapとは違い、Taskの結果を使ってTaskを作っています。

##エラーを返すかもしれない処理

Taskはエラーを返すかもしれない処理という性質があります。
例えば、httpアクセスならアクセスエラーというようにエラーになる可能性も内包しています。

Taskは、前のTaskが「成功」ならその値を使ってそのまま計算を続行し、「エラー」なら計算せずエラーを受け渡します。

```elm
getJson : Cmd Msg
getJson =
    ((get (Decode.list Decode.string) "test.json"|> Task.mapError toString) --アクセスするタスクがエラーになると
    `Task.andThen`
    (\str ->
      Task.succeed (nannka str)))            --ここはスキップする。
    |> perform GetErr Get                    --通信時のエラーが返る。

```

エラー時のみ復旧する処理などを入れたい場合はandThenのエラー版、onError関数を使いエラー時用のTaskをつなげておきます。

mapError関数を使うとTaskのエラーを変化させることが出来ます。
以下では、Taskの階層の中でエラーを文字列にして、どこのエラーかわかりやすくしています。

```elm
getJson : Cmd Msg
getJson =
    ((get (Decode.list Decode.string) "test.json" |> Task.mapError (\_ -> "通信エラー！"))  --getのTaskのエラーを変化。
    `Task.andThen`
    (\str ->
      Task.succeed (nannka str) |>Task.mapError (\_ ->"ここで失敗" )))  --次のTaskはこのエラーを返す。
    |> perform GetErr Get
```

##Processという単位に区切る。


##実行

Task型を「実行」すれば定義した計算が行われます。実行するにはTask.perform関数を使いCmdにしてThe Elm Architectureに渡す必要があります。

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
