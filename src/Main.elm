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
        , column
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



-- BREW


type Brew
    = Drip
    | Pour
    | Press


toString : Maybe Brew -> String
toString brew =
    case brew of
        Just Drip ->
            "Drip"

        Just Pour ->
            "Pour"

        Just Press ->
            "Press"

        Nothing ->
            ""



-- MODEL


type alias Model =
    { selectedBrew : Maybe Brew
    , yield : Int
    }


init : Model
init =
    { selectedBrew = Nothing
    , yield = 0
    }



-- UPDATE


type Msg
    = SelectBrew Brew
    | SelectYield Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        SelectBrew newBrew ->
            { model | selectedBrew = Just newBrew }

        SelectYield numCups ->
            { model | yield = numCups }


amount : Maybe Brew -> Int -> ( Int, Int )
amount brewType yield =
    case brewType of
        Just Drip ->
            ( yield * 15, yield * 250 )

        Just Pour ->
            ( yield * 17, yield * 275 )

        Just Press ->
            ( yield * 17, yield * 257 )

        Nothing ->
            ( 0, 0 )


gramsCoffee : ( Int, Int ) -> String
gramsCoffee amounts =
    String.fromInt (Tuple.first amounts) ++ " grams of coffee"


gramsWater : ( Int, Int ) -> String
gramsWater amounts =
    String.fromInt (Tuple.second amounts) ++ " grams of water"



-- VIEW


view : Model -> Html Msg
view model =
    Element.layout [ Background.color creme ] (pageLayout model)


pageLayout : Model -> Element Msg
pageLayout model =
    column [ centerX, spacing 30 ]
        [ brewSelect model.selectedBrew
        , cupSelect model.yield
        , el [ centerX ] (text (gramsCoffee (amount model.selectedBrew model.yield)))
        , el [ centerX ] (text (gramsWater (amount model.selectedBrew model.yield)))
        ]


brewSelect : Maybe Brew -> Element Msg
brewSelect selectedBrew =
    row [ width fill, spacing 30 ]
        [ brewButton (selectedBrew == Just Drip) Drip
        , brewButton (selectedBrew == Just Pour) Pour
        , brewButton (selectedBrew == Just Press) Press
        ]


cupSelect : Int -> Element Msg
cupSelect numCups =
    row [ width fill, spacing 30 ]
        [ cupButton (numCups == 1) 1
        , cupButton (numCups == 2) 2
        , cupButton (numCups == 4) 4
        ]


brewButton : Bool -> Brew -> Element Msg
brewButton selected brew =
    Input.button
        (statusAttrs selected brown)
        { onPress = Just (SelectBrew brew)
        , label = el trueCenter (text (toString (Just brew)))
        }


cupButton : Bool -> Int -> Element Msg
cupButton selected numCups =
    Input.button
        (statusAttrs selected blue)
        { onPress = Just (SelectYield numCups)
        , label = el trueCenter (text (String.fromInt numCups))
        }


trueCenter : List (Attribute Msg)
trueCenter =
    [ centerX, centerY ]


statusAttrs : Bool -> Color -> List (Attribute Msg)
statusAttrs isActive color =
    [ Background.color (ternary isActive color white)
    , Font.color (ternary isActive white color)
    , Border.color color
    , Border.width 2
    , Border.rounded 5
    , height (px 42)
    , width (px 68)
    ]


blue : Color
blue =
    rgb255 125 132 178


brown : Color
brown =
    rgb255 128 78 73


creme : Color
creme =
    rgb255 231 222 205


white : Color
white =
    rgb255 251 250 248



-- UTILS


ternary : Bool -> a -> a -> a
ternary isTrue opt1 opt2 =
    if isTrue then
        opt1

    else
        opt2
