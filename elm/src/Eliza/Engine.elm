module Eliza.Engine exposing (ElizaState, initState, respond, getGreeting, getGreetingWithName)

{-| The Eliza conversation engine.
    Handles pattern matching and response generation.
-}

import Eliza.Types exposing (Language(..), Keyword, Rule)
import Eliza.Languages.English as English
import Eliza.Languages.German as German
import Regex


-- STATE

{-| Tracks the conversation state, including response indices to avoid repetition.
-}
type alias ElizaState =
    { responseIndices : List ( String, Int )
    }


initState : ElizaState
initState =
    { responseIndices = [] }


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
    The userName parameter allows Eliza to occasionally address the user by name.
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

        quitWords =
            getQuitWords lang
    in
    if List.any (\q -> cleanInput == q) quitWords then
        ( getGoodbyeWithName lang userName, state )
    else
        case findBestKeyword keywords cleanInput of
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
                        modBy (max 1 responseCount) currentIndex

                    response =
                        responses
                            |> List.drop selectedIndex
                            |> List.head
                            |> Maybe.withDefault (getDefaultResponse defaultResponses state)

                    reflected =
                        applyReflections reflections matchedText

                    finalResponse =
                        String.replace "*" reflected response

                    -- Occasionally prepend the user's name
                    namedResponse =
                        if modBy 4 currentIndex == 0 && currentIndex > 0 then
                            userName ++ ", " ++ decapitalize finalResponse
                        else
                            finalResponse

                    newState =
                        updateResponseIndex state key (currentIndex + 1)
                in
                ( namedResponse, newState )

            Nothing ->
                let
                    idx =
                        getResponseIndex state "_default_"

                    resp =
                        getDefaultResponseByIndex defaultResponses idx

                    -- Occasionally prepend the user's name
                    namedResp =
                        if modBy 3 idx == 0 && idx > 0 then
                            userName ++ ", " ++ decapitalize resp
                        else
                            resp

                    newState =
                        updateResponseIndex state "_default_" (idx + 1)
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
    Returns the keyword and the captured wildcard text.
-}
findBestKeyword : List Keyword -> String -> Maybe ( Keyword, String )
findBestKeyword keywords input =
    let
        matches =
            keywords
                |> List.filterMap
                    (\kw ->
                        case matchKeyword kw input of
                            Just captured ->
                                Just ( kw, captured )

                            Nothing ->
                                Nothing
                    )
                |> List.sortBy (\( kw, _ ) -> negate kw.weight)
    in
    List.head matches


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
            -- Exact keyword match somewhere in input
            if String.contains (String.toLower single) input then
                Just ""
            else
                Nothing

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


getDefaultResponse : List String -> ElizaState -> String
getDefaultResponse defaults state =
    let
        idx = getResponseIndex state "_default_"
    in
    getDefaultResponseByIndex defaults idx


getDefaultResponseByIndex : List String -> Int -> String
getDefaultResponseByIndex defaults idx =
    let
        len = List.length defaults
        safeIdx = modBy (max 1 len) idx
    in
    defaults
        |> List.drop safeIdx
        |> List.head
        |> Maybe.withDefault "Please go on."


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
