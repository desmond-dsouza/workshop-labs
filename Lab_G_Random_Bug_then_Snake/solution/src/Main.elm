module Main exposing (..)

import Food
import GraphicSVG exposing (..)
import Grid
import Lib.WkApp as App exposing (KeyState(..), Keys(..), playSound)
import Snake
import Types exposing (..)



-- MAIN -------------------


main =
    App.cmdGameApp
        (App.Every 200)
        Tick
        { init = ( initialModel, Cmd.none )
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
    , food = ( Grid.grid.numColumns // 2 - 1, 0 )
    }



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


update : Types.Msg -> Model -> ( Model, Cmd Types.Msg )
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
                    ( initialModel, Cmd.batch [ Food.randomFoodCmd, playStartCmd ] )

                ( HitWall, Just Space ) ->
                    ( initialModel, Cmd.batch [ Food.randomFoodCmd, playStartCmd ] )

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

        NewFood food ->
            ( { model | food = food }, Cmd.none )

        Types.NewGame ->
            ( initialModel, playStartCmd )


step : Walls -> Model -> ( Model, Cmd Types.Msg )
step walls model =
    let
        newSnake =
            Snake.stepSnake model.food walls model.snake
    in
    ( { model | snake = newSnake }
    , case newSnake.state of
        Eating ->
            Cmd.batch
                [ Food.randomFoodCmd
                , playSuccessCmd
                ]

        HitSelf ->
            playFailureCmd

        HitWall ->
            playFailureCmd

        _ ->
            Cmd.none
    )
