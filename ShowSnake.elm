module ShowSnake exposing (..)

{- Prerequisites:
   X VSCode arrange-windows
   X records unions let-in |>
   elm-live Cmd-click
   stencil, shape (ignore userMsg), collage, z-order
   i,j vs. coordinates
-}

import GraphicSVG exposing (..)
import GraphicSVG.App as App


type alias Snake =
    { head : Head
    , body : Body
    , direction : Direction
    , state : SnakeState
    }


type Direction
    = Up
    | Down
    | Left
    | Right


type SnakeState
    = Normal
    | Eating
    | HitSelf
    | HitWall


type alias Head =
    ( Int, Int )


type alias Body =
    List Segment


type alias Segment =
    ( Int, Int )


grid =
    -- best to use even numbers for cols & rows
    { numColumns = 14, numRows = 14 }


cellSize =
    20.0


toGrid : Int -> Float
toGrid i =
    cellSize * toFloat i


fracToGrid : Float -> Float
fracToGrid f =
    cellSize * f


viewSnakeHead : Snake -> List (Shape msg)
viewSnakeHead snake =
    let
        ( i, j ) =
            snake.head

        ( headX0, headY0 ) =
            ( i |> toGrid, j |> toGrid )

        eyeRadius =
            0.15 |> fracToGrid

        rotation =
            degrees
                (case snake.direction of
                    Right ->
                        0

                    Up ->
                        90

                    Left ->
                        180

                    Down ->
                        270
                )

        head =
            rect (1 |> toGrid) (1 |> toGrid)
                |> filled
                    (case snake.state of
                        Normal ->
                            brown

                        Eating ->
                            pink

                        HitSelf ->
                            red

                        HitWall ->
                            purple
                    )
                |> rotate rotation
                |> move ( headX0, headY0 )

        eyeLeft =
            circle eyeRadius |> filled black |> move ( 0.25 |> fracToGrid, 0.25 |> fracToGrid ) |> rotate rotation |> move ( headX0, headY0 )

        eyeRight =
            circle eyeRadius |> filled black |> move ( 0.25 |> fracToGrid, -0.25 |> fracToGrid ) |> rotate rotation |> move ( headX0, headY0 )
    in
    [ head, eyeLeft, eyeRight ]


viewSnakeSegment : Segment -> Shape msg
viewSnakeSegment ( posX, posY ) =
    rect (1 |> toGrid) (1 |> toGrid) |> filled black |> move ( posX |> toGrid, posY |> toGrid )


viewSnake : Snake -> List (Shape msg)
viewSnake snake =
    List.map viewSnakeSegment snake.body ++ viewSnakeHead snake


initialSnake =
    { head = ( 4, 2 )
    , body =
        [ ( 4, 3 )
        , ( 4, 4 )
        , ( 5, 4 )
        , ( 6, 4 )
        , ( 6, 5 )
        ]
    , direction = Up
    , state = Normal
    }


main =
    let
        side =
            cellSize * toFloat (grid.numColumns + 4)
    in
    App.graphicsApp
        { view =
            collage side
                side
                (graphPaper
                    cellSize
                    :: (circle (cellSize / 2)
                            |> filled red
                       )
                    :: viewSnake initialSnake
                )
        }
