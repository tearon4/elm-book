module Main exposing (..)

import Html exposing (Html, Attribute, div, text)
import Html.Attributes as Html
import Mouse


-- MODEL


type alias Model =
    List Mouse.Position


type Msg
    = Click Mouse.Position



-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


subscriptions : Model -> Sub Msg
subscriptions model =
    Mouse.clicks Click



-- init


init : ( Model, Cmd Msg )
init =
    [] ! []



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click position ->
            List.append model [ position ] ! []



-- view


baseCss : Attrubute Msg
baseCss =
    Html.style [ ( "position", "relative" ) ]


view : Model -> Html Msg
view model =
    List.map cell model
        |> div [ baseCss ]



-- cell Css


positioningCss { x, y } =
    [ ( "position", "absolute" )
    , ( "top", (toString y) ++ "px" )
    , ( "left", (toString x) ++ "px" )
    ]


colorCss =
    [ ( "background-color", "#99cc00" ) ]


squareCss =
    [ ( "width", "20px" ), ( "height", "20px" ) ]


cellCss : Mouse.Position -> Attribute Msg
cellCss position =
    Html.style <| (positioningCss position) ++ colorCss ++ squareCss



---cell view


cell : Mouse.Position -> Html Msg
cell position =
    div [ cellCss position ] []
