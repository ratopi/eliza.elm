port module Main exposing (main)

{-| Eliza Chatbot - An ELIZA-inspired chatbot in Elm.
    Supports multiple languages (English and German).
    Users select their language and enter their name before chatting.
-}

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Svg exposing (svg, path)
import Svg.Attributes as SvgAttr
import Eliza.Engine as Engine
import Eliza.Languages.English as English
import Eliza.Languages.German as German
import Eliza.Types exposing (Language(..), Message, Sender(..))


-- PORTS

port scrollChatToBottom : () -> Cmd msg


-- MAIN

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


-- MODEL

type Screen
    = Setup
    | Chat


type alias Model =
    { screen : Screen
    , userName : String
    , messages : List Message
    , inputText : String
    , language : Language
    , elizaState : Engine.ElizaState
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { screen = Setup
      , userName = ""
      , messages = []
      , inputText = ""
      , language = English
      , elizaState = Engine.initState
      }
    , Cmd.none
    )


-- UPDATE

type Msg
    = UpdateInput String
    | UpdateName String
    | SendMessage
    | SwitchLanguage Language
    | StartChat
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateInput text ->
            ( { model | inputText = text }, Cmd.none )

        UpdateName name ->
            ( { model | userName = name }, Cmd.none )

        SwitchLanguage lang ->
            ( { model | language = lang }, Cmd.none )

        StartChat ->
            if String.trim model.userName == "" then
                ( model, Cmd.none )
            else
                let
                    greeting =
                        Engine.getGreetingWithName model.language (String.trim model.userName)
                in
                ( { model
                    | screen = Chat
                    , messages = [ { text = greeting, sender = Eliza } ]
                    , elizaState = Engine.initState
                  }
                , scrollChatToBottom ()
                )

        SendMessage ->
            if String.trim model.inputText == "" then
                ( model, Cmd.none )
            else
                let
                    userMessage =
                        { text = model.inputText, sender = User }

                    ( response, newState ) =
                        Engine.respond model.language model.userName model.elizaState model.inputText

                    elizaMessage =
                        { text = response, sender = Eliza }
                in
                ( { model
                    | messages = model.messages ++ [ userMessage, elizaMessage ]
                    , inputText = ""
                    , elizaState = newState
                  }
                , scrollChatToBottom ()
                )

        NoOp ->
            ( model, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
    case model.screen of
        Setup ->
            viewSetup model

        Chat ->
            viewChatScreen model


-- SETUP VIEW

viewSetup : Model -> Html Msg
viewSetup model =
    div [ class "app-container" ]
        [ div [ class "setup-screen" ]
            [ div [ class "setup-card" ]
                [ div [ class "setup-logo" ]
                    [ h1 [] [ text "ELIZA" ]
                    , p [ class "setup-subtitle" ]
                        [ text (setupSubtitle model.language) ]
                    ]
                , div [ class "setup-form" ]
                    [ div [ class "language-selector setup-lang" ]
                        [ button
                            [ class (if model.language == English then "lang-btn active" else "lang-btn")
                            , onClick (SwitchLanguage English)
                            ]
                            [ text "\u{1F1EC}\u{1F1E7} English" ]
                        , button
                            [ class (if model.language == German then "lang-btn active" else "lang-btn")
                            , onClick (SwitchLanguage German)
                            ]
                            [ text "\u{1F1E9}\u{1F1EA} Deutsch" ]
                        ]
                    , div [ class "name-input-group" ]
                        [ label [ for "name-input" ]
                            [ text (nameLabel model.language) ]
                        , input
                            [ type_ "text"
                            , id "name-input"
                            , class "name-input"
                            , placeholder (namePlaceholder model.language)
                            , value model.userName
                            , onInput UpdateName
                            , onEnter StartChat
                            ]
                            []
                        ]
                    , button
                        [ class "start-btn"
                        , onClick StartChat
                        , disabled (String.trim model.userName == "")
                        ]
                        [ text (startLabel model.language) ]
                    ]
                , div [ class "setup-footer" ]
                    [ a [ href "https://github.com/ratopi/eliza.elm"
                        , Html.Attributes.target "_blank"
                        , Html.Attributes.rel "noopener noreferrer"
                        ]
                        [ githubIcon
                        , text "GitHub"
                        ]
                    ]
                ]
            ]
        ]


setupSubtitle : Language -> String
setupSubtitle lang =
    case lang of
        English ->
            "Your virtual therapist"

        German ->
            "Ihre virtuelle Therapeutin"


nameLabel : Language -> String
nameLabel lang =
    case lang of
        English ->
            "Your name"

        German ->
            "Ihr Name"


namePlaceholder : Language -> String
namePlaceholder lang =
    case lang of
        English ->
            "Enter your name..."

        German ->
            "Geben Sie Ihren Namen ein..."


startLabel : Language -> String
startLabel lang =
    case lang of
        English ->
            "Start Conversation"

        German ->
            "Gespräch starten"


-- CHAT VIEW

viewChatScreen : Model -> Html Msg
viewChatScreen model =
    div [ class "app-container" ]
        [ viewHeader model.language model.userName
        , viewChat model.messages
        , viewInput model.inputText model.language
        ]


viewHeader : Language -> String -> Html Msg
viewHeader currentLang userName =
    header [ class "app-header" ]
        [ div [ class "header-content" ]
            [ h1 [] [ text "ELIZA" ]
            , p [ class "subtitle" ]
                [ text (headerSubtitle currentLang userName) ]
            ]
        , a [ class "github-link"
            , href "https://github.com/ratopi/eliza.elm"
            , Html.Attributes.target "_blank"
            , Html.Attributes.rel "noopener noreferrer"
            ]
            [ githubIcon
            , text "GitHub"
            ]
        ]


headerSubtitle : Language -> String -> String
headerSubtitle lang name =
    case lang of
        English ->
            "Session with " ++ name

        German ->
            "Sitzung mit " ++ name


viewChat : List Message -> Html Msg
viewChat messages =
    div [ class "chat-container", id "chat-container" ]
        [ div [ class "chat-messages" ]
            (List.map viewMessage messages)
        ]


viewMessage : Message -> Html Msg
viewMessage message =
    let
        ( senderClass, senderLabel ) =
            case message.sender of
                User ->
                    ( "user-message", "" )

                Eliza ->
                    ( "eliza-message", "Eliza" )
    in
    div [ class ("message " ++ senderClass) ]
        [ div [ class "message-bubble" ]
            [ if senderLabel /= "" then
                span [ class "sender-label" ] [ text senderLabel ]
              else
                text ""
            , p [] [ text message.text ]
            ]
        ]


viewInput : String -> Language -> Html Msg
viewInput currentInput lang =
    let
        placeholderText =
            case lang of
                English ->
                    "Type your message..."

                German ->
                    "Schreiben Sie Ihre Nachricht..."

        sendLabel =
            case lang of
                English ->
                    "Send"

                German ->
                    "Senden"
    in
    div [ class "input-container" ]
        [ div [ class "input-wrapper" ]
            [ input
                [ type_ "text"
                , class "message-input"
                , placeholder placeholderText
                , value currentInput
                , onInput UpdateInput
                , onEnter SendMessage
                ]
                []
            , button
                [ class "send-btn"
                , onClick SendMessage
                ]
                [ text sendLabel ]
            ]
        ]


onEnter : Msg -> Attribute Msg
onEnter msg =
    on "keydown"
        (Decode.field "key" Decode.string
            |> Decode.andThen
                (\key ->
                    if key == "Enter" then
                        Decode.succeed msg
                    else
                        Decode.fail "not Enter"
                )
        )


{-| GitHub Octicon SVG icon.
-}
githubIcon : Html msg
githubIcon =
    svg
        [ SvgAttr.viewBox "0 0 16 16"
        , SvgAttr.width "16"
        , SvgAttr.height "16"
        ]
        [ Svg.path
            [ SvgAttr.d "M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"
            , SvgAttr.fill "currentColor"
            ]
            []
        ]

