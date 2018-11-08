module Main exposing (main)

import Browser
import Html exposing (..)
import Json.Decode as D


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { debugMessage : Maybe String
    , json : String
    , parsed : Result D.Error Int
    }


decode : String -> Result D.Error Int
decode json =
    D.decodeString D.int json


rawJson =
    """6"""


init =
    { debugMessage = Nothing

    -- , json = """[[null,null,"X"],[null,"O",null],[null,null,null]]"""
    -- , json = """[1, 2, 3]"""
    , json = rawJson
    , parsed = decode rawJson
    }


type Msg
    = Hello


update : Msg -> Model -> Model
update msg model =
    model


renderDebugMessage : Maybe String -> Html Msg
renderDebugMessage debugMessage =
    case debugMessage of
        Nothing ->
            div [] []

        Just message ->
            div [] [ text message ]


renderParsed : Result D.Error Int -> Html Msg
renderParsed debugMessage =
    case debugMessage of
        Result.Err decodeError ->
            div [] []

        Result.Ok int ->
            div [] [ text (String.fromInt int) ]


view : Model -> Html Msg
view model =
    div []
        [ renderDebugMessage model.debugMessage
        , pre [] [ text model.json ]
        , renderParsed model.parsed
        ]
