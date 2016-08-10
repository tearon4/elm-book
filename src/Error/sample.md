
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
