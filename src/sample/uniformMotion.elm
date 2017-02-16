module Main exposing (main)

import Html exposing (Html, Attribute, div, text)
import Html.Attributes as Html
import Mouse
import AnimationFrame as AF
import Time exposing (Time)
import Keyboard exposing (KeyCode)


-- MODEL
--場所と速度


type alias Cell =
    { position : Mouse.Position
    , v : Int
    }


type alias Model =
    List Cell


type Msg
    = Click Mouse.Position
    | Frame Time
    | Key KeyCode



-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Mouse.clicks Click
        , AF.diffs Frame
        , Keyboard.downs Key
        ]



-- init


init : ( Model, Cmd Msg )
init =
    [ { position = { x = 100, y = 100 }
      , v = 3
      }
    ]
        ! []



--画面　横サイズ


viewX =
    1000



--画面　縦サイズ


viewY =
    500



--速度


v =
    3



-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click posi ->
            List.append model [ { position = posi, v = 0 } ] ! []

        Key code ->
            model ! []

        Frame time ->
            List.map
                (\cell ->
                    cell
                        |> changeV
                        |> moveCell
                )
                model
                ! []


changeV : Cell -> Cell
changeV cell =
    if cell.position.y > (viewY - cellWidth) then
        { cell | v = -cell.v }
    else
        cell


moveCell : Cell -> Cell
moveCell ({ position, v } as cell) =
    if (0 <= position.y) then
        let
            posi_ =
                { position | y = position.y + v }
        in
            { cell | position = posi_ }
    else
        cell



-- view


baseCss : Attribute Msg
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


cellWidth =
    20


squareCss =
    [ ( "width", (toString cellWidth) ++ "px" ), ( "height", "20px" ) ]


cellCss : Mouse.Position -> Attribute Msg
cellCss position =
    Html.style <| (positioningCss position) ++ colorCss ++ squareCss



---cell view


cell : Cell -> Html Msg
cell { position } =
    div [ cellCss position ] []
