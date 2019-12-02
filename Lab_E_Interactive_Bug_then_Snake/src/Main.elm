module Main exposing (..)

import Food
import GraphicSVG exposing (Shape, blue, centered, collage, filled, move, red, size, text)
import GraphicSVG.App exposing (graphicsApp)
import Grid
import Snake
import Types exposing (..)



{- 👉 TODO:
      - You already have `view` as a function, and an `initialModel`
      - You already have many update-related functions, like `step` and `turn`
      - You will need to `import` `simpleGameApp` and other items from Lib.WkApp
          - And will no longer need `GraphicSVG.App` or `graphicsApp`
      - In `Types.elm` define Msg type as: Tick Float GetKeyState
          - Tick will tell us a time slice has elapsed
          - GetKeyState will give information about keys pressed
          - GetKeyState = (Keys -> KeyState, _, _)
          - We only need the 1st item in GetKeyState to detect specific keys
      - Use `simpleGameApp` in your `main` -- it will need an `update`
      - Write a dummy `update` function that just `steps` the model (animation)
          - Your goal is just for `simpleGameApp` to compile and run
      - When the snake eats the apple, just let the new apple be in the same place (for now)
      - Add type `UserRequests` (in Types.elm) to describe the main user requests that accompany each Tick
          - Turn in some direction
          - Start new game
          - None of the above / just keep going
      - Add helper `userRequest: (Keys -> KeyState) -> UserRequests`
      - Use it and extend `update` to turn the snake
      - Extend `update` to start a new game on demand

   If you finish the above early, you can try this to move the food around a bit:
      - Alternate the apple between 2 fixed locations coded into `nextFoodLocation`
      - nextFoodLocation : Food -> Food -- given current food location, what is the next one


-}
-- MAIN -------------------


main =
    graphicsApp
        { view =
            Grid.viewport
                (Grid.view ++ view initialModel)
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
