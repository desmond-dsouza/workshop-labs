module BugSoln exposing (..)

import GraphicSVG exposing (..)
import Lib.WkApp as App exposing (KeyState(..), Keys(..), playSound)



------- MODEL -------


type alias Model =
    { x : Float, y : Float, direction : Direction }


type Direction
    = Left
    | Right


initialModel =
    { x = 0, y = -4, direction = Right }



------- VIEW -------


viewBug ( x, y ) direction =
    let
        body =
            roundedRect 1 0.5 0.2
                |> filled green
                |> move ( x, y )

        eye =
            circle 0.05
                |> filled black
                |> move
                    ( x
                        + (case direction of
                            Right ->
                                0.35

                            Left ->
                                -0.35
                          )
                    , y + 0.1
                    )
    in
    group [ body, eye ]


view model =
    let
        tapSurface =
            rect 10 8
                |> filled (rgba 0 0 0 0)
                |> addOutline (dashed 0.05) lightBlue
                |> move ( 0, -1 )
                |> notifyTapAt BoardTapAt

        resetButton =
            circle 0.5 |> filled purple |> notifyTap ResetBtnTap |> move ( 0, 4 )

        jumpButton =
            circle 0.5 |> filled orange |> notifyTap JumpBtnTap |> move ( 2, 4 )

        bug =
            viewBug ( model.x, model.y ) model.direction
    in
    collage 10
        10
        [ graphPaperCustom 1 0.05 lightGrey
        , bug
        , resetButton
        , jumpButton
        , tapSurface
        ]



------- INTERACTION -------


type Msg
    = Tick Float App.GetKeyState
    | BoardTapAt ( Float, Float )
    | ResetBtnTap
    | JumpBtnTap



------- ACTIONS ON MODEL -------


step model =
    case model.direction of
        Left ->
            { model | x = model.x - 0.2 }

        Right ->
            { model | x = model.x + 0.2 }


jump model =
    { model | y = model.y + 0.2 }


go dir model =
    { model | direction = dir }


reset model =
    initialModel



------- UPDATE -------


decodeKeys : (Keys -> KeyState) -> Maybe Keys
decodeKeys keyF =
    if keyF Space == JustDown || keyF Space == Down then
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


update msg model =
    let
        { x, y, direction } =
            model
    in
    case msg of
        Tick seconds ( keyFunction, _, _ ) ->
            case ( decodeKeys keyFunction, direction ) of
                ( Just Space, _ ) ->
                    ( jump model |> step, playSound "Sounds/jump.wav" )

                ( Just LeftArrow, Right ) ->
                    ( { model | direction = Left } |> step, playSound "Sounds/bump.mp3" )

                ( Just RightArrow, Left ) ->
                    ( { model | direction = Right } |> step, playSound "Sounds/bump.mp3" )

                ( _, _ ) ->
                    ( model |> step, Cmd.none )

        ResetBtnTap ->
            ( reset model, playSound "Sounds/success.wav" )

        JumpBtnTap ->
            ( jump model |> step, playSound "Sounds/jump.wav" )

        BoardTapAt ( tapX, tapY ) ->
            case ( model.direction, tapX <= model.x ) of
                ( Right, True ) ->
                    ( { model | direction = Left }, playSound "Sounds/bump.mp3" )

                ( Left, False ) ->
                    ( { model | direction = Right }, playSound "Sounds/bump.mp3" )

                _ ->
                    ( model, Cmd.none )


main =
    App.cmdGameApp
        (App.Every 300)
        Tick
        { title = "Game!"
        , view = view
        , update = update
        , init = ( initialModel, Cmd.none )
        }
