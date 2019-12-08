module Lab_A_Soln_REPL_Play exposing (..)


type alias Head =
    ( Int, Int )


type alias Food =
    ( Int, Int )


type alias Direction =
    String


type alias Grow =
    Bool


type alias Body =
    List ( Int, Int )


type alias Snake =
    -- A Snake has 2 properties: head and body, in a tuple
    ( Head -- head, a pair of integers for i, j coordinates
    , Body -- body, a list of integer pairs
    )


stepHead : Head -> Direction -> Head
stepHead ( i, j ) dir =
    case dir of
        "Right" ->
            ( i + 1, j )

        "Left" ->
            ( i - 1, j )

        "Up" ->
            ( i, j + 1 )

        "Down" ->
            ( i, j - 1 )

        -- 👉 TODO: Delete last case (2 lines), save, see error message, fix
        _ ->
            ( i, j )


stepBody : Grow -> Head -> Body -> Body
stepBody grow currHead currBody =
    [ currHead ]
        ++ {- 👉 TODO: New body currently includes currHead position and entire currBody.

               But depending on grow (True vs. False) it also should include either
                   - the entire currBody, or
                   - the currBody except its last element

              💡 HINT: use `if-then-else`
                   - using `grow` and `body` variable, and `removeLast` function
           -}
           (if grow then
                currBody

            else
                removeLast currBody
           )


removeLast : List a -> List a
removeLast list =
    List.take (List.length list - 1) list


stepSnake : Snake -> Direction -> Food -> Snake
stepSnake ( head, body ) dir food =
    ( stepHead head dir
    , stepBody (stepHead head dir == food) head body
    )


initialHead : Head
initialHead =
    ( 5, 0 )


initialBody : Body
initialBody =
    [ ( 4, 0 ), ( 3, 0 ), ( 2, 0 ), ( 2, 1 ) ]


initialSnake =
    ( initialHead, initialBody )
