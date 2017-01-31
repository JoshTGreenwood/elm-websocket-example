module App exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import WebSocket exposing (listen, send)


type alias Model =
    { streamTime : Bool
    , time : String
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( { streamTime = False, time = "" }, Cmd.none )


type Msg
    = ToggleStreaming
    | Time String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleStreaming ->
            let
                newModel =
                    { model | streamTime = not model.streamTime }

                msg =
                    if newModel.streamTime then
                        "start"
                    else
                        "stop"
                cmd =
                    send websocketURL msg
            in
                ( newModel , cmd )

        Time newTime ->
            ( { model | time = newTime }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        toggleLabel =
            if model.streamTime then
                "Stop"
            else
                "Start"
    in
        div []
            [ button [ onClick ToggleStreaming ] [ text toggleLabel ]
            , br [] []
            , text model.time
            ]


websocketURL : String
websocketURL =
    "ws://localhost:3028"


subscriptions : Model -> Sub Msg
subscriptions model =
    listen websocketURL Time
