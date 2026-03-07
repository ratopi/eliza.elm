module Eliza.Languages.English exposing (greeting, goodbye, keywords, reflections, defaultResponses, quitWords)

{-| English language data for the Eliza chatbot.
    Based on the classic Weizenbaum ELIZA script.
-}

import Eliza.Types exposing (Keyword, Rule)


greeting : String
greeting =
    "Hello. I'm Eliza, your virtual therapist. How are you feeling today?"


goodbye : String
goodbye =
    "Goodbye. Thank you for talking with me. Take care!"


quitWords : List String
quitWords =
    [ "bye", "goodbye", "quit", "exit", "done" ]


{-| Pronoun reflections for English.
-}
reflections : List ( String, String )
reflections =
    [ ( "i", "you" )
    , ( "me", "you" )
    , ( "my", "your" )
    , ( "am", "are" )
    , ( "you", "i" )
    , ( "your", "my" )
    , ( "yours", "mine" )
    , ( "are", "am" )
    , ( "was", "were" )
    , ( "i'd", "you would" )
    , ( "i've", "you have" )
    , ( "i'll", "you will" )
    , ( "myself", "yourself" )
    , ( "yourself", "myself" )
    , ( "we", "you" )
    ]


{-| Default responses when no keyword matches.
-}
defaultResponses : List String
defaultResponses =
    [ "Please tell me more."
    , "Can you elaborate on that?"
    , "How does that make you feel?"
    , "What does that suggest to you?"
    , "I see. Please continue."
    , "That is interesting. Please go on."
    , "Tell me more about that."
    , "Does talking about this bother you?"
    , "Why do you think that is?"
    , "Let's explore that further."
    ]


