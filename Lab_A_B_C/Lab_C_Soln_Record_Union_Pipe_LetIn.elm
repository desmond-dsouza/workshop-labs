module Lab_C_Soln_Record_Union_Pipe_LetIn exposing (..)

import GraphicSVG exposing (..)
import GraphicSVG.App exposing (graphicsApp)


type alias Snake =
    {- 👉 TODO: Define record type to fix several type errors,
       and to distinguish between different states of the snake
    -}
    { head : Head
    , body : Body
    , direction : Direction
    , state : SnakeState
    }


type alias Food =
    {- 👉 TODO: Define suitable type alias
       to fix some type errors
    -}
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


type
    SnakeState
    {- 👉 TODO: Edit type defintion as needed
       for visual distinctions
    -}
    = Normal
    | Eating
    | HitSelf
    | HitWall


type alias Position =
    ( Int, Int )


type alias Walls =
    {- 👉 TODO: Define record type guided by some type errors -}
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
            roundedRect cellSize cellSize (0.25 * cellSize)
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
    {- 👉 TODO: Change to single input `pos`, then use `let-in` to split posX and posY -}
    circle (0.5 * cellSize)
        |> filled black
        |> move ( cellSize * toFloat posX, cellSize * toFloat posY )


stepHead : Head -> Direction -> Head
stepHead ( i, j ) direction =
    case direction of
        {- 👉 TODO: Handle Up, Down, Left, Right -}
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
            {- 👉 TODO: Make this a local helper function in stepBody

               💡 HINT: let
                            localVar = ...
                            localFunc x y = ...
                        in
                        resultExpression
            -}
            List.take (List.length list - 1) list
    in
    currHead
        {- 👉 TODO: New body should include where head was.
           However, new body length should be same as old
           if snake did not get food,
           otherwise length should be 1 more

            💡 HINT: replace currBody with a conditional expression
        -}
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


turn : Direction -> Snake -> Snake
turn dir snake =
    {- 👉 TODO: Change what this return:
        New snake should have changed direction

       💡 HINT: use record update syntax, it looks like this:
                { model | foo = bar }
    -}
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
            {- 👉 TODO: nextState should depend on whether
               the snake will hit itself, hit the wall, or get food

                💡 HINT: replace `Normal` below with a nested if-else expression.
                    NOTE: `case-of` is not convenient here as there are multiple conditions
                        to check in sequence
            -}
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


viewGrid : List (Shape msg)
viewGrid =
    [ graphPaperCustom cellSize 0.5 lightGrey
    , circle (0.05 * cellSize) |> filled black
    ]


gridWalls : Walls
gridWalls =
    { left = -7, right = 7, top = 7, bottom = -7 }


main =
    let
        initialSnake =
            { head = ( 4, 2 )
            , body =
                [ ( 4, 3 )
                , ( 4, 4 )
                ]
            , direction = Down
            , state = Normal
            }

        {- 👉 TODO: View snake as initialSnake.
           Also view after steps, turns, various foods & walls.
           Use |> to transform initialSnake
           Option: use REPL to import this file & test functions
        -}
        snake =
            initialSnake

        -- 👉 TODO: uncomment each line below to see effect
        -- |> stepSnake ( 0, 0 ) gridWalls
        -- |> turn Left
        -- |> stepSnake ( 3, 1 ) gridWalls
    in
    graphicsApp
        { view =
            collage 280
                280
                (viewGrid
                    ++ viewSnake snake
                )
        }
