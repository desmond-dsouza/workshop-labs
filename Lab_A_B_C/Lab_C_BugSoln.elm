module BugSoln exposing (..)

-- 👉 TODO: Make proper Elm module

import GraphicSVG exposing (..)
import Lib.WkApp as App exposing (KeyState(..), Keys(..))



------- MODEL -------


type alias Model =
    -- 👉 TODO: Fill this out
    ()


type alias Direction =
    -- 👉 TODO: Fill this out
    ()


initialModel =
    { x = 0, y = -4, direction = Left }



------- VIEW -------


view model =
    let
        body =
            roundedRect 1 0.5 0.2
                |> filled green
                -- 👉 TODO: Try different colors Left vs. Right
                |> move ( model.x, model.y )

        eye =
            circle 0.05
                |> filled black
                |> move
                    ( model.x + 0.35 {- 👉 TODO: This should depend on bug direction -}
                    , model.y + 0.1
                    )

        resetButton =
            circle 0.5 |> filled purple |> notifyTap Reset |> move ( 0, 4 )
    in
    collage 10 10 [ graphPaperCustom 1 0.05 lightGrey, body, eye, resetButton ]



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


main =
    graphicsApp { view = collage 10 10 (view initialModel) }
