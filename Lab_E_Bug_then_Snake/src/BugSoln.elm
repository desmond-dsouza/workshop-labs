module BugSoln exposing (..)

import GraphicSVG exposing (..)
import Lib.WkApp as App exposing (KeyState(..), Keys(..))


type alias Model =
    { x : Float, y : Float, direction : Direction }


type Direction
    = Left
    | Right


initialModel =
    { x = 4, y = 2, direction = Left }


view model =
    let
        body =
            roundedRect 1 0.5 0.2
                |> filled green
                |> move ( model.x, model.y )

        eye =
            circle 0.05
                |> filled black
                |> move
                    ( model.x
                        + (case model.direction of
                            Right ->
                                0.35

                            Left ->
                                -0.35
                          )
                    , model.y + 0.1
                    )
    in
    collage 10 10 [ body, eye ]


type Msg
    = Tick Float App.GetKeyState


type UserRequest
    = Go Direction
    | Jump
    | None


userRequest : (Keys -> KeyState) -> UserRequest
userRequest keyF =
    if keyF Space == JustDown then
        Jump

    else if keyF LeftArrow == JustDown then
        Go Left

    else if keyF RightArrow == JustDown then
        Go Right

    else
        None


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


update msg model =
    let
        { x, y, direction } =
            model
    in
    case msg of
        Tick seconds ( keyFunction, _, _ ) ->
            case ( userRequest keyFunction, direction ) of
                ( Jump, _ ) ->
                    jump model |> step

                ( Go Left, Right ) ->
                    go Left model

                ( Go Right, Left ) ->
                    go Right model

                ( _, _ ) ->
                    model |> step


main =
    App.simpleGameApp
        (App.Every 300)
        Tick
        { title = "Game!"
        , view = view
        , update = update
        , init = initialModel
        }
