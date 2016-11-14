#Task:非同期処理

Task型は「エラーのある、ひとかたまりの計算プロセスで、非同期処理で、副作用のある処理」を表現する型です。  
Httpアクセスの返り値にもなっていますし、Elmの裏側でたくさん使われています。

主に使用するときは、perform関数でCmd型にしてHtml.Appモジュールの関数に渡して実行します。

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

またC#の「Task」や、javascriptの「Promise」というのが似ているので、参考になると思います。（あと後のバージョンでメッセージング機能がついたらScalaやErlangで聞くActorになります。）

ここでは、Task型の性質である「計算のひと塊」、「エラー処理」、「非同期」について解説します。

#計算のひと塊

Task型はタスクという名前の通り計算ステップの集まりという性質があります。

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


最後にTask型を「実行」すれば定義した計算が行われます。実行するにはTask.perform関数を使いCmdにしてElm-Architectureに渡す必要があります。

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
Cmd型についてはElm-Architectureのページを参考にしてください。

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

Taskはひと塊の計算処理で、Taskは非同期に処理されます。

非同期の説明の前に非同期の逆の同期処理とは、処理がABCと書かれてあるとABCと順番通り、数珠つなぎに実行されることを指します。  
同期でない非同期処理とは、例えばBが非同期処理ならBだけﾎﾟｺっと外れて別のところ、場所、時間に実行されるような、数珠から外れてバラバラな処理になるイメージです。

非同期処理はうまく使うと処理を並行に実行し、CPUを無駄なく使うことが出来ます。（例えばダウンロード中に別の処理をしたり。）
しかし非同期処理を書こうとすると、複雑になり、思わぬバグが潜む原因になります。（例えば、非同期処理の実装が別スレッド処理だったら、スレッド間で同じメモリを参照したりできる。なので非同期の処理のタイミングを細かく調整しなければならない。）  
そのために安全で統一的なインターフェースを使う必要があります。それがTaskです。

Javascriptはシングルスレッド処理ということですが、非同期の処理を行う方法も提供しています。setTimeout等の関数です。これらに登録した関数は指定した時間後に実行されます。（その間メインスレッドは処理が進みます。）ElmのTaskを実行する関数になります。

このsetTimeoutを便宜上、メインとは違う別スレッドと呼ぶことにします。もし複数スレッドを立てて並行に実行したいなら、Elm Packagesに公開されているelm-task-extraに関数があります。

```
parallel : List (Task error value) -> Task error (List Process.Id)
parallel tasks =
    sequence (List.map spawn tasks)
```

CoreライブラリのProcessのspawn関数を使っています。spawnはどこまでを別スレッドで実行するかの区切りになります。返す値はsetTimeoutが返すプロセスidです。
上記の関数は、複数Taskそれぞれを別スレッドで実行するだけなので、処理の順番等をつけるにはidをソートしたりする必要があるようです。

Elmでは非同期に実行される、実行するべき処理はTask型を返すようになっています。
例えばHttpなら、通信するとメインの処理からはずれて通信するということです。

またCmd/Subも非同期にアプリケーションに出たり入ってくることを表しているので、Task型から変化させられるようになっています。

##まとめ

Taskを３つの性質から説明しました。実は計算のひと塊と、エラーが返るかも、という性質はTask型以外にmapやandThen関数を持っている型や、Maybe型やResult型と共通の性質なので、それらと見比べてみるといいかもしれません。

Taskの他の関数についてはTaskモジュールを参照してみてください。
