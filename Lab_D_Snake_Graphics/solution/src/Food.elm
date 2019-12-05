module Food exposing (..)

import GraphicSVG exposing (..)
import GraphicSVG.App exposing (graphicsApp)
import Grid exposing (grid, toGrid)
import Types exposing (Food)


view : Food -> List (Shape msg)
view ( i, j ) =
    [ apple (1 |> toGrid)
        |> move ( i |> toGrid, j |> toGrid )
    ]


apple : Float -> Shape msg
apple size =
    group
        [ line ( -0.1 * size, 0.2 * size ) ( 0.2 * size, 0.8 * size )
            |> outlined (solid (size * 0.1)) darkGreen
        , oval (size * 0.6) size |> filled darkRed |> move ( -size * 0.2, 0 )
        , oval (size * 0.6) size |> filled darkRed |> move ( size * 0.2, 0 )
        ]


main =
    graphicsApp
        { view =
            Grid.viewport
                (Grid.view ++ view ( 5, 5 ))
        }
