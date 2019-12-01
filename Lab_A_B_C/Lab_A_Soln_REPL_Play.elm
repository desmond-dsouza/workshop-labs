module Lab_A_Soln_REPL_Play exposing (..)


isAnagram :
    String
    -> Bool -- 👉 TODO: Change Bool to String, save, see error message, fix
isAnagram s =
    s == String.reverse s


onlyDigits : String -> String
onlyDigits s =
    -- 👉 TODO: Change isDigit to toUpper, save, see error message, fix
    String.filter Char.isDigit s


sameDigits : String -> String -> Bool
sameDigits s1 s2 =
    -- 👉 TODO: Delete s1, save, see error message, fix
    onlyDigits s1 == onlyDigits s2



{- -------------------- -}


type alias Head =
    ( Int, Int )


type alias Direction =
    String


type alias Grow =
    Bool


type alias Body =
    List ( Int, Int )


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

        -- 👉 TODO: Delete last case, save, see error message, fix
        _ ->
            ( i, j )


stepBody : Grow -> Head -> Body -> Body
stepBody grow head body =
    head
        :: (if grow then
                body

            else
                removeLast body
           )


removeLast : List a -> List a
removeLast list =
    List.take (List.length list - 1) list
