#型について

型とは、プログラミング言語の意味にあた

```

hello : String
hello = "hello"

```



###代数的データ型、Union Type、レコード表記

```hs
type Msg = Add String | Error   --Union Type

type State = State (Int,Int)    --並べた型

type alias Position = (Int,Int) --名前の置き換え

type alias Model = {test : String}  --レコード表記

type alias Model = Model {test : String} --カプセル化した書き方

```

###パターンマッチ
Haskell由来の強力なパターンマッチがつかえます。

```Haskell
type Msg = Add String | ...

update : Msg -> Model -> ...
update msg model =
       case msg of
           Add hoge -> hoge ...  ----hogeを取り出している。

view : (Int,Int) -> Html msg
view (x,y) = asText x   ---引数部分でパターンマッチを行い、xだけ取り出している。

step : Zahyou -> ...
step {x,y} = ------レコード形式の型もパターンマッチ出来る！
```
