module Types exposing (..)


type alias Model =
    {- 👉 TODO: Define this.
        It corresponds to the game-in-progress

       💡 HINT: what information does the `game` remember at any time?
    -}
    ()


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


type alias Grid =
    {- 👉 TODO: Define this type to contain grid information:
       numRows, numColumns, cellSize
    -}
    ()


type alias Walls =
    { left : Int, right : Int, top : Int, bottom : Int }
