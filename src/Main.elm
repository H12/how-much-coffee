module Main exposing
    ( Model
    , Msg(..)
    , init
    , main
    , update
    , view
    )

import Browser
import Element
    exposing
        ( Attribute
        , Color
        , Element
        , centerX
        , centerY
        , el
        , fill
        , height
        , px
        , rgb255
        , row
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)


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
    Element.layout []
        (brewSelect model.selectedBrew)


brewSelect : Maybe Brew -> Element Msg
brewSelect selectedBrew =
    row [ width fill, spacing 30 ]
        [ brewButton (selectedBrew == Just Cold) Cold
        , brewButton (selectedBrew == Just Drip) Drip
        , brewButton (selectedBrew == Just Press) Press
        ]


brewButton : Bool -> Brew -> Element Msg
brewButton selected brew =
    Input.button
        (statusAttrs selected)
        { onPress = Just (Select brew)
        , label = el trueCenter (text (toString (Just brew)))
        }


trueCenter : List (Attribute Msg)
trueCenter =
    [ centerX, centerY ]


statusAttrs : Bool -> List (Attribute Msg)
statusAttrs isActive =
    [ Background.color (ternary isActive brown creme)
    , Font.color (ternary isActive creme brown)
    , Border.color brown
    , Border.width 2
    , Border.rounded 5
    , height (px 42)
    , width (px 68)
    ]


brown : Color
brown =
    rgb255 128 78 73


creme : Color
creme =
    rgb255 251 250 248


ternary : Bool -> a -> a -> a
ternary isTrue opt1 opt2 =
    if isTrue then
        opt1
    else
        opt2
