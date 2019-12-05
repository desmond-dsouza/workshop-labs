module BugSoln exposing (..)

import GraphicSVG exposing (..)
import GraphicSVG.App exposing (graphicsApp)



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
    {- 👉 TODO:
       body: green rounded rectangle 1x0.5x0.2
       eye: r=0.05 black at +/- 0.35x, +0.1y
    -}
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
    {- 👉 TODO: Show on 10x10 collage:
       - transparent (rgba 0 0 0 0) tapSurface at (0, -1)
           - addOutline (dashed 0.05) lightBlue
       - purple circle resetButton at (0, 4)
       - orange circle jumpButton at (2, 4)
       - the bug
    -}
    let
        tapSurface =
            rect 10 8
                |> filled (rgba 0 0 0 0)
                |> addOutline (dashed 0.05) lightBlue
                |> move ( 0, -1 )

        resetButton =
            circle 0.5 |> filled purple |> move ( 0, 4 )

        jumpButton =
            circle 0.5 |> filled orange |> move ( 2, 4 )

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


main =
    graphicsApp { view = view initialModel }
