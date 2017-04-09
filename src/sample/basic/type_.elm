module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- MODEL


type alias Model =
    Int


type Msg
    = Hello


type User
    = User Int String ( Int, Int )


user1 =
    User 1 "elm" ( 0, 0 )


type alias User2 =
    { id : Int, name : String, position : ( Int, Int ) }


user2 =
    { id = 2, name = "elm2", position = ( 0, 0 ) }



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
