#Debug : デバッグ

Debug.log関数は、調べたい変数をブラウザのコンソールに表示することが出来ます。

```elm
log : String -> a -> a
```

使用例

```elm
case Debug.log "msg:" msg of
      Hoge a ->
```

```elm
let
   a = Debug.log "" hoge
in f a

```
