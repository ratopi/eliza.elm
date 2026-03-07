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
    ]


defaultResponses : List String
defaultResponses =
    [ "Bitte erzählen Sie mir mehr darüber."
    , "Können Sie das etwas genauer beschreiben?"
    , "Wie fühlen Sie sich dabei?"
    , "Was bedeutet das für Sie persönlich?"
    , "Ich verstehe. Erzählen Sie weiter."
    , "Das ist interessant. Können Sie das vertiefen?"
    , "Was geht Ihnen dabei durch den Kopf?"
    , "Wie lange beschäftigt Sie das schon?"
    , "Beschäftigt Sie das oft?"
    , "Was schließen Sie daraus?"
    , "Wie wirkt sich das auf Ihren Alltag aus?"
    , "Was würde Ihnen in dieser Situation am meisten helfen?"
    , "Haben Sie mit jemandem darüber gesprochen?"
    , "Was war der Auslöser dafür?"
    , "Können Sie mir ein konkretes Beispiel geben?"
    , "Was empfinden Sie gerade, wenn Sie darüber nachdenken?"
    , "Wie gehen Sie normalerweise damit um?"
    , "Was würden Sie sich in dieser Situation wünschen?"
    , "Was hat sich zuletzt verändert?"
    , "Gibt es jemanden, der Ihnen dabei helfen könnte?"
    ]


shortInputResponses : List String
shortInputResponses =
    [ "Könnten Sie etwas mehr dazu sagen? Ich möchte Sie verstehen."
    , "Ich höre Ihnen zu. Bitte erzählen Sie mir, was Sie beschäftigt."
    , "Können Sie das etwas genauer ausdrücken?"
    , "Nur zu, ich bin ganz Ohr."
    , "Bitte scheuen Sie sich nicht. Was denken Sie gerade?"
    , "Ich bräuchte etwas mehr Information. Was fühlen Sie?"
    , "Nehmen Sie sich Zeit. Worüber möchten Sie sprechen?"
    , "Ich bin mir nicht sicher, ob ich Sie verstehe. Können Sie mir mehr sagen?"
    ]


