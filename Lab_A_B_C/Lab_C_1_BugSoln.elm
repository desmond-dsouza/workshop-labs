module Lab_C_1_BugSoln exposing (..)

-- 👉 TODO: Make proper Elm module

import GraphicSVG exposing (..)
import GraphicSVG.App exposing (graphicsApp)



------- MODEL -------


type alias Model =
    -- 👉 TODO: Fill this out: what to track? how is this used in the code below?
    { x : Int, y : Int, direction : Direction }


type
    Direction
    -- 👉 TODO: Fill this out
    = Left
    | Right



-- 👉 TODO: Add explicit types as needed everywhere below


initialModel : Model
initialModel =
    { x = 0, y = 0, direction = Left }



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
    in
    [ graphPaperCustom 1 0.05 lightGrey, body, eye ]



------- ACTIONS ON MODEL -------


step model =
    -- 👉 TODO: move the bug left or right by 0.2, use record-update syntax
    case model.direction of
        Left ->
            { model | x = model.x - 0.2 }

        Right ->
            { model | x = model.x + 0.2 }


jump model =
    -- 👉 TODO: move the bug up by 0.2, use record-update syntax
    { model | y = model.y + 0.2 }


go dir model =
    -- 👉 TODO: change bug direction, use record-update syntax
    { model | direction = dir }


main =
    graphicsApp { view = collage 10 10 (view initialModel) }
