module Main exposing (..)

import Food
import GraphicSVG exposing (..)
import Grid
import Lib.WkApp as App exposing (KeyState(..), Keys(..))
import Snake
import Types exposing (..)



-- MAIN -------------------


main =
    App.simpleGameApp
        (App.Every 1000)
        Tick
        { init = initialModel
        , view = view
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
    -- 👉 TODO: Pick 4 locations and rotate betwen them
    let
        loc1 =
            ( 6, 0 )

        loc2 =
            ( -6, 0 )
    in
    if oldLoc == loc1 then
        loc2

    else
        loc1



-- VIEW ----------------


view : Model -> Collage Types.Msg
view model =
    Grid.viewport
        (Grid.view
            ++ maybeNewGameButton model
            ++ Food.view model.food
            ++ Snake.view model.snake
            ++ (if isGameOver model then
                    viewGameOver

                else
                    []
               )
        )


maybeNewGameButton model =
    if isGameOver model then
        [ text "Play Again (arrows to steer)"
            |> sansserif
            |> centered
            |> filled black
            {- 👉 TODO: This button should trigger a NewGame Msg when pressed
               💡 HINT: see notifyTap; Msg type is in Types.elm file.
            -}
            |> move ( 0, 180 )
        ]

    else
        []


isGameOver : Model -> Bool
isGameOver g =
    g.snake.state == Types.HitSelf || g.snake.state == Types.HitWall


viewGameOver : List (Shape Types.Msg)
viewGameOver =
    [ text "GAME OVER" |> size (1.5 |> Grid.fracToGrid) |> centered |> filled red ]



-- UPDATE ----------------


type UserRequest
    = NewGame
    | Turn Direction
    | None


decodeKeys : (Keys -> KeyState) -> UserRequest
decodeKeys keyF =
    if keyF Space == JustDown then
        NewGame

    else if keyF LeftArrow == JustDown then
        Turn Types.Left
        {- 👉 TODO: Should handle all arrow keys
           - Should also handle case of no valid keys being pressed
        -}

    else
        None


update : Types.Msg -> Model -> Model
update msg model =
    case msg of
        -- 👉 TODO: need to cover other msgs too, not just Tick
        Tick time ( keyFunc, _, _ ) ->
            case ( model.snake.state, decodeKeys keyFunc ) of
                ( HitSelf, NewGame ) ->
                    initialModel

                ( HitWall, NewGame ) ->
                    initialModel

                {- 👉 TODO: carefully carefully other valid combinations -}
                ( _, Turn direction ) ->
                    let
                        oldSnake =
                            model.snake
                    in
                    -- 👉 TODO: need to turn snake & step it too
                    { model | snake = oldSnake }

                ( _, _ ) ->
                    model


step : Walls -> Model -> Model
step walls model =
    let
        newSnake =
            Snake.stepSnake model.food walls model.snake
    in
    { model
        | snake = newSnake
        , food =
            -- 👉 TODO: if newSnake is Eating, need new location of food
            model.food
    }
