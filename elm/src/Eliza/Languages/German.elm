module Eliza.Languages.German exposing (greeting, goodbye, keywords, reflections, defaultResponses, quitWords)

{-| German language data for the Eliza chatbot.
    Based on the classic Weizenbaum ELIZA script, adapted for German.
-}

import Eliza.Types exposing (Keyword, Rule)


greeting : String
greeting =
    "Guten Tag. Ich bin Eliza, Ihre virtuelle Therapeutin. Wie fühlen Sie sich heute?"


goodbye : String
goodbye =
    "Auf Wiedersehen. Danke für das Gespräch. Passen Sie auf sich auf!"


quitWords : List String
quitWords =
    [ "tschüss", "auf wiedersehen", "ende", "quit", "bye" ]


{-| Pronoun reflections for German.
-}
reflections : List ( String, String )
reflections =
    [ ( "ich", "sie" )
    , ( "mein", "ihr" )
    , ( "meine", "ihre" )
    , ( "meinem", "ihrem" )
    , ( "meinen", "ihren" )
    , ( "meiner", "ihrer" )
    , ( "mir", "ihnen" )
    , ( "mich", "sie" )
    , ( "bin", "sind" )
    , ( "sie", "ich" )
    , ( "ihr", "mein" )
    , ( "ihre", "meine" )
    , ( "ihnen", "mir" )
    ]


{-| Default responses when no keyword matches (German).
-}
defaultResponses : List String
defaultResponses =
    [ "Bitte erzählen Sie mir mehr."
    , "Können Sie das näher erläutern?"
    , "Wie fühlen Sie sich dabei?"
    , "Was bedeutet das für Sie?"
    , "Ich verstehe. Bitte fahren Sie fort."
    , "Das ist interessant. Bitte erzählen Sie weiter."
    , "Erzählen Sie mir mehr darüber."
    , "Stört es Sie, darüber zu sprechen?"
    , "Warum glauben Sie, ist das so?"
    , "Lassen Sie uns das weiter erkunden."
    ]


