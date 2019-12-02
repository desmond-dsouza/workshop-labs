module Main exposing (..)

import Food
import GraphicSVG exposing (Shape, blue, centered, collage, filled, move, red, size, text)
import Grid
import Lib.WkApp as App exposing (KeyState(..), Keys(..))
import Snake
import Types exposing (..)



-- MAIN -------------------


main =
    App.simpleGameApp
        (App.Every 400)
        Tick
        { init = initialModel
        , view = \model -> Grid.viewport (view model)
        , update = update
        , title = "Snake"
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
    , food = nextFoodLocation ( 0, 0 )
    }


nextFoodLocation oldLoc =
    let
        loc1 =
            ( Grid.grid.numColumns // 2 - 1, 0 )

        loc2 =
            ( -(Grid.grid.numColumns // 2 - 1), 0 )
    in
    if oldLoc == loc1 then
        loc2

    else
        loc1



-- VIEW ----------------


view : Model -> List (Shape Msg)
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


viewGameOver : List (Shape Msg)
viewGameOver =
    [ text "GAME OVER" |> size (1.5 |> Grid.fracToGrid) |> centered |> filled red ]



-- UPDATE ----------------


userRequest : (Keys -> KeyState) -> UserRequest
userRequest keyF =
    if keyF Space == JustDown then
        NewGame

    else if keyF LeftArrow == JustDown then
        Turn Types.Left

    else if keyF DownArrow == JustDown then
        Turn Types.Down

    else if keyF RightArrow == JustDown then
        Turn Types.Right

    else if keyF UpArrow == JustDown then
        Turn Types.Up

    else
        None


update : Msg -> Model -> Model
update msg model =
    case msg of
        Tick time ( keyFunc, sumOfArrows1, sumOfArrows2 ) ->
            case ( model.snake.state, userRequest keyFunc ) of
                ( HitSelf, NewGame ) ->
                    initialModel

                ( HitWall, NewGame ) ->
                    initialModel

                ( HitSelf, _ ) ->
                    model

                ( HitWall, _ ) ->
                    model

                ( _, Turn direction ) ->
                    let
                        snake =
                            model.snake
                    in
                    { model | snake = Snake.turn direction snake }
                        |> step Grid.walls

                ( _, _ ) ->
                    model |> step Grid.walls


step : Walls -> Model -> Model
step walls model =
    let
        newSnake =
            Snake.stepSnake model.food walls model.snake
    in
    { model
        | snake = newSnake
        , food =
            if newSnake.state == Eating then
                nextFoodLocation model.food

            else
                model.food
    }
