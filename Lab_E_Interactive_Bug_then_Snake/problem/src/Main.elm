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


decodeKeys : (Keys -> KeyState) -> Maybe Keys
decodeKeys keyF =
    if keyF Space == JustDown then
        Just Space

    else if keyF LeftArrow == JustDown then
        Just LeftArrow
        {- 👉 TODO: Should handle all arrow keys
           - Should also handle case of no valid keys being pressed
        -}

    else
        Nothing


update : Types.Msg -> Model -> Model
update msg model =
    let
        keyToDir oldDir key =
            case key of
                LeftArrow ->
                    Left

                RightArrow ->
                    Right

                UpArrow ->
                    Types.Up

                DownArrow ->
                    Types.Down

                _ ->
                    oldDir
    in
    case msg of
        -- 👉 TODO: need to cover other msgs too, not just Tick
        Tick time ( keyFunc, _, _ ) ->
            case ( model.snake.state, decodeKeys keyFunc ) of
                ( HitSelf, Just Space ) ->
                    initialModel

                ( HitWall, Just Space ) ->
                    initialModel

                {- 👉 TODO: consider other valid combinations -}
                ( _, Just key ) ->
                    let
                        oldSnake =
                            model.snake
                    in
                    -- 👉 TODO: need to turn snake based on "key", & step it too
                    { model | snake = oldSnake }

                ( _, _ ) ->
                    -- 👉 TODO: is juse "model" correct?
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