{-| Keywords and their associated decomposition/reassembly rules (German).
-}
keywords : List Keyword
keywords =
    [ { keyword = "hallo"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Hallo! Wie fühlen Sie sich heute?"
                    , "Guten Tag. Was beschäftigt Sie?"
                    , "Hallo. Was fuehrt Sie heute hierher?"
                    ]
              }
            ]
      }
    , { keyword = "guten tag"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Guten Tag! Wie kann ich Ihnen helfen?"
                    , "Guten Tag! Worüber möchten Sie sprechen?"
                    ]
              }
            ]
      }
    , { keyword = "entschuldigung"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie brauchen sich nicht zu entschuldigen."
                    , "Welche Gefühle löst das Entschuldigen bei Ihnen aus?"
                    , "Entschuldigen Sie sich nicht. Erzählen Sie mir mehr."
                    ]
              }
            ]
      }
    , { keyword = "tut mir leid"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie brauchen sich nicht zu entschuldigen."
                    , "Warum entschuldigen Sie sich?"
                    , "Es muss Ihnen nicht leid tun."
                    ]
              }
            ]
      }
    , { keyword = "ich erinnere mich"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich erinnere mich ", "*" ]
              , responses =
                    [ "Warum erinnern Sie sich gerade jetzt an *?"
                    , "Ruft der Gedanke an * andere Erinnerungen hervor?"
                    , "Was an * ist Ihnen wichtig?"
                    ]
              }
            ]
      }
    , { keyword = "wenn"
      , weight = 3
      , decompositions =
            [ { pattern = [ "wenn ", "*" ]
              , responses =
                    [ "Glauben Sie wirklich, dass *?"
                    , "Wünschen Sie sich, dass *?"
                    , "Was denken Sie über *?"
                    , "Was würde es bedeuten, wenn *?"
                    ]
              }
            ]
      }
    , { keyword = "traum"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was sagt Ihnen dieser Traum?"
                    , "Haben Sie öfter solche Träume?"
                    , "Welche Personen kommen in Ihren Träumen vor?"
                    , "Wie hängt dieser Traum mit Ihren Gefühlen zusammen?"
                    ]
              }
            ]
      }
    , { keyword = "geträumt"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was sagt Ihnen dieser Traum?"
                    , "Träumen Sie das öfter?"
                    , "Wie hat Sie dieser Traum fühlen lassen?"
                    ]
              }
            ]
      }
    , { keyword = "vielleicht"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie scheinen sich nicht sehr sicher zu sein."
                    , "Woher kommt die Unsicherheit?"
                    , "Können Sie genauer sein?"
                    , "Sie sind sich nicht sicher?"
                    ]
              }
            ]
      }
    , { keyword = "weil"
      , weight = 3
      , decompositions =
            [ { pattern = [ "weil ", "*" ]
              , responses =
                    [ "Ist das der wahre Grund?"
                    , "Sind Sie sicher, dass das der Grund ist?"
                    , "Welche anderen Gründe fallen Ihnen ein?"
                    , "Erklärt dieser Grund noch etwas anderes?"
                    ]
              }
            ]
      }
    , { keyword = "ich fuehle"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich fuehle ", "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über das Gefühl, * zu sein."
                    , "Fühlen Sie sich oft *?"
                    , "Wann fühlen Sie sich normalerweise *?"
                    , "Wenn Sie sich * fühlen, was tun Sie dann?"
                    ]
              }
            ]
      }
    , { keyword = "ich fuehle mich"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich fuehle mich ", "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über dieses Gefühl."
                    , "Fühlen Sie sich oft *?"
                    , "Was glauben Sie, verursacht dieses Gefühl?"
                    , "Wie gehen Sie damit um, wenn Sie sich * fühlen?"
                    ]
              }
            ]
      }
    , { keyword = "ich will"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich will ", "*" ]
              , responses =
                    [ "Was würde es für Sie bedeuten, * zu bekommen?"
                    , "Warum wollen Sie *?"
                    , "Angenommen, Sie bekämen *. Was dann?"
                    , "Was wäre, wenn Sie * niemals bekämen?"
                    ]
              }
            ]
      }
    , { keyword = "ich moechte"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich moechte ", "*" ]
              , responses =
                    [ "Was würde es für Sie bedeuten, *?"
                    , "Warum möchten Sie *?"
                    , "Was glauben Sie, was passieren würde?"
                    ]
              }
            ]
      }
    , { keyword = "ich brauche"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich brauche ", "*" ]
              , responses =
                    [ "Warum brauchen Sie *?"
                    , "Würde es Ihnen wirklich helfen, * zu haben?"
                    , "Sind Sie sicher, dass Sie * brauchen?"
                    , "Was würde es für Sie bedeuten, * zu haben?"
                    ]
              }
            ]
      }
    , { keyword = "ich bin"
      , weight = 4
      , decompositions =
            [ { pattern = [ "ich bin ", "*" ]
              , responses =
                    [ "Wie lange sind Sie schon *?"
                    , "Glauben Sie, es ist normal, * zu sein?"
                    , "Genießen Sie es, * zu sein?"
                    , "Warum sagen Sie, dass Sie * sind?"
                    ]
              }
            ]
      }
    , { keyword = "ich kann nicht"
      , weight = 4
      , decompositions =
            [ { pattern = [ "ich kann nicht ", "*" ]
              , responses =
                    [ "Woher wissen Sie, dass Sie nicht * können?"
                    , "Haben Sie es versucht?"
                    , "Was bräuchte es, damit Sie * können?"
                    , "Vielleicht könnten Sie *, wenn Sie es versuchten."
                    ]
              }
            ]
      }
    , { keyword = "ich denke"
      , weight = 3
      , decompositions =
            [ { pattern = [ "ich denke ", "*" ]
              , responses =
                    [ "Denken Sie das wirklich?"
                    , "Aber Sie sind sich nicht sicher, dass *?"
                    , "Warum denken Sie *?"
                    , "Was bringt Sie dazu, * zu denken?"
                    ]
              }
            ]
      }
    , { keyword = "ich glaube"
      , weight = 3
      , decompositions =
            [ { pattern = [ "ich glaube ", "*" ]
              , responses =
                    [ "Glauben Sie das wirklich?"
                    , "Sind Sie sich sicher?"
                    , "Was lässt Sie das glauben?"
                    ]
              }
            ]
      }
    , { keyword = "sie sind"
      , weight = 3
      , decompositions =
            [ { pattern = [ "sie sind ", "*" ]
              , responses =
                    [ "Was bringt Sie dazu zu glauben, ich sei *?"
                    , "Warum denken Sie, ich bin *?"
                    , "Wir sprachen über Sie, nicht über mich."
                    ]
              }
            ]
      }
    , { keyword = "ja"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie scheinen sich ziemlich sicher zu sein."
                    , "Verstehe. Können Sie das genauer erklären?"
                    , "Ich verstehe. Erzählen Sie mir mehr."
                    ]
              }
            ]
      }
    , { keyword = "nein"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Warum nicht?"
                    , "Sie sind etwas negativ."
                    , "Sagen Sie nein nur um negativ zu sein?"
                    , "Warum so negativ?"
                    ]
              }
            ]
      }
    , { keyword = "mein"
      , weight = 2
      , decompositions =
            [ { pattern = [ "mein ", "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über Ihren *."
                    , "Warum ist Ihnen Ihr * wichtig?"
                    , "Macht Ihnen Ihr * Sorgen?"
                    ]
              }
            ]
      }
    , { keyword = "meine"
      , weight = 2
      , decompositions =
            [ { pattern = [ "meine ", "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über Ihre *."
                    , "Warum ist Ihnen Ihre * wichtig?"
                    , "Macht Ihnen Ihre * Sorgen?"
                    ]
              }
            ]
      }
    , { keyword = "mutter"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über Ihre Mutter."
                    , "Wie war Ihre Beziehung zu Ihrer Mutter?"
                    , "Wie hängt das mit Ihren heutigen Gefühlen zusammen?"
                    , "Gute Familienbeziehungen sind wichtig. Erzählen Sie mir mehr über Ihre Mutter."
                    ]
              }
            ]
      }
    , { keyword = "vater"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über Ihren Vater."
                    , "Wie hat Ihr Vater Sie fühlen lassen?"
                    , "Wie hängt das mit Ihren heutigen Gefühlen zusammen?"
                    , "Haben Sie Schwierigkeiten, Zuneigung in der Familie zu zeigen?"
                    ]
              }
            ]
      }
    , { keyword = "familie"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über Ihre Familie."
                    , "Wie fühlen Sie sich bei Ihrer Familie?"
                    , "Welche Rolle spielt Ihre Familie in Ihrem Leben?"
                    ]
              }
            ]
      }
    , { keyword = "traurig"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Es tut mir leid zu hören, dass Sie traurig sind. Können Sie mir sagen, was Sie traurig macht?"
                    , "Was glauben Sie, verursacht Ihre Traurigkeit?"
                    , "Wann haben Sie angefangen, sich traurig zu fühlen?"
                    ]
              }
            ]
      }
    , { keyword = "glücklich"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was macht Sie glücklich?"
                    , "Sind Sie wirklich glücklich, oder wuenschen Sie es sich?"
                    , "Wie beeinflusst dieses Glück Ihr Leben?"
                    ]
              }
            ]
      }
    , { keyword = "immer"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Können Sie ein konkretes Beispiel nennen?"
                    , "Wenn Sie 'immer' sagen, meinen Sie das wörtlich?"
                    , "Woran denken Sie wirklich?"
                    ]
              }
            ]
      }
    , { keyword = "alle"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Können Sie an jemand Bestimmtes denken?"
                    , "An wen genau denken Sie?"
                    , "Sicherlich nicht alle."
                    ]
              }
            ]
      }
    , { keyword = "niemand"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sind Sie sicher, dass niemand das tut?"
                    , "Bestimmt jemand..."
                    , "Können Sie an jemanden denken?"
                    ]
              }
            ]
      }
    , { keyword = "computer"
      , weight = 3
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Machen Ihnen Computer Sorgen?"
                    , "Warum erwähnen Sie Computer?"
                    , "Welche Rolle spielen Computer in Ihrem Leben?"
                    , "Glauben Sie nicht, dass Computer Menschen helfen können?"
                    ]
              }
            ]
      }
    , { keyword = "was"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Warum fragen Sie?"
                    , "Interessiert Sie diese Frage?"
                    , "Was möchten Sie wirklich wissen?"
                    , "Was denken Sie selbst?"
                    ]
              }
            ]
      }
    , { keyword = "wie"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Wie meinen Sie?"
                    , "Welche Antwort würde Sie am meisten zufriedenstellen?"
                    , "Was denken Sie?"
                    ]
              }
            ]
      }
    , { keyword = "angst"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Wovor haben Sie Angst?"
                    , "Wie lange haben Sie schon diese Angst?"
                    , "Was glauben Sie, verursacht Ihre Angst?"
                    , "Erzählen Sie mir mehr über Ihre Ängste."
                    ]
              }
            ]
      }
    , { keyword = "sorge"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was bereitet Ihnen Sorgen?"
                    , "Warum machen Sie sich Sorgen?"
                    , "Wie gehen Sie mit Ihren Sorgen um?"
                    ]
              }
            ]
      }
    ]

