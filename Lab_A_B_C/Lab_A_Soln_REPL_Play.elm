module Lab_A_Soln_REPL_Play exposing (..)


type alias HeadPos =
    ( Int, Int )


type alias Direction =
    String


type alias Grow =
    Bool


type alias Body =
    List ( Int, Int )


stepHead : HeadPos -> Direction -> HeadPos
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


stepBody : Grow -> HeadPos -> Body -> Body
stepBody grow head body =
    [ head ]
        ++ [{- 👉 TODO: New body always includes old head position.

                But depending on grow (True vs. False) it also should include either
                    - the entire old body, or
                    - the old body except its last element

               💡 HINT: use `if-then-else`
                    - using `grow` and `body` variable, and `removeLast` function
            -}
           ]


removeLast : List a -> List a
removeLast list =
    List.take (List.length list - 1) list


initialHead =
    ( 5, 0 )


initialBody =
    [ ( 4, 0 ), ( 3, 0 ), ( 2, 0 ), ( 2, 1 ) ]


initialSnake =
    ( initialHead, initialBody )
