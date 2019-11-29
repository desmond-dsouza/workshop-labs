module TrySlidesCode exposing (..)

-- directly name functions & types

import GraphicSVG exposing (..)
import GraphicSVG.App exposing (graphicsApp)


c : Shape msg
c =
    circle 10
        |> filled brown


origin : Shape msg
origin =
    text "(0,0)" |> centered |> filled black


main =
    graphicsApp
        { view =
            collage
                400
                400
                [ origin, c |> move ( 50, 50 ), c |> move ( 100, 100 ) ]
        }
