module Types exposing (..)


type alias Model =
    { snake : Snake
    , food : Food
    }


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
    { numRows : Int, numColumns : Int, cellSize : Float }


type alias Walls =
    { left : Int, right : Int, top : Int, bottom : Int }