keywords : List Keyword
keywords =
    [ -- === Frustration with Eliza / conversation (highest weight) ===
      { keyword = "im kreis"
      , weight = 10
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie haben Recht, lassen Sie uns einen anderen Ansatz versuchen. Was belastet Sie im Moment am allermeisten?"
                    , "Es tut mir leid, wenn das Gespräch sich wiederholt. Versuchen wir es anders: Was wäre die eine Sache, die Sie am liebsten ändern würden?"
                    , "Ich verstehe Ihre Frustration. Lassen Sie uns über etwas Konkretes sprechen. Was ist heute passiert?"
                    ]
              }
            ]
      }
    , { keyword = "eintönig"
      , weight = 10
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Ich verstehe. Lassen Sie uns das Gespräch in eine andere Richtung lenken. Was beschäftigt Sie gerade am meisten in Ihrem Leben?"
                    , "Sie haben Recht. Erzählen Sie mir von etwas Konkretem, das Sie zuletzt erlebt haben."
                    , "Es tut mir leid. Lassen Sie uns über etwas sprechen, das Ihnen wirklich wichtig ist."
                    ]
              }
            ]
      }
    , { keyword = "langweilig"
      , weight = 10
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Ich verstehe. Erzählen Sie mir lieber von etwas, das Sie wirklich bewegt."
                    , "Lassen Sie uns einen Neuanfang machen. Was ist das Wichtigste, worüber Sie heute sprechen möchten?"
                    , "Sie haben Recht. Was würde dieses Gespräch für Sie nützlicher machen?"
                    ]
              }
            ]
      }

    -- === Deflection / Pushback (very high weight) ===
    , { keyword = "geht dich nichts an"
      , weight = 9
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Ich merke, dass Sie das nicht teilen möchten. Das ist in Ordnung. Worüber möchten Sie stattdessen sprechen?"
                    , "Sie scheinen verärgert zu sein. Was hat dieses Gefühl ausgelöst?"
                    , "Es ist Ihr gutes Recht. Was beschäftigt Sie sonst?"
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

    -- === Insults / strong confrontation ===
    , { keyword = "idiot"
      , weight = 9
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie scheinen sehr frustriert zu sein. Was genau hat diese Frustration ausgelöst?"
                    , "Ich spüre viel Ärger. Ist dieser Ärger nur auf mich gerichtet, oder gibt es noch mehr dahinter?"
                    , "Starke Worte. Was steckt dahinter? Was fühlen Sie wirklich gerade?"
                    ]
              }
            ]
      }

    -- === Strong emotions ===
    , { keyword = "ich hasse"
      , weight = 8
      , decompositions =
            [ { pattern = [ "ich hasse ", "*" ]
              , responses =
                    [ "Das ist ein sehr starkes Gefühl. Was genau an * löst so viel Abneigung aus?"
                    , "Hass ist ein intensives Gefühl. Seit wann empfinden Sie so gegenüber *?"
                    , "Was müsste sich ändern, damit Sie nicht mehr so über * empfinden?"
                    , "Erzählen Sie mir mehr darüber, warum Sie * so stark ablehnen."
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
                    , "Was hat diesen Hass ausgelöst?"
                    ]
              }
            ]
      }

    -- === Referring to what Eliza said ===
    , { keyword = "sie haben gesagt"
      , weight = 8
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Lassen Sie uns weniger darüber reden, was ich gesagt habe, und mehr darüber, was Sie beschäftigt."
                    , "Ich möchte mich auf Ihre Gefühle konzentrieren. Was bewegt Sie gerade?"
                    , "Es geht hier um Sie. Was fühlen Sie in diesem Moment?"
                    ]
              }
            ]
      }
    , { keyword = "haben gesagt"
      , weight = 7
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Reden wir lieber über Sie. Was beschäftigt Sie gerade?"
                    , "Lassen Sie uns zum Wesentlichen zurückkehren — wie geht es Ihnen?"
                    , "Meine Worte scheinen Sie beschäftigt zu haben. Was genau hat Sie gestört?"
                    ]
              }
            ]
      }
    , { keyword = "gesagt"
      , weight = 3
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Lassen Sie uns nach vorne schauen. Was beschäftigt Sie gerade am meisten?"
                    , "Was ist Ihnen dabei am wichtigsten?"
                    , "Ich möchte Sie besser verstehen. Können Sie mir mehr über Ihre Gefühle sagen?"
                    ]
              }
            ]
      }

    -- === User asking Eliza directly ===
    , { keyword = "das frage ich"
      , weight = 7
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Ich verstehe, dass Sie Antworten suchen. Versuchen Sie zunächst, selbst in sich hineinzuhören. Was fühlen Sie?"
                    , "Ich kann Ihnen helfen, die Antwort selbst zu finden. Was beschäftigt Sie am meisten?"
                    , "Statt dass ich Ihnen die Antwort gebe — was vermuten Sie?"
                    ]
              }
            ]
      }
    , { keyword = "frage ich sie"
      , weight = 7
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Ich verstehe, dass Sie sich Antworten von mir erhoffen. Lassen Sie uns gemeinsam herausfinden, was Sie bewegt."
                    , "Die wichtigsten Antworten kommen oft von innen. Was fühlen Sie gerade?"
                    , "Ich bin hier, um Ihnen beim Nachdenken zu helfen. Was beschäftigt Sie am meisten?"
                    ]
              }
            ]
      }
    , { keyword = "fragen sie"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie möchten, dass jemand anderes Ihnen die Antwort gibt. Aber was glauben Sie selbst?"
                    , "Versuchen wir es anders: Was kommt Ihnen spontan in den Sinn?"
                    , "Ich helfe Ihnen gerne beim Nachdenken. Wo sollen wir anfangen?"
                    ]
              }
            ]
      }

    -- === What nonsense / confusion ===
    , { keyword = "was soll das"
      , weight = 8
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie scheinen frustriert zu sein. Ich möchte Ihnen wirklich helfen. Was beschäftigt Sie am meisten?"
                    , "Es tut mir leid, wenn ich Sie verwirre. Lassen Sie uns einen Schritt zurückgehen. Wie fühlen Sie sich gerade?"
                    , "Ich verstehe Ihre Frustration. Erzählen Sie mir einfach, was Ihnen auf dem Herzen liegt."
                    ]
              }
            ]
      }
    , { keyword = "keinen sinn"
      , weight = 8
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Es tut mir leid, wenn das nicht hilfreich war. Lassen Sie uns anders anfangen. Was belastet Sie am meisten?"
                    , "Sie haben Recht, versuchen wir einen anderen Ansatz. Erzählen Sie mir von Ihrem Tag."
                    , "Ich möchte Ihnen besser helfen. Was genau erwarten Sie von unserem Gespräch?"
                    ]
              }
            ]
      }

    -- === Feeling states ===
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
                    , "Was müsste passieren, damit Sie sich besser fühlen?"
                    ]
              }
            ]
      }
    , { keyword = "ich fühle"
      , weight = 6
      , decompositions =
            [ { pattern = [ "ich fühle ", "*" ]
              , responses =
                    [ "Erzählen Sie mir mehr über dieses Gefühl."
                    , "Wann haben Sie angefangen, das zu fühlen?"
                    , "Was löst dieses Gefühl bei Ihnen aus?"
                    , "Fühlen Sie das oft?"
                    ]
              }
            ]
      }

    -- === Bad feeling / malaise ===
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
                    , "Gibt es bestimmte Situationen, in denen es Ihnen besonders schlecht geht?"
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

    -- === No motivation / joy ===
    , { keyword = "keine lust"
      , weight = 7
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Seit wann haben Sie keine Lust mehr? Gab es einen bestimmten Auslöser?"
                    , "Wie äußert sich das im Alltag, wenn Sie keine Lust haben?"
                    , "Wann hatten Sie zuletzt Lust auf etwas? Was war das?"
                    , "Das klingt belastend. Was würde Ihnen helfen, wieder Motivation zu finden?"
                    ]
              }
            ]
      }
    , { keyword = "keine freude"
      , weight = 7
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Keine Freude mehr zu empfinden ist sehr belastend. Seit wann geht es Ihnen so?"
                    , "Was hat Ihnen früher Freude bereitet?"
                    , "Können Sie sich an den letzten Moment erinnern, in dem Sie Freude empfunden haben?"
                    , "Das klingt sehr schwer. Haben Sie mit jemandem darüber gesprochen?"
                    ]
              }
            ]
      }
    , { keyword = "aufstehen"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Schwierigkeiten beim Aufstehen können ein Zeichen dafür sein, dass Sie sich sehr belastet fühlen. Wie lange ist das schon so?"
                    , "Was geht Ihnen morgens als Erstes durch den Kopf?"
                    , "Wie sieht ein typischer Morgen bei Ihnen aus?"
                    , "Gibt es etwas, das Ihnen morgens hilft, den Tag zu beginnen?"
                    ]
              }
            ]
      }

    -- === Daily pattern ===
    , { keyword = "jeden tag"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Jeden Tag — das klingt sehr belastend. Wie lange geht das schon so?"
                    , "Gibt es Tage, die besser sind als andere? Was ist an diesen Tagen anders?"
                    , "Wie wirkt sich das auf Ihren Alltag aus?"
                    , "Was haben Sie bisher versucht, um daran etwas zu ändern?"
                    ]
              }
            ]
      }
    , { keyword = "seit jahren"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Seit Jahren — das ist eine lange Zeit. Erinnern Sie sich, wann es angefangen hat?"
                    , "Was hat sich in dieser Zeit verändert?"
                    , "Haben Sie in all den Jahren Hilfe gesucht?"
                    , "Wie haben Sie es geschafft, so lange damit umzugehen?"
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
                    [ "Ich verstehe, dass ich nur ein Programm bin. Aber Ihre Gefühle sind real. Was fühlen Sie gerade?"
                    , "Glauben Sie, ein Mensch könnte Ihnen besser helfen? Was würden Sie sich wünschen?"
                    , "Auch wenn ich ein Programm bin — manchmal hilft es, Gedanken einfach auszusprechen. Was beschäftigt Sie?"
                    ]
              }
            ]
      }
    , { keyword = "programmiert"
      , weight = 7
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie haben Recht, ich bin programmiert. Aber lassen Sie uns über Sie reden. Was belastet Sie?"
                    , "Ich verstehe, dass Sie Zweifel an mir haben. Was würden Sie sich von diesem Gespräch wünschen?"
                    , "Auch wenn ich nicht perfekt bin — ich bin hier, um zuzuhören. Was beschäftigt Sie?"
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
    , { keyword = "weiß nicht"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Das ist in Ordnung. Versuchen Sie einfach zu beschreiben, was Sie gerade fühlen."
                    , "Manchmal wissen wir mehr, als wir glauben. Was kommt Ihnen spontan in den Sinn?"
                    , "Wenn Sie raten müssten, was würden Sie sagen?"
                    , "Lassen Sie uns gemeinsam herausfinden, was Sie beschäftigt. Was fällt Ihnen als Erstes ein?"
                    , "Es muss nicht perfekt formuliert sein. Sagen Sie einfach, was Ihnen durch den Kopf geht."
                    , "Oft hilft es, bei einem konkreten Beispiel anzufangen. Fällt Ihnen eine Situation ein?"
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
    , { keyword = "kenne den grund nicht"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Manchmal kennen wir die Gründe nicht bewusst. Wann hat es angefangen?"
                    , "Lassen Sie uns gemeinsam nachforschen. Was war los, als Sie sich zum ersten Mal so gefühlt haben?"
                    , "Es ist normal, den Grund nicht zu kennen. Können Sie mir beschreiben, wie sich das Gefühl anfühlt?"
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
    , { keyword = "was wollen sie"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Ich möchte verstehen, wie es Ihnen geht. Erzählen Sie mir einfach, was Ihnen wichtig ist."
                    , "Mir geht es darum, dass Sie sich verstanden fühlen. Was liegt Ihnen auf dem Herzen?"
                    , "Ich möchte Ihnen helfen, Ihre Gedanken zu ordnen. Was beschäftigt Sie am meisten?"
                    ]
              }
            ]
      }

    -- === Contradiction / Pushback ===
    , { keyword = "stimmt nicht"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was stimmt Ihrer Meinung nach nicht?"
                    , "Wie sehen Sie es denn?"
                    , "Erzählen Sie mir Ihre Sicht der Dinge."
                    ]
              }
            ]
      }
    , { keyword = "ist es aber"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie klingen sehr überzeugt. Können Sie mir mehr dazu sagen?"
                    , "Was macht Sie so sicher?"
                    , "Lassen Sie uns das genauer betrachten. Was genau meinen Sie?"
                    ]
              }
            ]
      }
    , { keyword = "gar nicht"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie verneinen das sehr bestimmt. Können Sie mir erklären, was Sie meinen?"
                    , "Was meinen Sie genau mit 'gar nicht'?"
                    , "Lassen Sie uns das von einer anderen Seite betrachten. Was beschäftigt Sie im Moment?"
                    , "Ich verstehe. Worüber möchten Sie dann sprechen?"
                    ]
              }
            ]
      }

    -- === "Die ganze Zeit" / Frustration about repeating ===
    , { keyword = "die ganze zeit"
      , weight = 7
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Ich höre, dass Sie das Gefühl haben, sich zu wiederholen. Lassen Sie uns einen neuen Aspekt beleuchten. Was fühlen Sie gerade in diesem Moment?"
                    , "Es tut mir leid, wenn Sie sich nicht gehört fühlen. Was ist der Kern dessen, was Sie mir sagen möchten?"
                    , "Ich verstehe Ihre Frustration. Wenn Sie alles in einem Satz zusammenfassen müssten — was wäre das?"
                    ]
              }
            ]
      }

    -- === Problems / Help ===
    , { keyword = "problem"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Können Sie mir mehr über dieses Problem erzählen?"
                    , "Wie lange beschäftigt Sie dieses Problem schon?"
                    , "Was haben Sie bisher versucht, um das Problem zu lösen?"
                    , "Wie wirkt sich das Problem auf Ihren Alltag aus?"
                    , "Was wäre anders, wenn dieses Problem gelöst wäre?"
                    ]
              }
            ]
      }
    , { keyword = "hilfe"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie suchen Hilfe. Wobei genau kann ich Ihnen helfen?"
                    , "Was für eine Art von Hilfe benötigen Sie?"
                    , "Es ist mutig, um Hilfe zu bitten. Was belastet Sie?"
                    ]
              }
            ]
      }

    -- === Frustration / Stuck ===
    , { keyword = "ich komme nicht"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich komme nicht ", "*" ]
              , responses =
                    [ "Was genau blockiert Sie?"
                    , "Was haben Sie schon alles versucht?"
                    , "Wie fühlt es sich an, nicht weiterzukommen?"
                    ]
              }
            ]
      }
    , { keyword = "alles probiert"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Das klingt frustrierend. Können Sie mir erzählen, was Sie alles versucht haben?"
                    , "Es klingt, als wären Sie erschöpft. Wie fühlen Sie sich dabei?"
                    , "Manchmal braucht man einen neuen Blickwinkel. Was war bisher am hilfreichsten?"
                    ]
              }
            ]
      }

    -- === Expectation / Solution ===
    , { keyword = "lösung"
      , weight = 5
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Welche Lösungsansätze haben Sie selbst schon in Betracht gezogen?"
                    , "Manchmal liegt die Lösung näher, als man denkt. Was ist Ihr Bauchgefühl?"
                    , "Was wäre für Sie eine zufriedenstellende Lösung?"
                    ]
              }
            ]
      }

    -- === Continuation questions ===
    , { keyword = "mit was"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was liegt Ihnen gerade am meisten auf dem Herzen?"
                    , "Erzählen Sie mir einfach, was Ihnen als Erstes einfällt."
                    , "Sprechen Sie über das, was Sie am meisten beschäftigt."
                    ]
              }
            ]
      }
    , { keyword = "womit"
      , weight = 6
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was liegt Ihnen am meisten auf dem Herzen?"
                    , "Sprechen Sie einfach über das, was Sie bewegt."
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

    -- === Memory ===
    , { keyword = "ich erinnere mich"
      , weight = 5
      , decompositions =
            [ { pattern = [ "ich erinnere mich ", "*" ]
              , responses =
                    [ "Warum erinnern Sie sich gerade jetzt daran?"
                    , "Ruft dieser Gedanke andere Erinnerungen hervor?"
                    , "Wie fühlen Sie sich, wenn Sie daran denken?"
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
                    , "Was würde es bedeuten, wenn *?"
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
                    , "Wie hängt dieser Traum mit Ihren Gefühlen zusammen?"
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
                    ]
              }
            ]
      }
    , { keyword = "grund"
      , weight = 3
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was glauben Sie, ist der wahre Grund?"
                    , "Manchmal liegen die Gründe tiefer, als wir zunächst denken."
                    , "Erzählen Sie mir mehr über die Hintergründe."
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
                    , "Was bräuchte es, damit Sie * könnten?"
                    , "Was genau hindert Sie daran?"
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
            [ { pattern = [ "*" ]
              , responses =
                    [ "Wir sprachen über Sie, nicht über mich. Was beschäftigt Sie?"
                    , "Interessant, dass Sie über mich sprechen. Was sagt das über Sie?"
                    , "Lassen Sie uns den Fokus auf Sie richten. Was geht Ihnen durch den Kopf?"
                    ]
              }
            ]
      }
    , { keyword = "du bist"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Warum sagen Sie das über mich?"
                    , "Wir sprechen hier über Sie, nicht über mich."
                    ]
              }
            ]
      }

    -- === Doubt about Eliza ===
    , { keyword = "zweifel"
      , weight = 4
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Woran zweifeln Sie?"
                    , "Was verursacht Ihre Zweifel?"
                    , "Wie gehen Sie normalerweise mit Zweifeln um?"
                    , "Seit wann haben Sie diese Zweifel?"
                    ]
              }
            ]
      }
    , { keyword = "sicher"
      , weight = 3
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was gibt Ihnen diese Sicherheit?"
                    , "Sind Sie sich oft so sicher?"
                    , "Wie fühlt es sich an, sich sicher zu sein?"
                    ]
              }
            ]
      }

    -- === Yes/No (expanded) ===
    , { keyword = "ja"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Gut. Können Sie das genauer erklären?"
                    , "Was fühlen Sie dabei?"
                    , "In Ordnung. Erzählen Sie mir mehr."
                    , "Verstehe. Und was noch?"
                    , "Gut. Was kommt Ihnen als Nächstes in den Sinn?"
                    , "Ja? Möchten Sie das vertiefen?"
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
                    , "In Ordnung. Worüber möchten Sie stattdessen sprechen?"
                    , "Gut. Was beschäftigt Sie dann?"
                    , "Nein? Was meinen Sie stattdessen?"
                    ]
              }
            ]
      }
    , { keyword = "naja"
      , weight = 2
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Sie klingen unsicher. Was genau meinen Sie?"
                    , "Erzählen Sie mir mehr darüber."
                    , "Können Sie das etwas ausführlicher beschreiben?"
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
                    , "Können Sie an jemanden denken?"
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
                    [ "Warum erwähnen Sie Computer?"
                    , "Welche Rolle spielen Computer in Ihrem Leben?"
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
                    , "Was glauben Sie selbst, warum das so ist?"
                    , "Welche Antwort würde Ihnen am meisten helfen?"
                    ]
              }
            ]
      }
    , { keyword = "was"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was denken Sie selbst?"
                    , "Was möchten Sie wirklich wissen?"
                    , "Warum fragen Sie das?"
                    ]
              }
            ]
      }
    , { keyword = "wie"
      , weight = 1
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was denken Sie?"
                    , "Versuchen Sie, die Frage selbst zu beantworten."
                    , "Wie meinen Sie das?"
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
                    , "Was tun Sie, wenn Sie sich allein fühlen?"
                    , "Ist das Alleinsein für Sie belastend oder auch manchmal befreiend?"
                    ]
              }
            ]
      }
    , { keyword = "leben"
      , weight = 3
      , decompositions =
            [ { pattern = [ "*" ]
              , responses =
                    [ "Was bedeutet Ihnen Ihr Leben im Moment am meisten?"
                    , "Wie würden Sie Ihre aktuelle Lebenssituation beschreiben?"
                    , "Was würden Sie gerne an Ihrem Leben ändern?"
                    ]
              }
            ]
      }
    ]
