module Food exposing (..)

import GraphicSVG exposing (..)
import GraphicSVG.App exposing (graphicsApp)
import Grid exposing (grid, toGrid)
import Types exposing (Food)


view : Food -> List (Shape msg)
view ( i, j ) =
    [ apple (1 |> toGrid)

    {- 👉 TODO: Complete this so the apple is correctly position
       at grid coordinates i, j

        💡 HINT: need `move` with `toGrid`
    -}
    ]


apple : Float -> Shape msg
apple size =
    {- 👉 TODO: Make a single shape of suitable size for the apple.

       At first just a single darkRed circle will do. Get it to display.

       Then add a small green stem, sized and positioned relative to `size`.
       However, you have to return a single `Shape`, not a list.

       If you complete the lab early, go for a fancier apple e.g. two `oval`s

          💡 HINT: see `group` function
    -}
    []


main =
    graphicsApp
        { view =
            -- 👉 TODO:  Should show both the grid view and the food view.
            Grid.viewport []
        }
