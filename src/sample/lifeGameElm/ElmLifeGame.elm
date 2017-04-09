module ElmLifeGame exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Matrix
import Matrix.Extra as Matrix
import Array
import Html.Events exposing (onClick)
import Time


{-
   Elmで作ったライフゲームのサンプル

   eeue56/elm-flat-matrixという二次元ライブラリを使っています。

-}
{- 生きているセル、死んでいるセル -}


type CellType
    = LifeCell
    | DeathCell


changeCell : CellType -> CellType
changeCell cellType =
    case cellType of
        LifeCell ->
            DeathCell

        DeathCell ->
            LifeCell


type alias Position =
    ( Int, Int )


type alias Model =
    { mode : Mode
    , matrix : Matrix.Matrix CellType
    }



{-
   Mode -- ゲームの状態、ストップしてクリックしてセルをいじれるシーンか、時間とともに世代が変わっていくシーンかの２つ
-}


type Mode
    = EditorMode
    | GenerationMode



{-
   CellClick -- 画面をクリックしてセルの生き死にを切り替える
   NextGeneration -- 次の世代に移る。ライフゲームの処理。Time.everyで何秒毎に引き起こされる。
   Stop --世代が変わっていく動作のストップ
   Start --世代が変わっていく動作をスタート
-}


type Msg
    = CellClick Position
    | NextGeneration Time.Time
    | Stop
    | Start


main : Program Never Model Msg
main =
    program { init = init, update = update, subscriptions = subscriptions, view = view }


init : ( Model, Cmd msg )
init =
    { mode = EditorMode, matrix = world } ! []


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Start ->
            { model | mode = GenerationMode } ! []

        Stop ->
            { model | mode = EditorMode } ! []

        CellClick ( x, y ) ->
            { model | matrix = Matrix.update x y (\cellType -> changeCell cellType) model.matrix } ! []

        NextGeneration time ->
            { model | matrix = Matrix.indexedMap (rule model.matrix) model.matrix } ! []



--LifeGame のルール


rule : Matrix.Matrix CellType -> Int -> Int -> CellType -> CellType
rule matrix x y cellType =
    let
        --周りのマスの生きているセルの数
        neighboursNum =
            Matrix.neighbours x y matrix
                |> List.filter
                    (\x ->
                        if x == LifeCell then
                            True
                        else
                            False
                    )
                |> List.length
    in
        case ( neighboursNum, cellType ) of
            ( 3, DeathCell ) ->
                LifeCell

            ( 3, LifeCell ) ->
                LifeCell

            ( 2, LifeCell ) ->
                LifeCell

            ( _, LifeCell ) ->
                DeathCell

            ( _, _ ) ->
                DeathCell


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.mode of
        EditorMode ->
            Sub.none

        _ ->
            Time.every (500 * Time.millisecond) NextGeneration


view : Model -> Html Msg
view model =
    div []
        [ table [] <| worldToHtml model.matrix
        , buttons
        ]



{- eeue56/elm-flat-matrixライブラリのMatrixは、row(行)で取り出すことが出来ます。
   全rowを取り出して、HTMLにする必要があります。そのあたりの処理
-}


rows : Matrix.Matrix CellType -> List (Array.Array CellType)
rows matrix =
    List.map
        (\n ->
            Matrix.getRow n matrix
                |> Maybe.withDefault Array.empty
        )
    <|
        List.range 0 (Matrix.height matrix - 1)


worldToHtml : Matrix.Matrix CellType -> List (Html Msg)
worldToHtml matrix =
    rows matrix
        |> List.indexedMap
            (\y array ->
                Array.indexedMap (\x n -> td [] [ cell ( x, y ) n ]) array
                    |> Array.toList
                    |> tr []
            )


world : Matrix.Matrix CellType
world =
    Matrix.repeat 10 10 DeathCell


cell : ( Int, Int ) -> CellType -> Html Msg
cell position cellType =
    div
        [ onClick (CellClick position)
        , style <| cellStyle cellType
        ]
        []


cellStyle : CellType -> List ( String, String )
cellStyle ctype =
    case ctype of
        LifeCell ->
            cellCss ++ [ ( "background-color", "#000000" ) ]

        DeathCell ->
            cellCss


cellSize : Int
cellSize =
    40


cellCss : List ( String, String )
cellCss =
    [ ( "width", (toString cellSize) ++ "px" )
    , ( "height", (toString cellSize) ++ "px" )
    , ( "border", "solid 1px #000000" )
    ]


stopButton : Html Msg
stopButton =
    button [ onClick Stop ] [ text "stop" ]


startButton : Html Msg
startButton =
    button [ onClick Start ] [ text "start" ]


buttons : Html Msg
buttons =
    div [] [ stopButton, startButton ]
