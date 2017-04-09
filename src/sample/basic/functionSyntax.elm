module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


----function syntax sample


type Id
    = Id Int



-- Idデータ構築子で定義される、Id型。
-- Id型を引数に取るgetNum関数


getNum : Id -> Int
getNum (Id num) =
    num



-- パターンマッチ　例


type alias User =
    { id : Int
    , name : String
    }


getName : User -> String
getName { name } =
    name


type alias Position =
    ( Int, Int )


getX : Position -> Int
getX ( x, y ) =
    x



-- MODEL


type alias Model =
    Id


type Msg
    = Hello



-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


subscriptions model =
    Sub.none


init =
    Id 0 ! []


update msg model =
    model ! []


view model =
    text <| getName { name = "hello", id = 0 }
