module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Attribute, Html, button, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = init, update = update, view = view }


type Brew
    = Cold
    | Drip
    | Press


toString : Maybe Brew -> String
toString brew =
    case brew of
        Just Cold ->
            "Cold"

        Just Drip ->
            "Drip"

        Just Press ->
            "Press"

        Nothing ->
            ""


type alias Model =
    { selectedBrew : Maybe Brew
    }


init : Model
init =
    { selectedBrew = Nothing }


type Msg
    = Select Brew


update : Msg -> Model -> Model
update msg model =
    case msg of
        Select newBrew ->
            { model | selectedBrew = Just newBrew }


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ div [ onClick (Select Cold) ] [ text <| toString (Just Cold) ]
            , div [ onClick (Select Drip) ] [ text <| toString (Just Drip) ]
            , div [ onClick (Select Press) ] [ text <| toString (Just Press) ]
            ]
        , div [] [ text (toString model.selectedBrew) ]
        ]
