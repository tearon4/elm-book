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
longTask : Task x String
longTask =
    Process.sleep 5000               ---Process.sleepは指定した時間後にTaskを実行するようにする関数
        |> Task.map (always "完了！")

```

上記の関数は処理に５秒位掛かる非同期的な処理です。

様々な処理がTask型になっています。DBへのアクセスであったり、Httpでの通信であったりです。これらは、メインの処理から離れて実行することが出来ます。

このTaskをinitの部分で`Task.perform`を使って実行します。
すると、Elmアプリケーションを起動したあとすぐにこの処理が始まります。その間アプリケーションのメインの処理(update)は固まったりせず、動かすことができます。

５秒後に処理が終わると、結果はMsgになって返ってきます。その後メインの処理に移ります。

```elm
type Msg
    = TaskResult String   ---結果を受け取るMsg型。Taskの結果はMsgになる。

longTask : Task x String
longTask =　　　　　　　　　　　　　　　　　　    
    Process.sleep 5000
        |> Task.map (always "完了！")

init : ( Model , Cmd Msg)
init =
    0 ! [ Task.perform TaskResult longTask ] --performはTaskを実行する関数。実行するとCmdになる。

```


##Task型を作る。

Task型を作ってみます。succeed関数を使うと（成功した）Task型を作れます。

```elm
> import Task
> task = Task.succeed 10
<task> : Task.Task a number

```

##map

map関数を使うと、Task型の中身に関数を適用し変化させることが出来ます。

```elm
> Task.map ((*) 10) task
<task> : Task.Task a number
```

これでTask型の中身の`10`に`* 10`したことになります。mapは中の値を変化させるだけで時間は経ってません。

##Task型は計算のまとまり

Taskは非同期に行いたい計算のまとまりを表現します。Task内の計算が終わったあとに、その計算の結果をうけてまたTaskにする、という風にステップにすることが出来ます。

```elm
andThen : (a -> Task x b) -> Task x a -> Task x b
```
Task型とTask型をandThen関数で繋いだり、Taskの結果を使って新しいTaskを作ることができます。

小さなTaskを、mapとandThen関数で連続させ大きなTaskを定義することが出来ます。

```elm
task2 =
    Task.map ((*) 2) task

task3 =
    task2
        |> Task.andThen (\n -> Task.succeed (n + 5))  --Task型内の結果を受け取って新しいTaskを作る。
```

##実行

Task型は実際に「実行」すれば、Task型の計算が行われます。実行するにはperformかattempt関数を使います。

これらの関数でCmdにして、program関数に渡すと、Elmランタイムがよしなに実行してくれます。

```elm
type Msg
    = TaskMsg Int

task : Task a Int
task =
    Task.succeed 10

init = "" ! [Task.perform TaskMsg task]                -- できたCmdを渡す。
```

performとattemptの違いは以下のようになっています。

```elm
perform : (a -> msg) -> Task Never a -> Cmd msg
attempt : (Result x a -> msg) -> Task x a -> Cmd msg
```

performはエラーを考慮しないでよい場合に使います。エラー処理を考えないでよいTaskなどの場合です。
attemptはエラーを考慮したいTaskの場合に使います。通信エラーがあったときには別の処理をしたいなどの場合です。Taskの結果がResult型になっています

##エラーを返すTask

Taskにはエラーになるかもしれないという性質があります（例、httpアクセスのアクセスエラー、DBアクセスなど副作用がある処理）
Taskの型定義を見ると、Taskに続く左側の型がエラー時にTaskが返す型で、右側は成功時にTaskが返す型という意味になっています。

Task型の定義

```elm
type alias Task err ok = Platform.Task err ok
```

エラーになった時String型を返す例（Task String a）

```elm
errorTask : Task String a
errorTask =
   Task.fail "失敗！"       ---failはエラーを返す関数

```

Taskにエラー時用の処理を加えるには、map関数のエラー版mapError、andThenのエラー版onError関数を使います。

また、TaskのandThenは前のTaskが「成功」ならその値を使ってそのまま計算を続行し、「エラー」なら次の計算へエラーを受け渡します。

```elm

type Msg
    = TaskResult (Result String String)

errorsTask : Task String String
errorsTask =
    Task.succeed "成功"                                 --- Task a String
        |> Task.andThen (\x -> Task.fail "失敗！")      --- Task String String
        |> Task.andThen (\x -> Task.succeed (x ++ "!!!!"))

init : ( Model, Cmd Msg )
init =
    0 ! [ Task.attempt TaskResult errorsTask ]          --- TaskResult Err 失敗！

```
