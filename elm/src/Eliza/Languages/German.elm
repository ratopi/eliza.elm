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
    [ -- === Deflection / Pushback (very high weight - user is resisting) ===
      { keyword = "geht dich nichts an"
      , weight = 9
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Ich merke, dass Sie das nicht teilen möchten. Das ist in Ordnung. Worüber möchten Sie stattdessen sprechen?"
                    , "Sie scheinen verärgert zu sein. Was hat dieses Gefühl ausgelöst?"
                    , "Es ist Ihr gutes Recht, nicht zu antworten. Was beschäftigt Sie sonst?"
                    ]
              }
            ]
      }
    , { keyword = "geht sie nichts an"
      , weight = 9
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Ich verstehe, dass Sie das für sich behalten möchten. Was können Sie mir stattdessen erzählen?"
                    , "Sie möchten darüber nicht sprechen. Was würden Sie lieber besprechen?"
                    ]
              }
            ]
      }

    -- === Strong emotions (high weight) ===
    , { keyword = "ich hasse"
      , weight = 8
      , decompositions =
            [ { pattern = [ "ich hasse ", "*" ]
              , responses =
                    [ "Das ist ein sehr starkes Gefühl. Was genau an * löst so viel Abneigung aus?"
                    , "Hass ist ein intensives Gefühl. Seit wann empfinden Sie so gegenüber *?"
                    , "Was müsste sich ändern, damit Sie nicht mehr so über * empfinden?"
                    , "Erzählen Sie mir mehr darüber, warum Sie * so stark ablehnen."
                    , "Wie äußert sich dieser Hass in Ihrem Alltag?"
                    ]
              }
            ]
      }
    , { keyword = "hass"
      , weight = 7
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Hass ist ein sehr starkes Gefühl. Gegen wen oder was richtet er sich?"
                    , "Erzählen Sie mir mehr über diesen Hass. Woher kommt er?"
                    , "Wie lange tragen Sie dieses Gefühl schon mit sich?"
                    , "Was hat diesen Hass ausgelöst?"
                    ]
              }
            ]
      }

    -- === Feeling states (high weight) ===
    , { keyword = "ich fühle mich"
      , weight = 7
      , decompositions =
            [ { pattern = [ "ich fühle mich ", "*" ]
              , responses =
                    [ "Sie fühlen sich *. Können Sie mir beschreiben, wie sich das anfühlt?"
                    , "Seit wann fühlen Sie sich *?"
                    , "Was glauben Sie, hat dazu geführt, dass Sie sich * fühlen?"
                    , "Wie gehen Sie damit um, wenn Sie sich * fühlen?"
                    , "Fühlen Sie sich häufig *?"
                    , "Was müsste passieren, damit Sie sich nicht mehr * fühlen?"
                    ]
              }
            ]
      }
    , { keyword = "ich fühle"
      , weight = 6
      , decompositions =
            [ { pattern = [ "ich fühle ", "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über das Gefühl, *."
                    , "Wann haben Sie angefangen, * zu fühlen?"
                    , "Was löst dieses Gefühl bei Ihnen aus?"
                    , "Fühlen Sie das oft?"
                    ]
              }
            ]
      }

    -- === Bad feeling / general malaise ===
    , { keyword = "schlecht"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Es tut mir leid zu hören, dass es Ihnen schlecht geht. Was belastet Sie am meisten?"
                    , "Können Sie genauer beschreiben, was Sie mit 'schlecht' meinen?"
                    , "Seit wann geht es Ihnen schlecht?"
                    , "Was glauben Sie, könnte Ihnen helfen, sich besser zu fühlen?"
                    , "Was war der Auslöser dafür, dass es Ihnen schlecht geht?"
                    ]
              }
            ]
      }
    , { keyword = "nicht gut"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was genau meinen Sie damit, dass es Ihnen nicht gut geht?"
                    , "Seit wann geht es Ihnen nicht gut?"
                    , "Können Sie mir mehr darüber erzählen?"
                    , "Was müsste sich ändern, damit es Ihnen besser geht?"
                    ]
              }
            ]
      }
    , { keyword = "mir geht es"
      , weight = 6
      , decompositions =
            [ { pattern = [ "mir geht es ", "*" ]
              , responses =
                    [ "Sie sagen, es geht Ihnen *. Können Sie das näher beschreiben?"
                    , "Seit wann geht es Ihnen *?"
                    , "Was glauben Sie, ist der Grund, dass es Ihnen * geht?"
                    , "Was müsste passieren, damit es Ihnen besser geht?"
                    ]
              }
            ]
      }

    -- === Confrontation with Eliza ===
    , { keyword = "programm"
      , weight = 7
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Stört es Sie, mit einem Programm zu sprechen?"
                    , "Glauben Sie, ein Mensch könnte Ihnen besser helfen?"
                    , "Was genau stört Sie an dieser Unterhaltung?"
                    , "Auch wenn ich ein Programm bin — was Sie fühlen, ist real. Erzählen Sie mir davon."
                    ]
              }
            ]
      }
    , { keyword = "therapeut"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was erwarten Sie von einem Therapeuten?"
                    , "Haben Sie schon einmal mit einem Therapeuten gesprochen?"
                    , "Was erhoffen Sie sich von diesem Gespräch?"
                    , "Meine Aufgabe ist es, Ihnen zuzuhören. Was beschäftigt Sie?"
                    ]
              }
            ]
      }

    -- === Knowledge / Uncertainty ===
    , { keyword = "ich weiß nicht"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Das ist in Ordnung. Versuchen Sie einfach zu beschreiben, was Sie gerade fühlen."
                    , "Manchmal wissen wir mehr, als wir glauben. Was kommt Ihnen spontan in den Sinn?"
                    , "Wenn Sie raten müssten, was würden Sie sagen?"
                    , "Lassen Sie uns gemeinsam herausfinden, was Sie beschäftigt. Was fällt Ihnen als Erstes ein?"
                    , "Es muss nicht perfekt formuliert sein. Sagen Sie einfach, was Ihnen durch den Kopf geht."
                    ]
              }
            ]
      }
    , { keyword = "keine ahnung"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Versuchen Sie einfach, das Erste zu sagen, was Ihnen einfällt."
                    , "Manchmal hilft es, einfach laut zu denken. Was kommt Ihnen in den Sinn?"
                    , "Nehmen Sie sich einen Moment. Was fühlen Sie gerade in diesem Augenblick?"
                    , "Das ist völlig in Ordnung. Worüber möchten Sie stattdessen sprechen?"
                    ]
              }
            ]
      }

    -- === Requests to Eliza ===
    , { keyword = "sag mir"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Ich bin hier, um Ihnen zuzuhören, nicht um Ihnen Antworten zu geben. Was denken Sie selbst?"
                    , "Es geht hier um Ihre Gedanken und Gefühle. Was empfinden Sie?"
                    , "Was glauben Sie denn, was die Antwort sein könnte?"
                    , "Ich möchte lieber hören, was Sie denken. Was kommt Ihnen in den Sinn?"
                    ]
              }
            ]
      }
    , { keyword = "sagen sie mir"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Mein Ziel ist es, Ihnen beim Nachdenken zu helfen. Was glauben Sie?"
                    , "Was wäre die Antwort, wenn Sie sie selbst geben müssten?"
                    , "Ich helfe Ihnen gerne, selbst darauf zu kommen. Was ist Ihr erster Gedanke?"
                    ]
              }
            ]
      }

    -- === Contradiction / Short pushback ===
    , { keyword = "stimmt nicht"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was stimmt Ihrer Meinung nach nicht?"
                    , "Wie sehen Sie es denn?"
                    , "Erzählen Sie mir Ihre Sicht der Dinge."
                    , "Interessant. Warum sehen Sie das anders?"
                    ]
              }
            ]
      }
    , { keyword = "ist es aber"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie klingen sehr überzeugt. Warum ist Ihnen das so wichtig?"
                    , "Ich höre, dass Sie sich da sicher sind. Können Sie mir mehr dazu sagen?"
                    , "Was macht Sie so sicher?"
                    , "Lassen Sie uns das genauer betrachten. Was genau meinen Sie?"
                    ]
              }
            ]
      }
    , { keyword = "doch"
      , weight = 3
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie widersprechen. Was genau sehen Sie anders?"
                    , "Erzählen Sie mir mehr darüber, warum Sie anderer Meinung sind."
                    , "Was ist Ihre Sichtweise?"
                    , "Ich höre, dass Sie nicht einverstanden sind. Helfen Sie mir, Sie zu verstehen."
                    ]
              }
            ]
      }

    -- === Greetings ===
    , { keyword = "hallo"
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

    -- === Apologies ===
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

    -- === Memory ===
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

    -- === Conditionals ===
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

    -- === Dreams ===
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

    -- === Uncertainty ===
    , { keyword = "vielleicht"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie scheinen sich nicht sehr sicher zu sein."
                    , "Woher kommt die Unsicherheit?"
                    , "Können Sie genauer sein?"
                    , "Was hindert Sie daran, sich sicher zu sein?"
                    ]
              }
            ]
      }

    -- === Reasons ===
    , { keyword = "weil"
      , weight = 4
      , decompositions =
            [ { pattern = [ "weil ", "*" ]
              , responses =
                    [ "Ist das der wahre Grund?"
                    , "Sind Sie sicher, dass das der Grund ist?"
                    , "Welche anderen Gründe könnten eine Rolle spielen?"
                    , "Was wäre, wenn es noch einen tieferen Grund gäbe?"
                    , "Und wenn das nicht der einzige Grund wäre?"
                    ]
              }
            ]
      }

    -- === Wants ===
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
                    , "Was hält Sie davon ab?"
                    ]
              }
            ]
      }

    -- === Needs ===
    , { keyword = "ich brauche"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich brauche ", "*" ]
              , responses =
                    [ "Warum brauchen Sie *?"
                    , "Würde es Ihnen wirklich helfen, * zu haben?"
                    , "Sind Sie sicher, dass Sie * brauchen?"
                    , "Was passiert, wenn Sie * nicht bekommen?"
                    ]
              }
            ]
      }

    -- === Identity ===
    , { keyword = "ich bin"
      , weight = 4
      , decompositions =
            [ { pattern = [ "ich bin ", "*" ]
              , responses =
                    [ "Wie lange sind Sie schon *?"
                    , "Warum sagen Sie, dass Sie * sind?"
                    , "Was bedeutet es für Sie, * zu sein?"
                    , "Waren Sie schon immer *?"
                    , "Wie fühlt es sich an, * zu sein?"
                    ]
              }
            ]
      }

    -- === Inability ===
    , { keyword = "ich kann nicht"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich kann nicht ", "*" ]
              , responses =
                    [ "Woher wissen Sie, dass Sie nicht * können?"
                    , "Haben Sie es schon einmal versucht?"
                    , "Was bräuchte es, damit Sie * könnten?"
                    , "Was genau hindert Sie daran?"
                    , "Vielleicht könnten Sie *, wenn Sie es anders angehen?"
                    ]
              }
            ]
      }

    -- === Thinking ===
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

    -- === About Eliza ===
    , { keyword = "sie sind"
      , weight = 4
      , decompositions =
            [ { pattern = [ "sie sind ", "*" ]
              , responses =
                    [ "Wir sprachen über Sie, nicht über mich. Was beschäftigt Sie?"
                    , "Interessant, dass Sie über mich sprechen. Was sagt das über Sie?"
                    , "Warum ist es Ihnen wichtig, wie ich bin? Was fühlen Sie gerade?"
                    , "Lassen Sie uns den Fokus auf Sie richten. Was geht Ihnen durch den Kopf?"
                    ]
              }
            ]
      }
    , { keyword = "du bist"
      , weight = 4
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

    -- === Yes/No ===
    , { keyword = "ja"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie scheinen sich ziemlich sicher zu sein. Erzählen Sie mir mehr."
                    , "Können Sie das genauer erklären?"
                    , "Und warum ist das so?"
                    , "Was fühlen Sie dabei?"
                    , "In Ordnung. Fahren Sie fort."
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

    -- === Possessives ===
    , { keyword = "meine"
      , weight = 2
      , decompositions =
            [ { pattern = [ "meine ", "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über Ihre *."
                    , "Warum ist Ihnen Ihre * wichtig?"
                    , "Wie beeinflusst Ihre * Ihr Leben?"
                    , "Welche Rolle spielt Ihre * in Ihrem Leben?"
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
                    , "Wie beeinflusst Ihr * Ihr Leben?"
                    ]
              }
            ]
      }

    -- === Family ===
    , { keyword = "mutter"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über Ihre Mutter."
                    , "Wie war Ihre Beziehung zu Ihrer Mutter?"
                    , "Wie hat Ihre Mutter Sie geprägt?"
                    , "Welche Gefühle verbinden Sie mit Ihrer Mutter?"
                    , "Wie würde Ihre Mutter diese Situation sehen?"
                    , "Was für ein Mensch ist Ihre Mutter?"
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

    -- === Emotions ===
    , { keyword = "traurig"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Es tut mir leid, dass Sie traurig sind. Was belastet Sie am meisten?"
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
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was macht Sie wütend?"
                    , "Wie gehen Sie normalerweise mit Ihrer Wut um?"
                    , "Wie äußert sich Ihre Wut?"
                    , "Erzählen Sie mir mehr über diese Wut."
                    , "Auf wen oder was sind Sie wütend?"
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

    -- === Absolutisms ===
    , { keyword = "immer"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Können Sie ein konkretes Beispiel nennen?"
                    , "Wenn Sie 'immer' sagen, meinen Sie das wörtlich?"
                    , "Ist es wirklich immer so, oder kommt es Ihnen so vor?"
                    , "Woran denken Sie dabei konkret?"
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

    -- === Technology ===
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

    -- === Questions from user ===
    , { keyword = "warum"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was meinen Sie, warum?"
                    , "Welche Antwort würde Ihnen am meisten helfen?"
                    , "Was glauben Sie selbst, warum das so ist?"
                    , "Ist die Frage nach dem Warum wichtig für Sie?"
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
                    , "Was möchten Sie wirklich wissen?"
                    , "Was denken Sie selbst?"
                    , "Was erhofffen Sie sich von meiner Antwort?"
                    ]
              }
            ]
      }
    , { keyword = "wie"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Wie meinen Sie das?"
                    , "Was denken Sie?"
                    , "Versuchen Sie, die Frage selbst zu beantworten. Was kommt Ihnen in den Sinn?"
                    , "Welche Antwort würde Sie zufriedenstellen?"
                    ]
              }
            ]
      }

    -- === Work/Life ===
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

