module Grid exposing (fracToGrid, grid, toGrid, view, viewport, walls)

import GraphicSVG exposing (..)
import GraphicSVG.App exposing (graphicsApp)
import Types exposing (..)


grid : Grid
grid =
    -- 👉 TODO: 14 rows and columns, 20x20 cell
    ()



{- 👉 TODO: Understand why these 2 helper functions exist -}


toGrid : Int -> Float
toGrid i =
    grid.cellSize * toFloat i


fracToGrid : Float -> Float
fracToGrid f =
    grid.cellSize * f


walls : Walls
walls =
    -- 👉 TODO: walls at +/- (1/2 number of rows / columns)
    ()


view : List (Shape msg)
view =
    {- 👉 TODO: Draw:
       graphPaperCustom of cellSize, 0.5 thickness, lightGrey color
       a small black circle (0.05 * cellSize radius) at (0,0)
       darkGrey boundary walls: use `rect` & `outlined` & `solid`
    -}
    []


viewport =
    collage ((grid.numColumns + 4) |> toGrid) ((grid.numRows + 4) |> toGrid)


main =
    graphicsApp
        { view = viewport view }
