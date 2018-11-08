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


rawJson =
    -- """6"""
    -- """"hello\""""
    """null"""


type alias Model =
    { json : String

    -- , parsed : Result D.Error Int
    -- , parsed : Result D.Error String
    , parsed : Result D.Error (Maybe String)
    }



-- """6"""
-- decode : String -> Result D.Error Int
-- decode json =
--     D.decodeString D.int json
-- """"hello\""""
-- decode : String -> Result D.Error String
-- decode json =
--     D.decodeString D.string json
-- """null"""


decode : String -> Result D.Error (Maybe String)
decode json =
    D.decodeString (D.nullable D.string) json


init =
    { json = rawJson
    , parsed = decode rawJson
    }


type Msg
    = Hello


update : Msg -> Model -> Model
update msg model =
    model



-- """6"""
-- renderParsed : Result D.Error Int -> Html Msg
-- """"hello\""""
-- renderParsed : Result D.Error String -> Html Msg


renderParsed : Result D.Error (Maybe String) -> Html Msg
renderParsed result =
    case result of
        Result.Err decodeError ->
            div [] [ text (D.errorToString decodeError) ]

        Result.Ok value ->
            -- div [] [ text (String.fromInt value) ]
            case value of
                Nothing ->
                    div [] [ text "it was null" ]

                Just str ->
                    div [] [ text str ]


view : Model -> Html Msg
view model =
    div []
        [ pre [] [ text model.json ]
        , renderParsed model.parsed
        ]
