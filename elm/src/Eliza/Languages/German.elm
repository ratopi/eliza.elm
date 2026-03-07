module Eliza.Languages.German exposing (greeting, goodbye, keywords, reflections, defaultResponses, shortInputResponses, quitWords)

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
    , "Was geht Ihnen dabei durch den Kopf?"
    , "Wie lange beschäftigt Sie das schon?"
    , "Beschäftigt Sie das häufig?"
    , "Was schließen Sie daraus?"
    , "Und wie hängt das mit Ihrem aktuellen Befinden zusammen?"
    ]


{-| Responses for very short or meaningless input.
-}
shortInputResponses : List String
shortInputResponses =
    [ "Könnten Sie etwas mehr dazu sagen? Ich möchte Sie verstehen."
    , "Ich höre Ihnen zu. Bitte erzählen Sie mir, was Sie beschäftigt."
    , "Können Sie das etwas genauer ausdrücken?"
    , "Nur zu, ich bin ganz Ohr."
    , "Bitte scheuen Sie sich nicht. Was denken Sie gerade?"
    , "Ich bräuchte etwas mehr Information. Was fühlen Sie?"
    , "Nehmen Sie sich Zeit. Worüber möchten Sie sprechen?"
    , "Ich bin mir nicht sicher, ob ich Sie verstehe. Können Sie das erläutern?"
    ]


