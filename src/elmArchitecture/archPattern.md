##The Elm Architectureの組み合わせ方

The Elm Architecture（以下TEA）の組み合わせる時の、部分を詳しく見ていきます。

前提

・親と子供、２つのコンポーネントがあるとします。

```elm
module App
```

```elm
module Editor
```

・今回は親と子供、２つのコンポーネントは、Msg、Model、init、update、viewが定義されているとします。

```elm
module Editor exposing (Msg,Model,init,update,view)
```

これら定義がすべて揃っていなければ上手く組み合わせることが出来ない、ということはないです。親のModelが無くても、子供のModelをそのまま使うなど、歯抜けであっても組み合わせることができます。


・親と子コンポーネント両方共マウス入力を使うとします。

```

```

・子コンポーネントはportでCmdを使っているとします。


```

```

・子コンポーネントはHTMLのイベントを使っているとします。

```
view =
  div [onClick Click] []

```

・親と子供のMsgは以下のようになっているとします。

```
```

```
```


さあ、組み合わせてみよう。

##init

```elm
module App
```


##update

##Sub

##Cmd
