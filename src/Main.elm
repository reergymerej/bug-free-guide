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
    """[1,null,3]"""


nullableInt : D.Decoder Int
nullableInt =
    D.oneOf
        [ D.int
        , D.null 0
        ]


type alias Model =
    { json : String
    , parsed : Result D.Error (List Int)
    }


decode : String -> Result D.Error (List Int)
decode json =
    D.decodeString (D.list nullableInt) json


init =
    { json = rawJson
    , parsed = decode rawJson
    }


type Msg
    = Hello


update : Msg -> Model -> Model
update msg model =
    model


renderItem : Int -> Html Msg
renderItem int =
    div [] [ text (String.fromInt int) ]


renderParsed : Result D.Error (List Int) -> Html Msg
renderParsed result =
    case result of
        Result.Err decodeError ->
            div [] [ text (D.errorToString decodeError) ]

        Result.Ok value ->
            div []
                [ div [] [ text (String.fromInt (List.length value)) ]
                , div [] (List.map renderItem value)
                ]


view : Model -> Html Msg
view model =
    div []
        [ pre [] [ text model.json ]
        , renderParsed model.parsed
        ]
