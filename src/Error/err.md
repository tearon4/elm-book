##エラー処理

純粋関数型言語というものには、理屈上try catch文やgoto文のようなジャンプはないらしいです。

ではエラー処理はどうするかというと、「エラーが起こりえる」という型を使います。ElmではMaybeとResult、Taskという型がこれに当たります。


```
type Maybe a = Just a | Nothing

type Result error value = Ok value | Err error
```

例えば、Listにはhead関数というListの先頭を返す関数があります。

```
head : List a -> Maybe a

head [1,2,3] == Just 1
head [] == Nothing

```

先頭に値がある場合はいいですが、ない場合はNothingを返しています。


```

hoge list =
    let result = head list
    in case result of
            Just ->
            Nothing ->

```


ポケモンのリスト

```
type Pokemon = {name : String}

type PokeList = List Pokemon

pockemonList = []

```

バトルが始まる。持っていないとエラーにしたいとする。
battleを処理する関数はエラーの可能性がある。

```

battle : PokeList -> Result String　Pokemon
battle list =
      fromMaybe "ポケモンを持っていない" <| head list

```


エラーが出ず、うまく行った時にその値をつかって次の処理をする、
mapやandThenという関数がある

```

battle : PokeList -> Result String　Pokemon
battle list =
      fromMaybe "ポケモンを持っていない" ( head list)
      |> Result.map battleSystem
```


エラーの時はそれ専用の表示をしたい。

```

battleView : Result String Pokemon -> Html a
battleView result =
      case result of
        Ok  v -> battleStartView v
        Err err -> errView err
```

戻って、バトルシステム　にお金がなかったらエラーになるを追加　

```
import Result

battle : PokeList -> Result String　Pokemon
battle list =
      Result.map2
      always
      fromMaybe "ポケモンを持っていない" <| head list


```

map2は２つのResultが成功だったら、一引数目の関数を実行する。どちらかのResultがエラーになると、エラーを返す


```
```
