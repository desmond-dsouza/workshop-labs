module Bug exposing (..)

import GraphicSVG exposing (..)
import Lib.WkApp as App exposing (KeyState(..), Keys(..))



------- MODEL -------


type alias Model =
    { x : Float, y : Float, direction : Direction }


type Direction
    = Left
    | Right


initialModel =
    { x = 0, y = -4, direction = Right }



------- VIEW -------


viewBug ( x, y ) direction =
    let
        body =
            roundedRect 1 0.5 0.2
                |> filled green
                |> move ( x, y )

        eye =
            circle 0.05
                |> filled black
                |> move
                    ( x
                        + (case direction of
                            Right ->
                                0.35

                            Left ->
                                -0.35
                          )
                    , y + 0.1
                    )
    in
    group [ body, eye ]


view model =
    {- 👉 TODO:
       - Fill in `notifyX` for these shapes in stages
       - Get each stage to compile
    -}
    let
        resetButton =
            circle 0.5
                |> filled purple
                |> move ( 0, 4 )

        -- |> notifyTap ResetBtnTap
        jumpButton =
            circle 0.5
                |> filled orange
                |> move ( 2, 4 )

        -- |> notifyTap JumpBtnTap
        tapSurface =
            rect 10 8
                |> filled (rgba 0 0 0 0)
                |> addOutline (dashed 0.05) lightBlue
                |> move ( 0, -1 )

        -- |> notifyTapAt BoardTapAt
        bug =
            viewBug ( model.x, model.y ) model.direction
    in
    collage 10
        10
        [ graphPaperCustom 1 0.05 lightGrey
        , bug
        , resetButton
        , jumpButton
        , tapSurface
        ]



------- INTERACTION -------
{- 💡 HINT:
   - Build up Msg, UserRequest, update, and decode in stages
   - Subscribe to receiving those messages e.g. in `view` or `main`
-}


type
    Msg
    {- 👉 TODO:
       - Tick (with Float for seconds + GetKeyState)
       - Reset button tapped
       - Jump button tapped
       - Board tapped at some (x, y) position
    -}
    = FillMeIn_1



-- = Tick Float App.GetKeyState
-- | ResetBtnTap
-- | JumpBtnTap
-- | BoardTapAt ( Float, Float )


type
    UserRequest
    -- 👉 TODO: Union type for user requests
    = FillMeIn_2



-- = Jump
-- | Go Direction
-- | Reset
-- | None
------- DECODE KEYS, MOUSE -> UserRequest ------


decodeKeys : (Keys -> KeyState) -> UserRequest
decodeKeys keyF =
    -- 👉 TODO: Jump if Space key was pressed
    None



-- if keyF Space == JustDown || keyF Space == Down then
--     Jump
-- else
--     None


decodeTap : ( Float, Float ) -> Model -> UserRequest
decodeTap ( tapX, tapY ) model =
    -- 👉 TODO: Flip direction based on tap vs. bug position
    None



-- case ( model.direction, tapX <= model.x ) of
--     ( Right, True ) ->
--         Go Left
--     ( Left, False ) ->
--         Go Right
--     _ ->
--         None
------- ACTIONS ON MODEL -------


step model =
    case model.direction of
        Left ->
            { model | x = model.x - 0.2 }

        Right ->
            { model | x = model.x + 0.2 }


jump model =
    { model | y = model.y + 0.2 }


go dir model =
    { model | direction = dir }


reset model =
    initialModel



------- UPDATE -------


update msg model =
    -- 👉 TODO: Handle the Msg variants one at a time
    model



-- let
--     { x, y, direction } =
--         model
-- in
-- case msg of
--     Tick seconds ( keyFunction, _, _ ) ->
--         case ( decodeKeys keyFunction, direction ) of
--             ( Jump, _ ) ->
--                 jump model |> step
--             ( _, _ ) ->
--                 model |> step
--     ResetBtnTap ->
--         reset model
--     JumpBtnTap ->
--         jump model |> step
--     BoardTapAt ( tapX, tapY ) ->
--         case ( model.direction, tapX <= model.x ) of
--             ( Right, True ) ->
--                 { model | direction = Left }
--             ( Left, False ) ->
--                 { model | direction = Right }
--             _ ->
--                 model


main =
    App.simpleGameApp
        (App.Every 300)
        Tick
        { title = "Game!"
        , view = view
        , update = update
        , init = initialModel
        }
