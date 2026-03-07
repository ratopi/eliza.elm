module Eliza.Engine exposing (ElizaState, initState, respond, getGreeting, getGreetingWithName)

{-| The Eliza conversation engine.
    Handles pattern matching and response generation.
-}

import Eliza.Types exposing (Language(..), Keyword, Rule)
import Eliza.Languages.English as English
import Eliza.Languages.German as German
import Regex


-- STATE

type alias ElizaState =
    { responseIndices : List ( String, Int )
    , turnCount : Int
    , lastKeyword : String
    , recentResponses : List String  -- Track last N responses to avoid repetition
    }


initState : ElizaState
initState =
    { responseIndices = []
    , turnCount = 0
    , lastKeyword = ""
    , recentResponses = []
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

                    reflected =
                        applyReflections reflections matchedText

                    rawResponse =
                        pickNonRecentResponse responses currentIndex newTurn state.recentResponses

                    finalResponse =
                        if String.contains "*" rawResponse then
                            let
                                trimReflected = String.trim reflected
                            in
                            if trimReflected == "" then
                                String.replace " *" "" rawResponse
                                    |> String.replace "* " ""
                                    |> String.replace "*" ""
                            else
                                String.replace "*" trimReflected rawResponse
                        else
                            rawResponse

                    -- Occasionally prepend user name
                    namedResponse =
                        if newTurn > 3 && modBy 7 newTurn == 0 then
                            userName ++ ", " ++ decapitalize finalResponse
                        else
                            finalResponse

                    newState =
                        { state
                            | responseIndices = updateResponseIndices state.responseIndices key (currentIndex + 1)
                            , turnCount = newTurn
                            , lastKeyword = key
                            , recentResponses = addRecent namedResponse state.recentResponses
                        }
                in
                ( namedResponse, newState )

            Nothing ->
                if isVeryShortInput cleanInput then
                    let
                        idx = getResponseIndex state "_short_"
                        resp = pickNonRecentResponse shortInputResponses idx newTurn state.recentResponses
                        newState =
                            { state
                                | responseIndices = updateResponseIndices state.responseIndices "_short_" (idx + 1)
                                , turnCount = newTurn
                                , lastKeyword = "_short_"
                                , recentResponses = addRecent resp state.recentResponses
                            }
                    in
                    ( resp, newState )

                else
                    let
                        idx =
                            getResponseIndex state "_default_"

                        resp =
                            pickNonRecentResponse defaultResponses idx newTurn state.recentResponses

                        namedResp =
                            if newTurn > 5 && modBy 6 newTurn == 0 then
                                userName ++ ", " ++ decapitalize resp
                            else
                                resp

                        newState =
                            { state
                                | responseIndices = updateResponseIndices state.responseIndices "_default_" (idx + 1)
                                , turnCount = newTurn
                                , lastKeyword = "_default_"
                                , recentResponses = addRecent namedResp state.recentResponses
                            }
                    in
                    ( namedResp, newState )


{-| Add a response to the recent list, keeping only the last 8.
-}
addRecent : String -> List String -> List String
addRecent resp recent =
    List.take 8 (resp :: recent)


decapitalize : String -> String
decapitalize str =
    case String.uncons str of
        Just ( first, rest ) ->
            String.fromChar (Char.toLower first) ++ rest

        Nothing ->
            str


isVeryShortInput : String -> Bool
isVeryShortInput input =
    String.length (String.trim input) < 3


{-| Pick a response index with pseudo-random variation.
-}
pickIndex : Int -> Int -> Int -> Int
pickIndex total currentIdx turn =
    if total <= 1 then
        0
    else
        modBy total (currentIdx + (turn * 7 + 3))


{-| Pick a response that hasn't been used recently.
    Tries up to `total` different indices before giving up.
-}
pickNonRecentResponse : List String -> Int -> Int -> List String -> String
pickNonRecentResponse responses idx turn recentResponses =
    let
        len = List.length responses
        startIdx = pickIndex len idx turn
    in
    pickNonRecentHelper responses len startIdx 0 recentResponses


pickNonRecentHelper : List String -> Int -> Int -> Int -> List String -> String
pickNonRecentHelper responses len idx attempts recent =
    if attempts >= len then
        -- All responses are recent, just pick one
        responses
            |> List.drop (modBy (max 1 len) idx)
            |> List.head
            |> Maybe.withDefault "..."
    else
        let
            candidate =
                responses
                    |> List.drop (modBy (max 1 len) idx)
                    |> List.head
                    |> Maybe.withDefault "..."
        in
        if List.member candidate recent then
            pickNonRecentHelper responses len (idx + 1) (attempts + 1) recent
        else
            candidate


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

findBestKeyword : List Keyword -> String -> String -> Maybe ( Keyword, String )
findBestKeyword keywords input lastKeyword =
    let
        inputWords =
            String.words input

        wordCount =
            List.length inputWords

        matches =
            keywords
                |> List.filterMap
                    (\kw ->
                        if keywordMatchesInput kw.keyword inputWords input wordCount then
                            case matchKeyword kw input of
                                Just captured ->
                                    Just ( kw, captured )

                                Nothing ->
                                    Nothing
                        else
                            Nothing
                    )
                |> List.sortWith
                    (\( kw1, _ ) ( kw2, _ ) ->
                        case compare kw2.weight kw1.weight of
                            EQ ->
                                compare (String.length kw2.keyword) (String.length kw1.keyword)

                            other ->
                                other
                    )

        nonRepeating =
            List.filter (\( kw, _ ) -> kw.keyword /= lastKeyword) matches
    in
    case nonRepeating of
        first :: _ ->
            Just first

        [] ->
            List.head matches


keywordMatchesInput : String -> List String -> String -> Int -> Bool
keywordMatchesInput keyword inputWords fullInput wordCount =
    if String.contains " " keyword then
        String.contains keyword fullInput
    else if String.length keyword <= 3 then
        case List.head inputWords of
            Just firstWord ->
                if firstWord == keyword then
                    True
                else if wordCount <= 2 then
                    List.member keyword inputWords
                else
                    False

            Nothing ->
                False
    else
        List.member keyword inputWords
            || List.any (\w -> isFuzzyMatch keyword w) inputWords


isFuzzyMatch : String -> String -> Bool
isFuzzyMatch a b =
    let
        lenA = String.length a
        lenB = String.length b
        diff = abs (lenA - lenB)
    in
    if diff > 1 then
        False
    else if lenA < 4 || lenB < 4 then
        False
    else
        editDistance (String.toList a) (String.toList b) 0 <= 1


editDistance : List Char -> List Char -> Int -> Int
editDistance xs ys errors =
    if errors > 1 then
        2
    else
        case ( xs, ys ) of
            ( [], [] ) ->
                errors

            ( [], _ ) ->
                errors + List.length ys

            ( _, [] ) ->
                errors + List.length xs

            ( x :: xr, y :: yr ) ->
                if x == y then
                    editDistance xr yr errors
                else
                    let
                        sub = editDistance xr yr (errors + 1)
                    in
                    if sub <= 1 then
                        sub
                    else
                        min
                            (editDistance xs yr (errors + 1))
                            (editDistance xr ys (errors + 1))


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

        [ _ ] ->
            Just ""

        _ ->
            Nothing


findSubstringAfter : String -> String -> Maybe String
findSubstringAfter needle haystack =
    case indexOf needle haystack of
        Just i ->
            Just (String.dropLeft (i + String.length needle) haystack)

        Nothing ->
            Nothing


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


updateResponseIndices : List ( String, Int ) -> String -> Int -> List ( String, Int )
updateResponseIndices indices key newIndex =
    let
        updated =
            indices
                |> List.filter (\( k, _ ) -> k /= key)
    in
    ( key, newIndex ) :: updated


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