{-| Keywords and their associated decomposition/reassembly rules.
-}
keywords : List Keyword
keywords =
    [ -- Greetings
      { keyword = "hello"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Hello! How are you feeling today?"
                    , "Hi there. What's on your mind?"
                    , "Hello. What brings you here today?"
                    ]
              }
            ]
      }
    , { keyword = "hi"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Hello! How can I help you today?"
                    , "Hi! What would you like to talk about?"
                    ]
              }
            ]
      }

    -- Sorry
    , { keyword = "sorry"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "There's no need to apologize."
                    , "What feelings does apologizing bring up?"
                    , "Don't be sorry. Tell me more."
                    ]
              }
            ]
      }

    -- I remember
    , { keyword = "i remember"
      , weight = 5
      , decompositions =
            [ { pattern = [ "i remember ", "*" ]
              , responses =
                    [ "Why do you remember * just now?"
                    , "Does thinking about * bring up other memories?"
                    , "What about * is important to you?"
                    , "What else does * remind you of?"
                    ]
              }
            ]
      }

    -- Do you remember
    , { keyword = "do you remember"
      , weight = 5
      , decompositions =
            [ { pattern = [ "do you remember ", "*" ]
              , responses =
                    [ "Did you think I would forget *?"
                    , "What about * makes you ask?"
                    , "Why is * on your mind?"
                    ]
              }
            ]
      }

    -- If
    , { keyword = "if"
      , weight = 3
      , decompositions =
            [ { pattern = [ "if ", "*" ]
              , responses =
                    [ "Do you really think it's likely that *?"
                    , "Do you wish that *?"
                    , "What do you think about *?"
                    , "What would it mean if *?"
                    ]
              }
            ]
      }

    -- I dreamed / I dream
    , { keyword = "dream"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*", " dream ", "*" ]
              , responses =
                    [ "What does that dream suggest to you?"
                    , "Do you often have such dreams?"
                    , "What persons appear in your dreams?"
                    , "How does that dream relate to your feelings?"
                    ]
              }
            ]
      }

    -- Perhaps / Maybe
    , { keyword = "perhaps"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "You don't seem very certain."
                    , "Why the uncertainty?"
                    , "Can you be more specific?"
                    , "You're not sure?"
                    ]
              }
            ]
      }
    , { keyword = "maybe"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "You don't seem very certain."
                    , "Why the uncertainty?"
                    , "Can you be more specific?"
                    ]
              }
            ]
      }

    -- Name
    , { keyword = "name"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Names don't interest me much. Tell me more about your feelings."
                    , "I'm not interested in names. Let's talk about you."
                    ]
              }
            ]
      }

    -- Because
    , { keyword = "because"
      , weight = 3
      , decompositions =
            [ { pattern = [ "because ", "*" ]
              , responses =
                    [ "Is that the real reason?"
                    , "Are you sure that's why?"
                    , "What other reasons come to mind?"
                    , "Does that reason explain anything else?"
                    ]
              }
            ]
      }

    -- I feel
    , { keyword = "i feel"
      , weight = 5
      , decompositions =
            [ { pattern = [ "i feel ", "*" ]
              , responses =
                    [ "Tell me more about feeling *."
                    , "Do you often feel *?"
                    , "When do you usually feel *?"
                    , "When you feel *, what do you do?"
                    ]
              }
            ]
      }

    -- I want
    , { keyword = "i want"
      , weight = 5
      , decompositions =
            [ { pattern = [ "i want ", "*" ]
              , responses =
                    [ "What would it mean to you if you got *?"
                    , "Why do you want *?"
                    , "Suppose you got *. What then?"
                    , "What if you never got *?"
                    ]
              }
            ]
      }

    -- I need
    , { keyword = "i need"
      , weight = 5
      , decompositions =
            [ { pattern = [ "i need ", "*" ]
              , responses =
                    [ "Why do you need *?"
                    , "Would it really help you to get *?"
                    , "Are you sure you need *?"
                    , "What would having * mean to you?"
                    ]
              }
            ]
      }

    -- I am / I'm
    , { keyword = "i am"
      , weight = 4
      , decompositions =
            [ { pattern = [ "i am ", "*" ]
              , responses =
                    [ "How long have you been *?"
                    , "Do you believe it is normal to be *?"
                    , "Do you enjoy being *?"
                    , "Why do you say you are *?"
                    ]
              }
            ]
      }
    , { keyword = "im"
      , weight = 4
      , decompositions =
            [ { pattern = [ "im ", "*" ]
              , responses =
                    [ "How does being * make you feel?"
                    , "Do you enjoy being *?"
                    , "Why do you tell me you're *?"
                    , "How long have you been *?"
                    ]
              }
            ]
      }

    -- I can't
    , { keyword = "i cant"
      , weight = 4
      , decompositions =
            [ { pattern = [ "i cant ", "*" ]
              , responses =
                    [ "How do you know you can't *?"
                    , "Have you tried?"
                    , "What would it take for you to *?"
                    , "Perhaps you could * if you tried."
                    ]
              }
            ]
      }

    -- I think
    , { keyword = "i think"
      , weight = 3
      , decompositions =
            [ { pattern = [ "i think ", "*" ]
              , responses =
                    [ "Do you really think so?"
                    , "But you're not sure *?"
                    , "Why do you think *?"
                    , "What makes you think *?"
                    ]
              }
            ]
      }

    -- You are / You're
    , { keyword = "you are"
      , weight = 3
      , decompositions =
            [ { pattern = [ "you are ", "*" ]
              , responses =
                    [ "What makes you think I am *?"
                    , "Why do you think I'm *?"
                    , "Does it please you to think I am *?"
                    , "We were discussing you, not me."
                    ]
              }
            ]
      }

    -- Yes
    , { keyword = "yes"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "You seem quite sure."
                    , "I see. Can you elaborate?"
                    , "I understand. Tell me more."
                    ]
              }
            ]
      }

    -- No
    , { keyword = "no"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Why not?"
                    , "You are being a bit negative."
                    , "Are you saying no just to be negative?"
                    , "Why are you so negative?"
                    ]
              }
            ]
      }

    -- My
    , { keyword = "my"
      , weight = 2
      , decompositions =
            [ { pattern = [ "my ", "*" ]
              , responses =
                    [ "Tell me more about your *."
                    , "Why is your * important to you?"
                    , "Does your * concern you?"
                    , "Is that important to you — your *?"
                    ]
              }
            ]
      }

    -- Mother / Father / Family
    , { keyword = "mother"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Tell me more about your mother."
                    , "What was your relationship with your mother like?"
                    , "How does that relate to your feelings today?"
                    , "Good family relations are important. Tell me more about your mother."
                    ]
              }
            ]
      }
    , { keyword = "father"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Tell me more about your father."
                    , "How did your father make you feel?"
                    , "How does that relate to your feelings today?"
                    , "Do you have trouble showing affection with your family?"
                    ]
              }
            ]
      }
    , { keyword = "family"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Tell me more about your family."
                    , "How does your family make you feel?"
                    , "What role does your family play in your life?"
                    ]
              }
            ]
      }

    -- Sad / Unhappy / Depressed
    , { keyword = "sad"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "I'm sorry to hear that you're sad. Can you tell me what's making you feel this way?"
                    , "What do you think is causing your sadness?"
                    , "When did you first start feeling sad?"
                    ]
              }
            ]
      }
    , { keyword = "unhappy"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "What's making you unhappy?"
                    , "Can you tell me more about why you're unhappy?"
                    , "How long have you been feeling unhappy?"
                    ]
              }
            ]
      }
    , { keyword = "depressed"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "I'm sorry to hear you're feeling depressed. Tell me more about it."
                    , "When did these feelings of depression start?"
                    , "What do you think is behind your depression?"
                    ]
              }
            ]
      }

    -- Happy / Glad
    , { keyword = "happy"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "What makes you feel happy?"
                    , "Are you really happy, or do you wish you were?"
                    , "How does that happiness affect your life?"
                    ]
              }
            ]
      }

    -- Always
    , { keyword = "always"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Can you think of a specific example?"
                    , "When you say 'always', do you mean literally always?"
                    , "What is it that you're really thinking of?"
                    ]
              }
            ]
      }

    -- Everyone / Everybody / Nobody
    , { keyword = "everyone"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Can you think of anyone in particular?"
                    , "Who specifically are you thinking of?"
                    , "Surely not everyone."
                    , "Is that how you really feel?"
                    ]
              }
            ]
      }
    , { keyword = "nobody"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Are you sure nobody does?"
                    , "Surely someone..."
                    , "Can you think of anyone?"
                    ]
              }
            ]
      }

    -- Computer
    , { keyword = "computer"
      , weight = 3
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Do computers worry you?"
                    , "Why do you mention computers?"
                    , "What role do computers play in your life?"
                    , "Don't you think computers can help people?"
                    ]
              }
            ]
      }

    -- Am I
    , { keyword = "am i"
      , weight = 3
      , decompositions =
            [ { pattern = [ "am i ", "*" ]
              , responses =
                    [ "Do you believe you are *?"
                    , "Would you want to be *?"
                    , "Do you wish I would tell you you are *?"
                    , "What would it mean if you were *?"
                    ]
              }
            ]
      }

    -- Can you
    , { keyword = "can you"
      , weight = 3
      , decompositions =
            [ { pattern = [ "can you ", "*" ]
              , responses =
                    [ "What makes you think I can *?"
                    , "Do you want me to *?"
                    , "Perhaps you'd like to be able to * yourself."
                    ]
              }
            ]
      }

    -- What
    , { keyword = "what"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Why do you ask?"
                    , "Does that question interest you?"
                    , "What is it you really want to know?"
                    , "What do you think?"
                    ]
              }
            ]
      }

    -- How
    , { keyword = "how"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "How do you suppose?"
                    , "What answer would please you most?"
                    , "What do you think?"
                    ]
              }
            ]
      }
    ]

