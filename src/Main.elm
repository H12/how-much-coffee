module Main exposing
    ( Brew(..)
    , Model
    , Msg(..)
    , brewToString
    , init
    , main
    , update
    , view
    )

import Browser
import Element exposing (..)
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


brewToString : Maybe Brew -> String
brewToString brew =
    case brew of
        Just Drip ->
            "Drip"

        Just Pour ->
            "Pour"

        Just Press ->
            "Press"

        Nothing ->
            ""



-- UNITS


type Units
    = Grams



-- MODEL


type alias Model =
    { selectedBrew : Brew
    , strength : Float
    , yield : Float
    }


init : Model
init =
    { selectedBrew = Drip
    , strength = 1.0
    , yield = 36.0
    }



-- UPDATE


type Msg
    = SelectBrew Brew
    | SelectYield Float
    | SelectStrength Float


update : Msg -> Model -> Model
update msg model =
    case msg of
        SelectBrew newBrew ->
            { model | selectedBrew = newBrew }

        SelectYield yield ->
            { model | yield = yield }

        SelectStrength strength ->
            { model | strength = strength }


amount : Brew -> Float -> Float -> ( Float, Float )
amount brewType strength yield =
    case brewType of
        Drip ->
            ( strength * yield * 1.875, yield * 31.25 )

        Pour ->
            ( strength * yield * 2.25, yield * 34.5 )

        Press ->
            ( strength * yield * 2.25, yield * 32.25 )


gramsCoffee : ( Float, Float ) -> String
gramsCoffee amounts =
    String.fromInt (round <| Tuple.first amounts) ++ " grams of coffee"


gramsWater : ( Float, Float ) -> String
gramsWater amounts =
    String.fromInt (round <| Tuple.second amounts) ++ " grams of water"



-- VIEW


view : Model -> Html Msg
view model =
    Element.layout [ Background.color creme ] (pageLayout model)


pageLayout : Model -> Element Msg
pageLayout model =
    column [ centerX, padding 10, spacing 30 ]
        [ brewSelect model.selectedBrew
        , strengthSlider model.strength
        , yieldSlider model.yield
        , el [ centerX ] (text (gramsCoffee (amount model.selectedBrew model.strength model.yield)))
        , el [ centerX ] (text (gramsWater (amount model.selectedBrew model.strength model.yield)))
        ]


brewSelect : Brew -> Element Msg
brewSelect selectedBrew =
    row [ width fill, spacing 30 ]
        [ brewButton (selectedBrew == Drip) Drip
        , brewButton (selectedBrew == Pour) Pour
        , brewButton (selectedBrew == Press) Press
        ]


strengthString : Float -> String
strengthString strength =
    if strength > 1.11 then
        "Strong"

    else if strength > 0.89 then
        "Normal"

    else
        "Weak"


strengthSlider : Float -> Element Msg
strengthSlider strength =
    Input.slider
        [ Element.height (Element.px 30)
        , Element.behindContent
            (Element.el
                [ width fill
                , height (Element.px 2)
                , centerY
                , Background.color brown
                , Border.rounded 3
                ]
                Element.none
            )
        ]
        { onChange = SelectStrength
        , label = Input.labelAbove [] (text ("Strength: " ++ strengthString strength))
        , min = 0.67
        , max = 1.33
        , step = Nothing
        , value = strength
        , thumb =
            Input.defaultThumb
        }


yieldSlider : Float -> Element Msg
yieldSlider yield =
    Input.slider
        [ Element.height (Element.px 30)
        , Element.behindContent
            (Element.el
                [ width fill
                , height (Element.px 2)
                , centerY
                , Background.color brown
                , Border.rounded 3
                ]
                Element.none
            )
        ]
        { onChange = SelectYield
        , label = Input.labelAbove [] (text ("Yield: " ++ String.fromFloat yield ++ " ounces"))
        , min = 8
        , max = 64
        , step = Just 1
        , value = yield
        , thumb =
            Input.defaultThumb
        }


brewButton : Bool -> Brew -> Element Msg
brewButton selected brew =
    Input.button
        (statusAttrs selected brown)
        { onPress = Just (SelectBrew brew)
        , label = el trueCenter (text (brewToString (Just brew)))
        }


yieldButton : Bool -> Float -> Element Msg
yieldButton selected yield =
    Input.button
        (statusAttrs selected blue)
        { onPress = Just (SelectYield yield)
        , label = el trueCenter (text (String.fromFloat yield))
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
