module Main exposing (..)

import Html exposing (..)
import Http
import Task
import Json.Decode as Json


-- MODEL


type alias Model =
    List String



-- Msg


type Msg
    = GetInitData (Result Http.Error String)



-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


sampleJsonDecoder =
    Json.string


initGet : Cmd Msg
initGet =
    Http.get "./sample.json" sampleJsonDecoder
        |> Http.send GetInitData


init : ( Model, Cmd Msg )
init =
    [] ! [ initGet ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetInitData (Ok str) ->
            List.append model [ str ] ! []

        _ ->
            model ! []


view : Model -> Html Msg
view model =
    text <| toString model
