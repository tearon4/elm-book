module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Task exposing (Task)
import Time
import Process


-- MODEL


type alias Model =
    Int


type Msg
    = TaskResult String



-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


subscriptions model =
    Sub.none



--taskSample
---Proce.sleepは指定した時間待機する関数


heavyTask : Task x String
heavyTask =
    Process.sleep 5000
        |> Task.map (always "完了！")


task =
    Task.succeed 10


task2 =
    Task.map ((*) 2) task


task3 =
    task2
        |> Task.andThen (\n -> Task.succeed (n + 5))


init : ( Model, Cmd Msg )
init =
    0 ! [ Task.perform TaskResult heavyTask ]


update msg model =
    model ! []


view model =
    text "hello"
