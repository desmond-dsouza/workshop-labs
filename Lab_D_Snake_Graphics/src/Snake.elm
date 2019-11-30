module Snake exposing (..)

import GraphicSVG exposing (..)
import GraphicSVG.App exposing (graphicsApp)
import Grid exposing (fracToGrid, grid, toGrid)
import Types exposing (Body, Direction(..), Food, Head, Position, Segment, Snake, SnakeState(..), Walls)


view : Snake -> List (Shape msg)
view snake =
    {- 👉 TODO: Make a shape list including both head and body.
       In the list put body first, then head, so head will never be covered up.
       You already have `viewSnakeHead` helper below (it needs some fixes).
       You also have a `viewSnakeSegment` helper below. How can you use it for the body?

        💡 HINT: See `List.map`
            See `::` for adding a single item in front of a list.
            See `++` for appending two lists together.
    -}
    []


viewSnakeHead : Snake -> List (Shape msg)
viewSnakeHead snake =
    let
        ( i, j ) =
            snake.head

        ( headX0, headY0 ) =
            ( i |> toGrid, j |> toGrid )

        head =
            roundedRect (1 |> toGrid) (1 |> toGrid) (0.25 |> fracToGrid)
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
                |> move ( headX0, headY0 )

        eyeRadius =
            0.15 |> fracToGrid

        eyeRotation =
            {- 👉 TODO: 0 degrees is only for direction = Right.
                        Other directions need rotation.

               💡 HINT: see `rotate` function: rotates some degree counter-clockwise
            -}
            degrees 0

        eyeLeft =
            {- 👉 TODO: Both eyes should also rotate by `eyeRotation` degrees.

               💡 HINT: Rotate is easiest to calculate around origin i.e. before final `move`.
            -}
            circle eyeRadius
                |> filled black
                |> move ( 0.25 |> fracToGrid, 0.25 |> fracToGrid )
                |> move ( headX0, headY0 )

        eyeRight =
            circle eyeRadius
                |> filled black
                |> move ( 0.25 |> fracToGrid, -0.25 |> fracToGrid )
                |> move ( headX0, headY0 )
    in
    [ head, eyeLeft, eyeRight ]


viewSnakeSegment : Segment -> Shape msg
viewSnakeSegment ( posX, posY ) =
    circle (0.5 |> fracToGrid) |> filled black |> move ( posX |> toGrid, posY |> toGrid )


invalidTransitions : List ( Direction, Direction )
invalidTransitions =
    [ ( Left, Right ), ( Right, Left ), ( Up, Down ), ( Down, Up ) ]


nextDirection : Direction -> Direction -> Direction
nextDirection oldDir newDir =
    {- 👉 TODO:
       Should be newDir only when oldDir -> newDir is a valid transition.
       Else should be oldDir.

       💡 HINT: See `List.member` and `invalidTransistions` above.
    -}
    newDir


turn : Direction -> Snake -> Snake
turn newDirection snake =
    { snake | direction = nextDirection snake.direction newDirection }


stepHead : Head -> Direction -> Head
stepHead ( i, j ) direction =
    case direction of
        Up ->
            ( i, j + 1 )

        Right ->
            ( i + 1, j )

        Down ->
            ( i, j - 1 )

        Left ->
            ( i - 1, j )


stepBody : Head -> Bool -> Body -> Body
stepBody currHead gotFoodNext currBody =
    let
        removeLast : List a -> List a
        removeLast list =
            List.take (List.length list - 1) list
    in
    currHead
        :: (case gotFoodNext of
                True ->
                    currBody

                False ->
                    removeLast currBody
           )


gotFood : Head -> Food -> Bool
gotFood h f =
    h == f


hitSelf : Head -> Body -> Bool
hitSelf head body =
    List.member head body


hitWall : Head -> Walls -> Bool
hitWall ( i, j ) walls =
    i < walls.left || i > walls.right || j < walls.bottom || j > walls.top


stepSnake : Food -> Walls -> Snake -> Snake
stepSnake food walls snake =
    let
        nextHead =
            stepHead snake.head snake.direction

        nextGotFood =
            gotFood nextHead food

        nextBody =
            stepBody snake.head nextGotFood snake.body

        nextState =
            if hitSelf nextHead nextBody then
                HitSelf

            else if hitWall nextHead walls then
                HitWall

            else if nextGotFood then
                Eating

            else
                Normal
    in
    { snake | head = nextHead, body = nextBody, state = nextState }


main =
    let
        initialSnake =
            { head = ( 4, 2 )
            , body =
                [ ( 4, 3 )
                , ( 4, 4 )
                ]
            , direction = Right
            , state = Normal
            }
    in
    graphicsApp
        { view = Grid.viewport (Grid.view ++ view initialSnake) }
