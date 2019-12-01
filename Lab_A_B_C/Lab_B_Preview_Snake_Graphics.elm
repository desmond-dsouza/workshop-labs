module Lab_B_Preview_Snake_Graphics exposing (..)


import GraphicSVG exposing (..)
import GraphicSVG.App as App
-- 👉 NOTE: Also imported previous lab so all its functions are available here
import Lab_A_Soln_REPL_Play exposing (..)


type alias Snake =
    -- A Snake has 2 properties: head and body, represented as a tuple
    ( ( Int, Int ) -- head, a pair of integers for i, j coordinates
    , List ( Int, Int ) -- body, a list of integer pairs
    )


cellSize =
    20.0


viewSnakeHead : Snake -> List (Shape msg)
viewSnakeHead ( ( i, j ), tail ) =
    let
        ( headX0, headY0 ) =
            ( cellSize * toFloat i, cellSize * toFloat j )

        head =
            roundedRect cellSize cellSize (0.25 * cellSize)
                |> filled brown
                |> move ( headX0, headY0 )
    in
    [ head ]


viewSnakeSegment : ( Int, Int ) -> Shape msg
viewSnakeSegment ( posX, posY ) =
    roundedRect cellSize cellSize (0.25 * cellSize)
        |> filled black
        |> move ( cellSize * toFloat posX, cellSize * toFloat posY )


viewSnake : Snake -> List (Shape msg)
viewSnake snake =
    List.map viewSnakeSegment (Tuple.second snake) ++ viewSnakeHead snake


viewGrid : List (Shape msg)
viewGrid =
    [ graphPaperCustom cellSize 0.5 lightGrey
    , circle (0.05 * cellSize) |> filled black
    ]


initialHead =
    ( 5, 0 )


initialBody =
    [ ( 4, 0 ), ( 3, 0 ), ( 2, 0 ), ( 2, 1 ) ]


initialSnake =
    ( initialHead, initialBody )



{- 👉 TODO:
   * Change the snake head color, Save, view result
   * Change the snake body rounded rectangles to circles, Save, view result
   * Add an extra bend to `initialSnake` tail with 2 new segments, Save, view result
   * Change main to view the snake after stepping `initialHead` and `initialBody`
        (try Direction = down, Grow = True or False), view result.
-}


main =
    App.graphicsApp
        { view =
            collage 280
                280
                (viewGrid
                    ++ viewSnake initialSnake
                )
        }
