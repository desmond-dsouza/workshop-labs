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
            - body: green, roundedRect: length = 1, height = 0.5, roundedEdges = 0.2
            - eye: black, circle: radius 0.05, moved +/- 0.35 horizontally, 0.1 vertically
       - Define main as App.graphicsApp
       - Try different model positions & directions

    INTERACTIVE & ANIMATED:
       - Change model to initialModel
       - Change view to a function of model -> collage of shapes
       - Define Msg type as: Tick Float GetKeyState
            - GetKeyState = (Keys -> KeyState), _, _) (we only need the 1st item in triple)
       - Define update to handle just Left and Right arrow keys
       - Add helpers
            - userRequest: (Keys -> KeyState) to UserRequests
            - step, jump, go Left|Right to change the model
       - Extend update to step and/or jump the bug
       - Understand how Elm checks for pattern completeness
-}
