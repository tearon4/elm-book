#Cmd/Subバージョン

programという関数は以下のような型になっています。

```
program
  : { init : (model, Cmd msg)
    , update : msg -> model -> (model, Cmd msg)
    , subscriptions : model -> Sub msg
    , view : model -> Html msg
    }
  -> Program Never
```

使うときは、init関数、update関数などの関数を用意してレコード型で渡します。

```

main = program {　init = init
               ,　update = update
               , subscriptions = subscriptions
               , view = view }

```
