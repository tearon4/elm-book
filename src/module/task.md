# Task:非同期処理

Task型はエラーのある、ひとかたまりの計算プロセスで、非同期処理で、副作用のある処理を表現する型です。  
Httpアクセスの返り値にもなっていますし、Elmの裏側でたくさん使われています。

主に使用するときは、perform関数で実行してCmd型にしてHtml.Appに渡して実行します。

```elm
type Msg =
      Get ...
    | ...  
    | GetErr String

getJson : Cmd Msg
getJson =
    get (jsonDecoder) "test.json"   --ローカルのjsonにアクセスするTask
    |> Task.mapError toString
    |> perform GetErr Get           --実行。Cmdになる。

init = "" ! [getJson]               --初期化後すぐのタイミングでhttpアクセスして値を取ってくる。
```

またC#の「Task」や、javascriptの「Promise」というのが似ているので、参考になると思います。（あと後のバージョンでメッセージング機能がついたらScalaやErlangで聞くActorになります。）

ここでは、Task型の性質の「計算の集まり」、「エラー処理」、「非同期」について解説します。

#計算の集まり

Task型は計算のステップの集まりという性質があります。

Task型を作ってみます。succeed関数を使うと、何かから（成功した）Task型を作れます。

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

これで中身が、10に(* ) 10した値のTask型になります。
この計算が終わった「あと」に、計算の結果をうけて新たに計算するには、andThenを使います。

```elm
andThen : Task x a -> (a -> Task x b) -> Task x b
```

```elm
mapdTask = Task.map ((*) 10) initialTask    --Taskがあるとします

mapdTask `andThen` (\n ->succeed <| n + 5)  --その計算(Task)の結果の値を使って計算

```

こうして「10に*10してその後+5する」といった計算を行うTaskを定義が定義できました。しかしまだ実行はされません。実行すれば定義した計算が行われます。実行するにはTask.perform関数を使いCmdにしてElm-Architectureに渡す必要があります。

```elm
getJson : Cmd Msg
getJson =
    ((get (Decode.list Decode.string) "test.json"|> Task.mapError toString) --通信するTask
    `Task.andThen`
    (\str ->
      Task.succeed (nannka str)))    -- その後にその値を使い何かする！
    |> perform GetErr Get            -- それらのTaskを実行する！


```

perform関数には、エラー時と成功時のMsgのデータ構築子を渡します。
Cmd型についてはElm-Architectureのページを参考にしてください。

##エラーを返すかもしれない処理

Taskはエラーを返すかもしれないという性質があります。
例えば、httpアクセスならアクセスエラーがあります。



Taskは前のTaskが成功ならその値を使ってそのまま計算を続行し、エラーなら計算せずエラーは受け渡す性質があります。

```elm
getJson : Cmd Msg
getJson =
    ((get (Decode.list Decode.string) "test.json"|> Task.mapError toString) --アクセスするタスクがエラーになると
    `Task.andThen`
    (\str ->
      Task.succeed (nannka str)))            --ここはスキップする。
    |> perform GetErr Get                    --通信時のエラーが返る。

```

エラー時のみ復旧する処理などを入れたい場合はandThenのエラー版、onError関数を使いエラー時用のTaskをつなげます。

mapError関数を使うとTaskのエラーを変化させることが出来ます。つまりタスクのエラーを設定できます。
階層で使いどこのエラーかわかりやすくします。

```
getJson : Cmd Msg
getJson =
    ((get (Decode.list Decode.string) "test.json" |> Task.mapError (\_ -> "通信エラー！"))  --getのTaskのエラーを変化。
    `Task.andThen`
    (\str ->
      Task.succeed (nannka str) |>Task.mapError (\_ ->"ここで失敗" )))  --次のTaskはこのエラーを返す。
    |> perform GetErr Get --どっちかわかる
```

上記の例では各Taskに個別のエラーをつけています。これでエラーの判別ができたり、エラー処理を行ったり出来ます。

##非同期処理

Taskは別スレッドで非同期に実行されます。
同期処理とは、処理がABCと書かれてあると、ABCと順番通り数珠つなぎに実行されることを指します。同期ではない非同期処理とはBがﾎﾟｺっと外れて別のところで実行されるような、順番や場所が違うバラバラな処理になることを指します。


非同期処理（別スレッド処理）はうまく使うと処理を並行に実行し、CPUを無駄なく使うことが出来ます。
しかしその反面複雑になり、思わぬバグが潜む原因になります。そのために安全で統一的なインターフェースを使う必要があります。それがTaskです。


Elmでは非同期に実行される、実行するべき処理はTask型を返すようになっています。
例えばHttpなら、Task Err valueを返します。これは別のスレッドで通信するということで、そのおかげでこのTaskはポコっと別のところで行われ、メインの処理はそのまま走ります。


別スレッドで行われるかの区切りは、perform関数になっています。

```
getJson : Cmd Msg
getJson =
    ((get (Decode.list Decode.string) "test.json"|> Task.mapError toString)
    `Task.andThen`
    (\str ->
      Task.succeed (nannka str)))    --Taskを変化させるが上のTaskと同じスレッド。
    |> perform GetErr Get     --上記までの一連のTaskが別の一つのスレッドで実行される事になる。

```

複数のタスクを並行に実行するなら以下のようにします。

```
Cmd.batch [perform taskA , perform taskB]
```

ここまででTaskの性質を説明しました。Taskモジュールには他にもTaskを組み合わせる関数があります。
