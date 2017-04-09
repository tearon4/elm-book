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
    = TaskMsg Int
    | TaskResult (Result String String)



-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }


subscriptions model =
    Sub.none



--taskSample
---Proce.sleepは指定した時間待機する関数


longTask : Task x String
longTask =
    Process.sleep 5000
        |> Task.map (always "完了！")


task =
    Task.succeed 10


task2 =
    Task.map ((*) 2) task


task3 =
    task2
        |> Task.andThen (\n -> Task.succeed (n + 5))


task4 =
    Process.spawn longTask
        |> Task.andThen (\str -> Task.succeed (toString str ++ "結果！"))


errorTask : Task String a
errorTask =
    Task.fail "失敗！"


errorsTask : Task String String
errorsTask =
    Task.succeed "成功"
        |> Task.andThen (\x -> Task.fail "失敗！")
        |> Task.andThen (\x -> Task.succeed (x ++ "!!!!"))


init : ( Model, Cmd Msg )
init =
    0 ! [ Task.attempt TaskResult errorsTask ]


update msg model =
    model ! []


view model =
    text "hello"
