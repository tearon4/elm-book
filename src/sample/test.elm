module Main exposing (..)

import Html exposing (text)
import Html.App exposing (program)


main =
    program { init = init, update = update, view = view, subscriptions = subscriptions }


init =
    "" ! []


update msg model =
    model ! []


view model =
    text "hello"


subscriptions model =
    Sub.none
