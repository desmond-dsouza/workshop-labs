module Main exposing (..)

import Food
import GraphicSVG exposing (..)
import Grid
import Lib.WkApp as App exposing (KeyState(..), Keys(..), playSound)
import Snake
import Types exposing (..)



-- 👉 TODO: Will need to import a module for random functions
-- MAIN -------------------


main =
    App.cmdGameApp
        (App.Every 400)
        Tick
        { init = ( initialModel, playStartCmd )
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

    {- 👉 TODO: change this food initialization to a fixed position (6, 0)
       As soon as any food is eaten, randomness will move the next food around
    -}
    }


nextFoodLocation oldLoc =
    {- 👉 TODO: You will not need this any more
       after your random position is working
    -}
    let
        loc1 =
            ( 6, 0 )

        loc2 =
            ( -6, 0 )

        loc3 =
            ( 0, 6 )

        loc4 =
            ( 0, -6 )
    in
    if oldLoc == loc1 then
        loc2

    else if oldLoc == loc2 then
        loc3

    else if oldLoc == loc3 then
        loc4

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
            |> notifyTap Types.NewGame
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


randomXYZCmd : Cmd Types.Msg
randomXYZCmd =
    {- 👉 TODO:
       Rename this variable and its definition to make a Cmd which:
           - asks for a random value of the right type for Food position
           - to be sent back via a specifc Msg that will carry that value
        Define that new variant to the Msg type (in file Types.elm)

          💡 HINT: Random.pair, Random.int, Random.generate
    -}
    Cmd.none


decodeKeys : (Keys -> KeyState) -> Maybe Keys
decodeKeys keyF =
    if keyF Space == JustDown || keyF Space == App.Down then
        Just Space

    else if keyF LeftArrow == JustDown then
        Just LeftArrow

    else if keyF RightArrow == JustDown then
        Just RightArrow

    else if keyF UpArrow == JustDown then
        Just UpArrow

    else if keyF DownArrow == JustDown then
        Just DownArrow

    else
        Nothing


playStartCmd : Cmd msg
playStartCmd =
    playSound "Sounds/fanfare.wav"


playSuccessCmd : Cmd msg
playSuccessCmd =
    playSound "Sounds/success.wav"


playFailureCmd : Cmd msg
playFailureCmd =
    playSound "Sounds/failure.wav"


update : Types.Msg -> Model -> ( Model, Cmd msg )
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
        Tick time ( keyFunc, _, _ ) ->
            case ( model.snake.state, decodeKeys keyFunc ) of
                ( HitSelf, Just Space ) ->
                    ( initialModel, playStartCmd )

                ( HitWall, Just Space ) ->
                    ( initialModel, playStartCmd )

                ( HitSelf, _ ) ->
                    ( model, Cmd.none )

                ( HitWall, _ ) ->
                    ( model, Cmd.none )

                ( _, Just key ) ->
                    let
                        snake =
                            model.snake
                    in
                    { model | snake = Snake.turn (keyToDir snake.direction key) snake }
                        |> step Grid.walls

                ( _, _ ) ->
                    model |> step Grid.walls

        Types.NewGame ->
            ( initialModel, playStartCmd )


step : Walls -> Model -> ( Model, Cmd msg )
step walls model =
    let
        newSnake =
            Snake.stepSnake model.food walls model.snake
    in
    ( { model
        | snake = newSnake
        , food =
            {- 👉 TODO:
                Since you don't want to put food at a fixed location, or even rotating fixed locations:
                    - Understand your command that requests a random position value
                        - to be sent back via a Msg
                    - Handle that new Msg in `update`, alongside Tick, NewGame, etc.
                        - In that `case` branch, put the food into the game at the new random position
                    - Keep the current food position for now, until you get your random value
               💡 HINT: See Cmd.batch to combine commands, such as sound + random
            -}
            if newSnake.state == Eating then
                nextFoodLocation model.food

            else
                model.food
      }
    , case newSnake.state of
        Eating ->
            playSuccessCmd

        HitSelf ->
            playFailureCmd

        HitWall ->
            playFailureCmd

        _ ->
            Cmd.none
    )
