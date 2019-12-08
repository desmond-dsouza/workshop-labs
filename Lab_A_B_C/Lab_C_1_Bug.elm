module BugSoln exposing (..)

-- 👉 TODO: Make proper Elm module

import GraphicSVG exposing (..)
import GraphicSVG.App exposing (graphicsApp)



------- MODEL -------


type alias Model =
    -- 👉 TODO: Fill this out: what to track? how is this used in the code below?
    ()


type alias Direction =
    -- 👉 TODO: Fill this out
    ()



-- 👉 TODO: Add explicit type for initialModel


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
    -- 👉 TODO: move the bug left or right by 0.2, use record-update syntax
    model


jump model =
    -- 👉 TODO: move the bug up by 0.2, use record-update syntax
    model


go dir model =
    -- 👉 TODO: change bug direction, use record-update syntax
    model


main =
    graphicsApp { view = collage 10 10 (view initialModel) }
