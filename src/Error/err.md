##エラー処理 : Maybe Result

純粋関数型言語というものには、理屈上try catch文やgoto文のようなジャンプはないらしいです。

ではエラー処理はどうするかというと、「エラーが起こりえる」という型を使います。

ElmではMaybeとResult、Taskという型がこれに当たります。


```elm
type Maybe a = Just a | Nothing
type Result error value = Ok value | Err error
```

これらの型はエラーになるかもしれない、またはエラーが有る処理に付けられる型です。
定義の中に、エラーが含まれていて、前の処理がエラーになると次の処理をスキップしてエラーを伝える性質があるので、エラー処理をしたい型に付けて利用します。


この型を利用している例として、List型のhead関数というListの先頭を返す関数があります。

```
head : List a -> Maybe a

head [1,2,3] == Just 1
head [] == Nothing

```

先頭に値がある場合はいいですが、ない場合はNothingを返します。

このように

```

hoge list =
    let result = head list
    in case result of
            Just ->
            Nothing ->

```

使うときは、