{-| Keywords and their associated decomposition/reassembly rules (German).
-}
keywords : List Keyword
keywords =
    [ -- Greetings
      { keyword = "hallo"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Hallo! Wie fühlen Sie sich heute?"
                    , "Guten Tag. Was beschäftigt Sie?"
                    , "Hallo. Was führt Sie heute hierher?"
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

    -- Apologies
    , { keyword = "entschuldigung"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie brauchen sich nicht zu entschuldigen."
                    , "Welche Gefühle löst das Entschuldigen bei Ihnen aus?"
                    , "Entschuldigen Sie sich nicht. Erzählen Sie mir mehr."
                    , "Entschuldigen Sie sich oft? Warum, glauben Sie?"
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
                    , "Haben Sie das Gefühl, sich rechtfertigen zu müssen?"
                    ]
              }
            ]
      }

    -- Memory
    , { keyword = "ich erinnere mich"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich erinnere mich ", "*" ]
              , responses =
                    [ "Warum erinnern Sie sich gerade jetzt an *?"
                    , "Ruft der Gedanke an * andere Erinnerungen hervor?"
                    , "Was an * ist Ihnen wichtig?"
                    , "Wie fühlen Sie sich, wenn Sie an * denken?"
                    ]
              }
            ]
      }

    -- Conditionals
    , { keyword = "wenn"
      , weight = 3
      , decompositions =
            [ { pattern = [ "wenn ", "*" ]
              , responses =
                    [ "Glauben Sie wirklich, dass *?"
                    , "Wünschen Sie sich, dass *?"
                    , "Was denken Sie über *?"
                    , "Was würde es bedeuten, wenn *?"
                    , "Wie wahrscheinlich ist es Ihrer Meinung nach, dass *?"
                    ]
              }
            ]
      }

    -- Dreams
    , { keyword = "traum"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was sagt Ihnen dieser Traum?"
                    , "Haben Sie öfter solche Träume?"
                    , "Welche Personen kommen in Ihren Träumen vor?"
                    , "Wie hängt dieser Traum mit Ihren Gefühlen zusammen?"
                    , "Träume können viel über unser Innenleben verraten. Was glauben Sie?"
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
                    , "Was glauben Sie, hat den Traum ausgelöst?"
                    ]
              }
            ]
      }

    -- Uncertainty
    , { keyword = "vielleicht"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie scheinen sich nicht sehr sicher zu sein."
                    , "Woher kommt die Unsicherheit?"
                    , "Können Sie genauer sein?"
                    , "Sie sind sich nicht sicher?"
                    , "Was hindert Sie daran, sich sicher zu sein?"
                    ]
              }
            ]
      }

    -- Reasons
    , { keyword = "weil"
      , weight = 3
      , decompositions =
            [ { pattern = [ "weil ", "*" ]
              , responses =
                    [ "Ist das der wahre Grund?"
                    , "Sind Sie sicher, dass das der Grund ist?"
                    , "Welche anderen Gründe fallen Ihnen ein?"
                    , "Erklärt dieser Grund noch etwas anderes?"
                    , "Und wenn das nicht der einzige Grund wäre?"
                    ]
              }
            ]
      }

    -- Feelings (with correct umlauts)
    , { keyword = "ich fühle mich"
      , weight = 6
      , decompositions =
            [ { pattern = [ "ich fühle mich ", "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über dieses Gefühl."
                    , "Fühlen Sie sich oft *?"
                    , "Was glauben Sie, verursacht dieses Gefühl?"
                    , "Wie gehen Sie damit um, wenn Sie sich * fühlen?"
                    , "Seit wann fühlen Sie sich *?"
                    , "Was müsste passieren, damit Sie sich nicht mehr * fühlen?"
                    ]
              }
            ]
      }
    , { keyword = "ich fühle"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich fühle ", "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über das Gefühl, * zu sein."
                    , "Fühlen Sie sich oft *?"
                    , "Wann fühlen Sie sich normalerweise *?"
                    , "Wenn Sie sich * fühlen, was tun Sie dann?"
                    , "Was löst dieses Gefühl bei Ihnen aus?"
                    ]
              }
            ]
      }

    -- Wants
    , { keyword = "ich will"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich will ", "*" ]
              , responses =
                    [ "Was würde es für Sie bedeuten, * zu bekommen?"
                    , "Warum wollen Sie *?"
                    , "Angenommen, Sie bekämen *. Was dann?"
                    , "Was wäre, wenn Sie * niemals bekämen?"
                    , "Wie stark ist dieses Verlangen nach *?"
                    ]
              }
            ]
      }
    , { keyword = "ich möchte"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich möchte ", "*" ]
              , responses =
                    [ "Was würde es für Sie bedeuten, *?"
                    , "Warum möchten Sie *?"
                    , "Was glauben Sie, was passieren würde?"
                    , "Was hält Sie davon ab, *?"
                    ]
              }
            ]
      }

    -- Needs
    , { keyword = "ich brauche"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich brauche ", "*" ]
              , responses =
                    [ "Warum brauchen Sie *?"
                    , "Würde es Ihnen wirklich helfen, * zu haben?"
                    , "Sind Sie sicher, dass Sie * brauchen?"
                    , "Was würde es für Sie bedeuten, * zu haben?"
                    , "Was passiert, wenn Sie * nicht bekommen?"
                    ]
              }
            ]
      }

    -- Identity
    , { keyword = "ich bin"
      , weight = 4
      , decompositions =
            [ { pattern = [ "ich bin ", "*" ]
              , responses =
                    [ "Wie lange sind Sie schon *?"
                    , "Glauben Sie, es ist normal, * zu sein?"
                    , "Genießen Sie es, * zu sein?"
                    , "Warum sagen Sie, dass Sie * sind?"
                    , "Was bedeutet es für Sie, * zu sein?"
                    , "Waren Sie schon immer *?"
                    ]
              }
            ]
      }

    -- Inability
    , { keyword = "ich kann nicht"
      , weight = 4
      , decompositions =
            [ { pattern = [ "ich kann nicht ", "*" ]
              , responses =
                    [ "Woher wissen Sie, dass Sie nicht * können?"
                    , "Haben Sie es versucht?"
                    , "Was bräuchte es, damit Sie * können?"
                    , "Vielleicht könnten Sie *, wenn Sie es versuchten."
                    , "Was genau hindert Sie daran, * zu können?"
                    ]
              }
            ]
      }

    -- Knowledge
    , { keyword = "ich weiß nicht"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was glauben Sie denn?"
                    , "Raten Sie einfach mal. Was kommt Ihnen in den Sinn?"
                    , "Ist es wirklich so, dass Sie es nicht wissen, oder möchten Sie nicht darüber nachdenken?"
                    , "Versuchen Sie es. Was ist Ihr erster Gedanke?"
                    , "Manchmal wissen wir mehr, als wir glauben. Was vermuten Sie?"
                    ]
              }
            ]
      }

    -- Thinking
    , { keyword = "ich denke"
      , weight = 3
      , decompositions =
            [ { pattern = [ "ich denke ", "*" ]
              , responses =
                    [ "Denken Sie das wirklich?"
                    , "Aber Sie sind sich nicht sicher, dass *?"
                    , "Warum denken Sie *?"
                    , "Was bringt Sie dazu, * zu denken?"
                    , "Haben Sie schon lange so gedacht?"
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
                    , "Worauf stützt sich dieser Glaube?"
                    ]
              }
            ]
      }

    -- About Eliza
    , { keyword = "sie sind"
      , weight = 3
      , decompositions =
            [ { pattern = [ "sie sind ", "*" ]
              , responses =
                    [ "Was bringt Sie dazu zu glauben, ich sei *?"
                    , "Warum denken Sie, ich bin *?"
                    , "Wir sprachen über Sie, nicht über mich."
                    , "Interessant, dass Sie über mich sprechen. Was sagt das über Sie?"
                    ]
              }
            ]
      }
    , { keyword = "du bist"
      , weight = 3
      , decompositions =
            [ { pattern = [ "du bist ", "*" ]
              , responses =
                    [ "Warum sagen Sie, ich sei *?"
                    , "Wir sprechen hier über Sie, nicht über mich."
                    , "Was bringt Sie zu dieser Einschätzung?"
                    ]
              }
            ]
      }

    -- Negation/deflection
    , { keyword = "geht dich nichts an"
      , weight = 7
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Ich merke, dass Sie das nicht teilen möchten. Das ist in Ordnung."
                    , "Sie scheinen verärgert zu sein. Können wir darüber sprechen?"
                    , "Es ist Ihr gutes Recht, nicht zu antworten. Was möchten Sie stattdessen besprechen?"
                    ]
              }
            ]
      }
    , { keyword = "keine ahnung"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Versuchen Sie einfach, das Erste zu sagen, was Ihnen einfällt."
                    , "Manchmal wissen wir mehr, als wir glauben. Was vermuten Sie?"
                    , "Ist es wirklich Unwissenheit, oder möchten Sie nicht darüber nachdenken?"
                    , "Nehmen Sie sich einen Moment. Was kommt Ihnen spontan in den Sinn?"
                    ]
              }
            ]
      }
    , { keyword = "sag mir"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Ich bin hier, um Ihnen zuzuhören, nicht um Ihnen Antworten zu geben. Was denken Sie selbst?"
                    , "Es geht hier um Ihre Gedanken und Gefühle. Was empfinden Sie?"
                    , "Was glauben Sie denn, was die Antwort sein könnte?"
                    , "Ich möchte lieber hören, was Sie denken."
                    ]
              }
            ]
      }

    -- Yes/No
    , { keyword = "ja"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie scheinen sich ziemlich sicher zu sein."
                    , "Verstehe. Können Sie das genauer erklären?"
                    , "Ich verstehe. Erzählen Sie mir mehr."
                    , "Und warum ist das so?"
                    , "In Ordnung. Und was fühlen Sie dabei?"
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
                    , "Können Sie mir erklären, warum nicht?"
                    , "Was wäre, wenn die Antwort ja wäre?"
                    , "Ist es ein klares Nein, oder sind Sie sich unsicher?"
                    ]
              }
            ]
      }

    -- Possessives
    , { keyword = "mein"
      , weight = 2
      , decompositions =
            [ { pattern = [ "mein ", "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über Ihren *."
                    , "Warum ist Ihnen Ihr * wichtig?"
                    , "Macht Ihnen Ihr * Sorgen?"
                    , "Wie beeinflusst Ihr * Ihr Leben?"
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
                    , "Welche Rolle spielt Ihre * in Ihrem Leben?"
                    ]
              }
            ]
      }

    -- Family (lower weight - only triggers when the word is actually used)
    , { keyword = "mutter"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über Ihre Mutter."
                    , "Wie war Ihre Beziehung zu Ihrer Mutter?"
                    , "Was für ein Mensch ist Ihre Mutter?"
                    , "Wie hat Ihre Mutter Sie geprägt?"
                    , "Welche Gefühle verbinden Sie mit Ihrer Mutter?"
                    , "Wie würde Ihre Mutter diese Situation sehen?"
                    ]
              }
            ]
      }
    , { keyword = "vater"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über Ihren Vater."
                    , "Wie hat Ihr Vater Sie fühlen lassen?"
                    , "Was für eine Beziehung haben Sie zu Ihrem Vater?"
                    , "Wie hat Ihr Vater Sie geprägt?"
                    , "Welche Gefühle verbinden Sie mit Ihrem Vater?"
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
                    , "Wie würden Sie Ihre Familienbeziehungen beschreiben?"
                    ]
              }
            ]
      }

    -- Emotions
    , { keyword = "traurig"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Es tut mir leid zu hören, dass Sie traurig sind. Können Sie mir sagen, was Sie traurig macht?"
                    , "Was glauben Sie, verursacht Ihre Traurigkeit?"
                    , "Wann haben Sie angefangen, sich traurig zu fühlen?"
                    , "Was hilft Ihnen normalerweise, wenn Sie traurig sind?"
                    , "Wie äußert sich die Traurigkeit bei Ihnen?"
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
                    , "Sind Sie wirklich glücklich, oder wünschen Sie es sich?"
                    , "Wie beeinflusst dieses Glück Ihr Leben?"
                    , "Was trägt am meisten zu Ihrem Glück bei?"
                    ]
              }
            ]
      }
    , { keyword = "wütend"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was macht Sie wütend?"
                    , "Wie gehen Sie normalerweise mit Ihrer Wut um?"
                    , "Wie äußert sich Ihre Wut?"
                    , "Erzählen Sie mir mehr über Ihre Wut."
                    ]
              }
            ]
      }
    , { keyword = "einsam"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Fühlen Sie sich oft einsam?"
                    , "Was glauben Sie, verursacht Ihre Einsamkeit?"
                    , "Was würde Ihnen helfen, sich weniger einsam zu fühlen?"
                    , "Seit wann fühlen Sie sich einsam?"
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
                    , "Wie wirkt sich die Angst auf Ihren Alltag aus?"
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
                    , "Wie lange begleiten Sie diese Sorgen schon?"
                    ]
              }
            ]
      }

    -- Absolutisms
    , { keyword = "immer"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Können Sie ein konkretes Beispiel nennen?"
                    , "Wenn Sie 'immer' sagen, meinen Sie das wörtlich?"
                    , "Woran denken Sie wirklich?"
                    , "Ist es wirklich immer so, oder kommt es Ihnen so vor?"
                    ]
              }
            ]
      }
    , { keyword = "nie"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Nie? Wirklich nie?"
                    , "Können Sie sich an eine Ausnahme erinnern?"
                    , "Was müsste passieren, damit es sich ändert?"
                    , "Das klingt sehr absolut. Erzählen Sie mir mehr."
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
                    , "Wer ist Ihnen dabei besonders aufgefallen?"
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
                    , "Das klingt einsam. Wie fühlen Sie sich dabei?"
                    ]
              }
            ]
      }

    -- Technology
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

    -- Questions from user
    , { keyword = "warum"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was meinen Sie, warum?"
                    , "Welche Antwort würde Ihnen am meisten helfen?"
                    , "Ist die Frage nach dem Warum wichtig für Sie?"
                    , "Was glauben Sie selbst, warum das so ist?"
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
                    , "Versuchen Sie, die Frage selbst zu beantworten. Was kommt Ihnen in den Sinn?"
                    ]
              }
            ]
      }

    -- Work/Life
    , { keyword = "arbeit"
      , weight = 3
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über Ihre Arbeit."
                    , "Wie fühlen Sie sich bei der Arbeit?"
                    , "Wie beeinflusst Ihre Arbeit Ihr Wohlbefinden?"
                    , "Was an Ihrer Arbeit beschäftigt Sie am meisten?"
                    ]
              }
            ]
      }
    , { keyword = "freund"
      , weight = 3
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über diese Freundschaft."
                    , "Wie wichtig sind Ihnen Ihre Freunde?"
                    , "Wie fühlen Sie sich in dieser Beziehung?"
                    , "Was schätzen Sie an dieser Freundschaft?"
                    ]
              }
            ]
      }
    , { keyword = "liebe"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über die Liebe in Ihrem Leben."
                    , "Wie wichtig ist Ihnen Liebe?"
                    , "Was bedeutet Liebe für Sie?"
                    , "Wie beeinflusst Liebe Ihr Wohlbefinden?"
                    ]
              }
            ]
      }
    , { keyword = "allein"
      , weight = 3
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Fühlen Sie sich oft allein?"
                    , "Ist das Alleinsein für Sie belastend oder auch manchmal befreiend?"
                    , "Was tun Sie, wenn Sie sich allein fühlen?"
                    , "Erzählen Sie mir mehr darüber, wie das Alleinsein Sie beeinflusst."
                    ]
              }
            ]
      }
    ]

