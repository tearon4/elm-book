module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- MODEL


type alias Model =
    Int


type Msg
    = Hello



-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


subscriptions model =
    Sub.none


init =
    0 ! []


update msg model =
    model ! []


view model =
    text "hello"
