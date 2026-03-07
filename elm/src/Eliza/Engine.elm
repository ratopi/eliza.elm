module Eliza.Engine exposing (ElizaState, initState, respond, getGreeting, getGreetingWithName)

{-| The Eliza conversation engine.
    Handles pattern matching and response generation.
-}

import Eliza.Types exposing (Language(..), Keyword, Rule)
import Eliza.Languages.English as English
import Eliza.Languages.German as German
import Regex


-- STATE

{-| Tracks the conversation state, including response indices to avoid repetition
    and a simple counter for pseudo-random variation.
-}
type alias ElizaState =
    { responseIndices : List ( String, Int )
    , turnCount : Int
    , lastKeyword : String
    , lastResponse : String
    }


initState : ElizaState
initState =
    { responseIndices = []
    , turnCount = 0
    , lastKeyword = ""
    , lastResponse = ""
    }


-- PUBLIC API

{-| Get the initial greeting for the given language.
-}
getGreeting : Language -> String
getGreeting lang =
    case lang of
        English ->
            English.greeting

        German ->
            German.greeting


{-| Get a personalized greeting with the user's name.
-}
getGreetingWithName : Language -> String -> String
getGreetingWithName lang name =
    case lang of
        English ->
            "Hello " ++ name ++ "! I'm Eliza, your virtual therapist. How are you feeling today?"

        German ->
            "Guten Tag " ++ name ++ "! Ich bin Eliza, Ihre virtuelle Therapeutin. Wie fühlen Sie sich heute?"


{-| Generate a response to user input and return updated state.
-}
respond : Language -> String -> ElizaState -> String -> ( String, ElizaState )
respond lang userName state input =
    let
        cleanInput =
            input
                |> String.toLower
                |> String.trim
                |> removePunctuation

        keywords =
            getKeywords lang

        reflections =
            getReflections lang

        defaultResponses =
            getDefaultResponses lang

        shortInputResponses =
            getShortInputResponses lang

        quitWords =
            getQuitWords lang

        newTurn =
            state.turnCount + 1
    in
    if List.any (\q -> cleanInput == q) quitWords then
        ( getGoodbyeWithName lang userName, state )

    else if isVeryShortInput cleanInput then
        -- Short/nonsensical input: ask user to say more
        let
            idx = getResponseIndex state "_short_"
            resp = pickResponse shortInputResponses idx newTurn
            newState =
                state
                    |> (\s -> updateResponseIndex s "_short_" (idx + 1))
                    |> (\s -> { s | turnCount = newTurn, lastKeyword = "_short_", lastResponse = resp })
        in
        ( resp, newState )

    else
        case findBestKeyword keywords cleanInput state.lastKeyword of
            Just ( keyword, matchedText ) ->
                let
                    key =
                        keyword.keyword

                    currentIndex =
                        getResponseIndex state key

                    responses =
                        keyword.decompositions
                            |> List.concatMap .responses

                    responseCount =
                        List.length responses

                    selectedIndex =
                        pickIndex responseCount currentIndex newTurn

                    response =
                        responses
                            |> List.drop selectedIndex
                            |> List.head
                            |> Maybe.withDefault (pickResponse defaultResponses currentIndex newTurn)

                    reflected =
                        applyReflections reflections matchedText

                    finalResponse =
                        if String.contains "*" response then
                            String.replace "*" (String.trim reflected) response
                        else
                            response

                    -- Occasionally prepend the user's name (but not twice in a row)
                    namedResponse =
                        if modBy 5 newTurn == 0 && newTurn > 2 then
                            userName ++ ", " ++ decapitalize finalResponse
                        else
                            finalResponse

                    newState =
                        state
                            |> (\s -> updateResponseIndex s key (currentIndex + 1))
                            |> (\s -> { s | turnCount = newTurn, lastKeyword = key, lastResponse = namedResponse })
                in
                ( namedResponse, newState )

            Nothing ->
                let
                    idx =
                        getResponseIndex state "_default_"

                    resp =
                        pickResponse defaultResponses idx newTurn

                    namedResp =
                        if modBy 4 newTurn == 0 && newTurn > 2 then
                            userName ++ ", " ++ decapitalize resp
                        else
                            resp

                    newState =
                        state
                            |> (\s -> updateResponseIndex s "_default_" (idx + 1))
                            |> (\s -> { s | turnCount = newTurn, lastKeyword = "_default_", lastResponse = namedResp })
                in
                ( namedResp, newState )


{-| Decapitalize the first character of a string.
-}
decapitalize : String -> String
decapitalize str =
    case String.uncons str of
        Just ( first, rest ) ->
            String.fromChar (Char.toLower first) ++ rest

        Nothing ->
            str


{-| Check if input is very short or meaningless (< 4 characters, no real words).
-}
isVeryShortInput : String -> Bool
isVeryShortInput input =
    let
        trimmed = String.trim input
        wordCount = List.length (String.words trimmed)
    in
    String.length trimmed < 4 && wordCount <= 1


{-| Pick a response index using turn count for pseudo-random variation.
    Avoids picking the same index twice in a row.
-}
pickIndex : Int -> Int -> Int -> Int
pickIndex total currentIdx turn =
    if total <= 1 then
        0
    else
        let
            -- Use a simple hash-like scramble based on turn count
            scrambled = modBy total (currentIdx + (turn * 7 + 3))
        in
        scrambled


{-| Pick a response from a list, using index and turn for variation.
-}
pickResponse : List String -> Int -> Int -> String
pickResponse responses idx turn =
    let
        len = List.length responses
        chosen = pickIndex len idx turn
    in
    responses
        |> List.drop chosen
        |> List.head
        |> Maybe.withDefault "..."


