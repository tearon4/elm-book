#型とパターンマッチ

型はパターンマッチを行うことが出来ます。

```Haskell
type Msg = Add String | ...

update : Msg -> Model -> ...
update msg model =
       case msg of
           Add hoge -> hoge ...  ----hogeを取り出している。

view : (Int,Int) -> Html msg
view (x,y) = asText x   

type alias Point = {x : Int , y :Int}

step : Point -> ...
step {x,y} = ------レコード形式の型もパターンマッチ出来る！
```
