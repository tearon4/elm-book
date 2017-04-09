module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL


type alias Model =
    Int



-- APP


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }


model : Model
model =
    0


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html Msg
view model =
    text "hello"


type Msg
    = TextInput String
    | InputName


textArea : Html Msg
textArea =
    Html.form []
        [ input
            [ onInput TextInput
            , name "text"
            , type_ "text"
            ]
            []
        ]


inputButton : Html Msg
inputButton =
    button [ onClick InputName ] [ text "入力！" ]
