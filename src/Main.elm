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
    """{ "name": "Bender", "ints": [1,null,3] }"""


nullableInt : D.Decoder Int
nullableInt =
    D.oneOf
        [ D.int
        , D.null 0
        ]


type alias ListOfInts =
    List Int


type alias Robot =
    { ints : ListOfInts
    , name : String
    }


nameDecoder : D.Decoder String
nameDecoder =
    D.field "name" D.string


listOfIntsDecoder : D.Decoder ListOfInts
listOfIntsDecoder =
    D.field "ints" (D.list nullableInt)


type alias Model =
    { json : String
    , parsed : Result D.Error Robot
    }


robotDecoder : D.Decoder Robot
robotDecoder =
    D.map2 Robot
        listOfIntsDecoder
        nameDecoder


decode : String -> Result D.Error Robot
decode json =
    D.decodeString robotDecoder json


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
    li [] [ text (String.fromInt int) ]


renderParsed : Result D.Error Robot -> Html Msg
renderParsed result =
    case result of
        Result.Err decodeError ->
            div [] [ text (D.errorToString decodeError) ]

        Result.Ok robot ->
            div []
                [ div [] [ text ("name: " ++ robot.name) ]
                , ul [] (List.map renderItem robot.ints)
                ]


view : Model -> Html Msg
view model =
    div []
        [ pre [] [ text model.json ]
        , renderParsed model.parsed
        ]
