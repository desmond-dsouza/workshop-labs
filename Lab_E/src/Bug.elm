module Bug exposing (..)

import GraphicSVG exposing (..)
import Lib.WkApp as App


type alias Model =
    { x : Float, y : Float, direction : Direction }


type Direction
    = Left
    | Right


model =
    { x = 0, y = 0, direction = Left }


view =
    let
        body =
            roundedRect 1 0.5 0.2 |> filled green

        eye =
            circle 0.05
                |> filled black
                |> move
                    ( case model.direction of
                        Right ->
                            0.35

                        Left ->
                            -0.35
                    , 0.1
                    )
    in
    [ body, eye ]


main =
    App.graphicsApp
        { view = collage 10 10 view
        }
