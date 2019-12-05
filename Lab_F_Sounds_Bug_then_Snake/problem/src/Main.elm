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
        -- 👉 TODO: simpleGameApp cannot handle Cmds, needs cmdGameApp
        (App.Every 400)
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



{- 👉 TODO: Define playXYZCmd variables with types & sounds from Sounds directory
   - playStartCmd
   - playSuccessCmd
   - playFailureCmd
   (Or you can directly use playSound "file" where needed)
-}


update : Types.Msg -> Model -> Model
update msg model =
    {- 👉 TODO: This type changes to include `Cmd` -}
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
        {- 👉 TODO:
           Add Cmds:
              - Cmd.none or your predefined sound variable (or playSound "...")
                    - Some changes can be here, others in `step` (which `update` uses)
              - Make sounds for eating, hit self, hit wall. Any other? Initial sound?
              - Sounds directory has available sounds (DON'T spend much time choosing)
        -}
        Tick time ( keyFunc, _, _ ) ->
            case ( model.snake.state, decodeKeys keyFunc ) of
                ( HitSelf, Just Space ) ->
                    initialModel

                ( HitWall, Just Space ) ->
                    initialModel

                ( HitSelf, _ ) ->
                    model

                ( HitWall, _ ) ->
                    model

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
            initialModel


step : Walls -> Model -> Model
step walls model =
    {- 👉 TODO: Change this to include sound Cmds depending on state -}
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
