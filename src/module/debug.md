#Debug

Debugのlog関数は、ブラウザのコンソールに現在の状態を表示することが出来る、デバッグ用の関数です。

```
log : String -> a -> a
```

一引数目はコンソールに表示するとき先頭に付く文字列になって、
あとは入れた値と同じ値を返すので、調べたいとこに挟めばOKです。

```
case Debug.log "msg:" msg of
      Hoge a ->


let
   a = Debug.log "" <| hoge
in f a

```