-- LANGUAGE DATA ACCESS

getKeywords : Language -> List Keyword
getKeywords lang =
    case lang of
        English ->
            English.keywords

        German ->
            German.keywords


getReflections : Language -> List ( String, String )
getReflections lang =
    case lang of
        English ->
            English.reflections

        German ->
            German.reflections


getDefaultResponses : Language -> List String
getDefaultResponses lang =
    case lang of
        English ->
            English.defaultResponses

        German ->
            German.defaultResponses


getShortInputResponses : Language -> List String
getShortInputResponses lang =
    case lang of
        English ->
            English.shortInputResponses

        German ->
            German.shortInputResponses


getQuitWords : Language -> List String
getQuitWords lang =
    case lang of
        English ->
            English.quitWords

        German ->
            German.quitWords


getGoodbye : Language -> String
getGoodbye lang =
    case lang of
        English ->
            English.goodbye

        German ->
            German.goodbye


getGoodbyeWithName : Language -> String -> String
getGoodbyeWithName lang name =
    case lang of
        English ->
            "Goodbye " ++ name ++ ". Thank you for talking with me. Take care!"

        German ->
            "Auf Wiedersehen " ++ name ++ ". Danke für das Gespräch. Passen Sie auf sich auf!"


-- PATTERN MATCHING

{-| Find the best matching keyword for the given input.
    Keywords must appear as whole words in the input (word boundary matching).
    Avoids picking the same keyword as last time when possible.
-}
findBestKeyword : List Keyword -> String -> String -> Maybe ( Keyword, String )
findBestKeyword keywords input lastKeyword =
    let
        inputWords =
            String.words input

        matches =
            keywords
                |> List.filterMap
                    (\kw ->
                        if containsKeywordAsWord kw.keyword inputWords input then
                            case matchKeyword kw input of
                                Just captured ->
                                    Just ( kw, captured )

                                Nothing ->
                                    Nothing
                        else
                            Nothing
                    )
                |> List.sortBy (\( kw, _ ) -> negate kw.weight)

        -- If possible, avoid repeating the same keyword as last turn
        nonRepeating =
            List.filter (\( kw, _ ) -> kw.keyword /= lastKeyword) matches
    in
    case nonRepeating of
        first :: _ ->
            Just first

        [] ->
            List.head matches


{-| Check if a keyword (which may be multi-word) appears as whole word(s) in the input.
-}
containsKeywordAsWord : String -> List String -> String -> Bool
containsKeywordAsWord keyword inputWords fullInput =
    if String.contains " " keyword then
        -- Multi-word keyword: check if phrase appears in full input
        String.contains keyword fullInput
    else
        -- Single word: must appear as a standalone word
        List.member keyword inputWords


{-| Try to match a keyword against input. Returns captured text if matched.
-}
matchKeyword : Keyword -> String -> Maybe String
matchKeyword keyword input =
    let
        results =
            keyword.decompositions
                |> List.filterMap (\rule -> matchRule rule input)
    in
    List.head results


{-| Try to match a single rule's pattern against input.
-}
matchRule : Rule -> String -> Maybe String
matchRule rule input =
    case rule.pattern of
        [ "*" ] ->
            -- Matches anything
            Just input

        [ before, "*" ] ->
            -- Pattern: "word *"
            let
                prefix = String.toLower before
            in
            if String.startsWith prefix input then
                Just (String.dropLeft (String.length prefix) input |> String.trim)
            else
                Nothing

        [ "*", after ] ->
            -- Pattern: "* word"
            let
                suffix = String.toLower after
            in
            if String.endsWith suffix input then
                Just (String.dropRight (String.length suffix) input |> String.trim)
            else
                Nothing

        [ before, "*", after ] ->
            -- Pattern: "word * word"
            let
                prefix = String.toLower before
                suffix = String.toLower after
            in
            if String.startsWith prefix input && String.endsWith suffix input then
                let
                    middle =
                        input
                            |> String.dropLeft (String.length prefix)
                            |> String.dropRight (String.length suffix)
                            |> String.trim
                in
                Just middle
            else
                Nothing

        [ single ] ->
            -- Exact keyword match somewhere in input (already verified by containsKeywordAsWord)
            Just ""

        _ ->
            Nothing


-- REFLECTIONS

{-| Apply pronoun reflections to captured text.
-}
applyReflections : List ( String, String ) -> String -> String
applyReflections reflections text =
    let
        words =
            String.words text

        reflected =
            List.map
                (\word ->
                    reflections
                        |> List.foldl
                            (\( from, to ) w ->
                                if String.toLower w == from then
                                    to
                                else
                                    w
                            )
                            word
                )
                words
    in
    String.join " " reflected


-- STATE MANAGEMENT

getResponseIndex : ElizaState -> String -> Int
getResponseIndex state key =
    state.responseIndices
        |> List.filter (\( k, _ ) -> k == key)
        |> List.head
        |> Maybe.map Tuple.second
        |> Maybe.withDefault 0


updateResponseIndex : ElizaState -> String -> Int -> ElizaState
updateResponseIndex state key newIndex =
    let
        updated =
            state.responseIndices
                |> List.filter (\( k, _ ) -> k /= key)

        newIndices =
            ( key, newIndex ) :: updated
    in
    { state | responseIndices = newIndices }


-- UTILITIES

removePunctuation : String -> String
removePunctuation text =
    let
        maybeRegex =
            Regex.fromString "[.,!?;:']"
    in
    case maybeRegex of
        Just regex ->
            Regex.replace regex (\_ -> "") text

        Nothing ->
            text
