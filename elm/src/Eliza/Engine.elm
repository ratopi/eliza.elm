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

getGreeting : Language -> String
getGreeting lang =
    case lang of
        English ->
            English.greeting

        German ->
            German.greeting


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
                |> collapseSpaces

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

    else
        -- Always try keyword matching first, even for short input
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
                            let
                                trimReflected = String.trim reflected
                            in
                            if trimReflected == "" then
                                -- Remove the wildcard placeholder if nothing was captured
                                String.replace " *" "" response
                                    |> String.replace "* " ""
                                    |> String.replace "*" ""
                            else
                                String.replace "*" trimReflected response
                        else
                            response

                    -- Occasionally prepend the user's name (not too often, not first turns)
                    namedResponse =
                        if newTurn > 3 && modBy 5 newTurn == 0 && state.lastKeyword /= "_named_" then
                            userName ++ ", " ++ decapitalize finalResponse
                        else
                            finalResponse

                    newState =
                        state
                            |> (\s -> updateResponseIndex s key (currentIndex + 1))
                            |> (\s -> { s | turnCount = newTurn
                                          , lastKeyword = key
                                          , lastResponse = namedResponse })
                in
                ( namedResponse, newState )

            Nothing ->
                -- No keyword matched: check if input is very short/meaningless
                if isVeryShortInput cleanInput then
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
                    let
                        idx =
                            getResponseIndex state "_default_"

                        resp =
                            pickResponse defaultResponses idx newTurn

                        namedResp =
                            if newTurn > 4 && modBy 4 newTurn == 0 then
                                userName ++ ", " ++ decapitalize resp
                            else
                                resp

                        newState =
                            state
                                |> (\s -> updateResponseIndex s "_default_" (idx + 1))
                                |> (\s -> { s | turnCount = newTurn, lastKeyword = "_default_", lastResponse = namedResp })
                    in
                    ( namedResp, newState )


decapitalize : String -> String
decapitalize str =
    case String.uncons str of
        Just ( first, rest ) ->
            String.fromChar (Char.toLower first) ++ rest

        Nothing ->
            str


{-| Check if input is very short AND has no recognizable keyword meaning.
    Only truly meaningless gibberish (< 3 characters, single token).
-}
isVeryShortInput : String -> Bool
isVeryShortInput input =
    let
        trimmed = String.trim input
    in
    String.length trimmed < 3


{-| Pick a response index using turn count for pseudo-random variation.
-}
pickIndex : Int -> Int -> Int -> Int
pickIndex total currentIdx turn =
    if total <= 1 then
        0
    else
        let
            scrambled = modBy total (currentIdx + (turn * 7 + 3))
        in
        scrambled


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
    Among keywords with same weight, prefer longer (more specific) keywords.
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
                -- Sort by: weight descending, then keyword length descending (more specific first)
                |> List.sortWith
                    (\( kw1, _ ) ( kw2, _ ) ->
                        case compare kw2.weight kw1.weight of
                            EQ ->
                                compare (String.length kw2.keyword) (String.length kw1.keyword)

                            other ->
                                other
                    )

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


matchKeyword : Keyword -> String -> Maybe String
matchKeyword keyword input =
    let
        results =
            keyword.decompositions
                |> List.filterMap (\rule -> matchRule rule input)
    in
    List.head results


matchRule : Rule -> String -> Maybe String
matchRule rule input =
    case rule.pattern of
        [ "*" ] ->
            Just input

        [ before, "*" ] ->
            let
                prefix = String.toLower before
            in
            if String.startsWith prefix input then
                Just (String.dropLeft (String.length prefix) input |> String.trim)
            else
                -- Also try to find the prefix anywhere in the input (for multi-clause input)
                case findSubstringAfter prefix input of
                    Just rest ->
                        Just (String.trim rest)

                    Nothing ->
                        Nothing

        [ "*", after ] ->
            let
                suffix = String.toLower after
            in
            if String.endsWith suffix input then
                Just (String.dropRight (String.length suffix) input |> String.trim)
            else
                Nothing

        [ before, "*", after ] ->
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
            Just ""

        _ ->
            Nothing


{-| Find a substring in the input and return everything after it.
    Useful for matching patterns in multi-clause input like "ich weiß nicht ich fühle mich schlecht"
-}
findSubstringAfter : String -> String -> Maybe String
findSubstringAfter needle haystack =
    let
        idx = indexOf needle haystack
    in
    case idx of
        Just i ->
            Just (String.dropLeft (i + String.length needle) haystack)

        Nothing ->
            Nothing


{-| Simple indexOf implementation.
-}
indexOf : String -> String -> Maybe Int
indexOf needle haystack =
    indexOfHelper needle haystack 0


indexOfHelper : String -> String -> Int -> Maybe Int
indexOfHelper needle haystack offset =
    if String.length haystack < String.length needle then
        Nothing
    else if String.startsWith needle haystack then
        Just offset
    else
        indexOfHelper needle (String.dropLeft 1 haystack) (offset + 1)


-- REFLECTIONS

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
            Regex.fromString "[.,!?;:'\"]"
    in
    case maybeRegex of
        Just regex ->
            Regex.replace regex (\_ -> "") text

        Nothing ->
            text


{-| Collapse multiple spaces into one.
-}
collapseSpaces : String -> String
collapseSpaces text =
    let
        maybeRegex =
            Regex.fromString "\\s+"
    in
    case maybeRegex of
        Just regex ->
            Regex.replace regex (\_ -> " ") text
                |> String.trim

        Nothing ->
            text

