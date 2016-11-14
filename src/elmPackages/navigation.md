elm-lang/navigation

urlの変更、urlの変更時の表示の切り替え、


location変更時のMsg

```
type Msg
    = LocationChange Location
    | Click
```

NavigationにあるprogramやprogramWithFlagsを使う。

```
main =
    Navigation.program LocationChange { init = init, view = view, update = update, subscriptions = subscriptions }

```
