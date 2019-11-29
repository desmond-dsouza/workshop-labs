module Lab_C_Record_Union_Pipe_LetIn exposing (..)

import GraphicSVG exposing (..)
import GraphicSVG.App exposing (graphicsApp)



{- 👉 TODO: Bunch of type definitions and aliases -}


type alias Snake =
    { head : Head
    , body : Body
    , direction : Direction
    , state : SnakeState
    }


type alias Food =
    Position


type alias Head =
    Position


type alias Body =
    List Segment


type alias Segment =
    Position


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


type alias Position =
    ( Int, Int )


type alias Walls =
    { left : Int, right : Int, top : Int, bottom : Int }


cellSize =
    20.0


viewSnake : Snake -> List (Shape msg)
viewSnake snake =
    List.map viewSnakeSegment snake.body ++ viewSnakeHead snake


viewSnakeHead : Snake -> List (Shape msg)
viewSnakeHead snake =
    let
        ( i, j ) =
            snake.head

        ( headX0, headY0 ) =
            ( cellSize * toFloat i, cellSize * toFloat j )

        {- 👉 TODO: head color should vary with snake state.
            Normal: brown
            Eating: pink
            HitSelf: red
            HitWall: purple

           💡 HINT: case var of
                        A -> valueA
                        B -> valueB
        -}
        head =
            rect cellSize cellSize
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
    in
    [ head ]


viewSnakeSegment : ( Int, Int ) -> Shape msg
viewSnakeSegment ( posX, posY ) =
    roundedRect cellSize cellSize 5
        |> filled black
        |> move ( cellSize * toFloat posX, cellSize * toFloat posY )


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



{- 👉 TODO: Add stepSnake to earlier lab REPL_Play?
   Include walls in this lab??
-}


turn : Direction -> Snake -> Snake
turn dir snake =
    { snake | direction = dir }


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


removeLast : List a -> List a
removeLast list =
    {- 👉 TODO: Make this a local helper function in stepBody

       💡 HINT: let
                    localVar = ...
                    localFunc x y = ...
                in
                resultExpression
    -}
    List.take (List.length list - 1) list


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

        {- 👉 TODO: View snake as initialSnake.
           Also view after steps, turns, various foods & walls.
           Use |> to transform initialSnake
           Option: use REPL to import this file & test functions
        -}
        snake =
            initialSnake
    in
    graphicsApp
        { view = collage 280 280 (viewSnake snake) }
