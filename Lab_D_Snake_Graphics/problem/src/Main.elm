module Main exposing (..)

import Food
import GraphicSVG exposing (Shape, black, blue, centered, collage, filled, move, red, size, text)
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
    {- 👉 TODO: Show the grid, food, snake.
        Depending on state, also show:
            - a "Game Over" message
            - text "Play Again" (will become a button to press)
                filled black, located at ( 0, 180 )
       All these should be based on the input `model`. Use `++` to append lists.
    -}
    []


isGameOver : Model -> Bool
isGameOver g =
    {- 👉 TODO: Fill in the 2 conditions under which the game is "Over" -}
    False


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
