module Main exposing (main)

import Browser
import Html exposing (..)
import Json.Decode as D


{-
   "{"type":"update-game","board":[[null,null,null],[null,"X",null],[null,"O","X"]],"yourTurn":true,"you":"O"}"

   Row : List String

   Board : List Row

   message : { type: String , board: Board }

-}


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


rawJson =
    -- """{ "name": "Bender", "ints": [1,null,3] }"""
    """[[null,null,null],[null,"X",null],[null,"O","X"]]"""


nullableInt : D.Decoder Int
nullableInt =
    D.oneOf
        [ D.int
        , D.null 0
        ]


type alias ListOfInts =
    List Int


type alias ListOfStrings =
    List String


type alias Row =
    ListOfStrings


type alias Board =
    List Row


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
    , parsed : Result D.Error Board
    }


robotDecoder : D.Decoder Robot
robotDecoder =
    D.map2 Robot
        listOfIntsDecoder
        nameDecoder


nullableString : D.Decoder String
nullableString =
    D.oneOf
        [ D.string
        , D.null "?"
        ]


rowDecoder : D.Decoder Row
rowDecoder =
    D.list nullableString


boardDecoder : D.Decoder Board
boardDecoder =
    D.list rowDecoder


decode : String -> Result D.Error Robot
decode json =
    D.decodeString robotDecoder json


decodeRowFromJson : String -> Result D.Error Row
decodeRowFromJson json =
    D.decodeString rowDecoder json


decodeBoardFromJson : String -> Result D.Error Board
decodeBoardFromJson json =
    D.decodeString boardDecoder json


init =
    { json = rawJson
    , parsed = decodeBoardFromJson rawJson
    }


type Msg
    = Hello


update : Msg -> Model -> Model
update msg model =
    model


renderDecodeError : D.Error -> Html Msg
renderDecodeError decodeError =
    div [] [ text (D.errorToString decodeError) ]


renderParsedRobot : Result D.Error Robot -> Html Msg
renderParsedRobot result =
    case result of
        Result.Err decodeError ->
            renderDecodeError decodeError

        Result.Ok robot ->
            div []
                [ div [] [ text ("name: " ++ robot.name) ]
                , ul [] (List.map renderInt robot.ints)
                ]


renderCell : String -> Html Msg
renderCell str =
    case str of
        "X" ->
            span [] [ text "X" ]

        "O" ->
            span [] [ text "O" ]

        _ ->
            span [] [ text "_" ]


renderRow : Row -> Html Msg
renderRow row =
    div [] (List.map renderCell row)


renderBoard : List Row -> Html Msg
renderBoard rowList =
    div [] (List.map renderRow rowList)


renderParsedBoard : Result D.Error Board -> Html Msg
renderParsedBoard result =
    case result of
        Result.Err decodeError ->
            renderDecodeError decodeError

        Result.Ok board ->
            renderBoard board


view : Model -> Html Msg
view model =
    div []
        [ pre [] [ text model.json ]
        , renderParsedBoard model.parsed
        ]
