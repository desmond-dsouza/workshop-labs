module Lab_B_Preview_Snake_Graphics exposing (..)

{- Make simple changes to this file:
   - Make snake longer / shorter by 1 or 2
   - Change snake head color
   - Change snake body color
   - Give snake body a bend
-}

import GraphicSVG exposing (..)
import GraphicSVG.App as App


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
    circle (0.5 * cellSize)
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


initialSnake =
    ( ( 5, 0 )
    , [ ( 4, 0 ), ( 3, 0 ), ( 2, 0 ), ( 2, 1 ) ]
    )


main =
    App.graphicsApp
        { view =
            collage 280
                280
                (viewGrid ++ viewSnake initialSnake)
        }
