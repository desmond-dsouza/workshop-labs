module Main exposing (..)

{- 👉 TODO:
       - Run (elm-live) BugSoln.elm with arrows + space + shift-space
               to understand the goal
   STATIC:
       - Make this file a proper Elm module (module name = file name)
       - Define type Model alias for the bug
       - Define a static model = { ... }
       - Define view as a collage (10x10) + list of shapes using model
            - import needed modules
            - background of `graphPaperCustom 1 0.05 lightGrey`
            - body: green, roundedRect: length = 1, height = 0.5, roundedEdges = 0.2
            - eye: black, circle: radius 0.05, moved +/- 0.35 horizontally, 0.1 vertically
            - test at (0,0); then move to (0, -4)
            - Reset button - purple circle, r=0.5, at (0, 4)
       - Define main as App.graphicsApp
       - Try different model positions & directions, using helpers `step, jump, go dir`

    INTERACTIVE & ANIMATED:
       - Change model to initialModel
       - Change view to a function of model -> collage of shapes
       - Define Msg type as: Tick Float GetKeyState
            - GetKeyState = ((Keys -> KeyState), _, _) (we only need the 1st item in triple)
       - Define update to handle just Left and Right arrow keys
       - Add helpers
            - decodeKeys: (Keys -> KeyState) -> UserRequests
            - Union type UserRequests for 2 possible user requests (and None)
            - step, jump, go Left|Right to change the model
       - Extend update to step and/or jump the bug
       - Extend Msg & update to support Reset
       - Understand how Elm checks for pattern completeness
-}
