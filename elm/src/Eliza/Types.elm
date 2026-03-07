module Eliza.Types exposing (Language(..), Message, Sender(..), Rule, Keyword)

{-| Core types for the Eliza chatbot.
-}


{-| Supported languages. Add new constructors here to extend language support.
-}
type Language
    = English
    | German


{-| A chat message with text and sender information.
-}
type alias Message =
    { text : String
    , sender : Sender
    }


{-| Identifies who sent a message.
-}
type Sender
    = User
    | Eliza


{-| A keyword rule used by the Eliza engine.
    - keyword: the trigger word
    - weight: priority of this keyword (higher = more important)
    - decompositions: patterns to match against user input
-}
type alias Keyword =
    { keyword : String
    , weight : Int
    , decompositions : List Rule
    }


{-| A decomposition/reassembly rule.
    - pattern: a list of pattern parts to match (simplified pattern matching)
    - responses: possible reassembly responses
-}
type alias Rule =
    { pattern : List String
    , responses : List String
    }

