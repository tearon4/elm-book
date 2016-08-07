# Task

Task型はひとかたまりの計算プロセスや、非同期処理や、副作用のある処理を表現する型です。
Httpアクセスの返り値にもなっていますし、Elmの裏側でたくさん使われています。

evancz/elm-httpのHttpにある関数を見てみます。

```
get : Json.Decoder value -> String -> Task Error value
post : Json.Decoder value -> String -> Body -> Task Error value
```

使うには、以下のようにperform関数で実行して、Cmd型にしてHtml.Appの関数に渡すなどします。

```
type Msg =
      Get ...
    | ...  
    | GetErr String

getJson : Cmd Msg
getJson =
    get (jsonDecoder) "test.json"
    |> Task.mapError toString
    |> perform GetErr Get
```

#計算の塊

Task型は一つの計算の集まりを表現します。

Task型を作ってみます。succeed関数を使うと、どんな値でも（成功した）Task型になります。

```
> import Task
> initialTask = Task.succeed 10
<task> : Task.Task a number

```

これで一つ中身が10のTask型が生まれました。
map関数を使うと、Task型の中身に関数をかける事ができます。

```
> Task.map ((*) 10) initialTask
<task> : Task.Task a number
```

これで中身が、10に(* ) 10したTask型になります。
この計算が終わった「あと」に、計算の結果をうけて計算するには、andThenを使います。

```
andThen : Task x a -> (a -> Task x b) -> Task x b

mapdTask = Task.map ((*) 10) initialTask

mapdTask `andThen` (\n ->succeed <| n + 5)

```

こうするとmapdTaskの計算が終わったあとに、その結果をつかっていろいろしてTaskが作れます。

こうして足したり書けたりといった計算を行うTaskを定義しました。しかし実行はされません、このTaskを実行すれば定義した一連の計算が行われます。実行にはTask.perform関数を使います。

```
type Msg =
      Get ...
    | ...  
    | GetErr String

getJson : Cmd Msg
getJson =
    get (jsonDecoder) "test.json"
    |> Task.mapError toString
    |> perform GetErr Get

```

perform関数にはMsgの構築子を渡します。つまり実行結果はMsgとなって、アプリケーションの中に帰ってきます。


##非同期

何かしらのデータベースに値を書き込むような処理があるとします。この処理はDBアクセス等はメインとは違ったスレッドで行いたいですし、送ったあとエラーになるかも知れないし、成功すれば以降のプログラムではDBであることを把握しなければなりません。この処理は非同期で、副作用のある処理といえます。

Elmではこの処理をTask型で包んで表現します。


またC#の「Task」や、javascriptの「Promise」というのが似ているので、参考になると思います。
またScalaやErlangで聞くActorというメッセージをやり取りするモデルも取り入れているので、ゆくゆくメッセージング機能がつくかもしれません。

```


```
