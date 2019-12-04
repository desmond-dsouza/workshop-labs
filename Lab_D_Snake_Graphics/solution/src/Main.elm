module Main exposing (..)

import Food
import GraphicSVG exposing (Shape, blue, centered, collage, filled, move, red, size, text)
import GraphicSVG.App exposing (graphicsApp)
import Grid
import Snake
import Types exposing (..)



-- MAIN -------------------


main =
    graphicsApp
        { view =
            Grid.viewport
                (view initialModel)
        }



-- INIT ----------------


initialModel : Model
initialModel =
    { snake =
        { head = ( -2, 0 )
        , body =
            [ ( -3, 0 ), ( -4, 0 ) ]
        , direction = Right
        , state = Normal
        }
    , food = ( Grid.grid.numColumns // 2 - 1, 0 )
    }



-- VIEW ----------------


view : Model -> List (Shape msg)
view model =
    Grid.view
        ++ Food.view model.food
        ++ Snake.view model.snake
        ++ (if isGameOver model then
                viewGameOver

            else
                []
           )


isGameOver : Model -> Bool
isGameOver g =
    g.snake.state == Types.HitSelf || g.snake.state == Types.HitWall


viewGameOver : List (Shape msg)
viewGameOver =
    [ text "GAME OVER" |> size (1.5 |> Grid.fracToGrid) |> centered |> filled red ]


step : Walls -> Model -> Model
step walls model =
    let
        newSnake =
            Snake.stepSnake model.food walls model.snake
    in
    { model | snake = newSnake }
