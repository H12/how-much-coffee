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
    | Press


brewToString : Maybe Brew -> String
brewToString brew =
    case brew of
        Just Drip ->
            "Drip"

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
    , yield = 3.0
    }


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
            ( strength * yield * 15, yield * 250 )

        Press ->
            ( strength * yield * 18, yield * 250 )


gramsCoffee : ( Float, Float ) -> String
gramsCoffee amounts =
    String.fromInt (round <| Tuple.first amounts) ++ " grams of coffee"


gramsWater : ( Float, Float ) -> String
gramsWater amounts =
    String.fromInt (round <| Tuple.second amounts) ++ " grams of water"



-- VIEW


view : Model -> Html Msg
view model =
    layout
        [ Background.color creme]
        (pageLayout model)


pageLayout : Model -> Element Msg
pageLayout model =
    column [ centerX, padding 10, spacing 30, width <| px 360 ]
        [ brewSelect model.selectedBrew
        , strengthSlider model.strength
        , yieldSlider model.yield
        , el [ centerX ] (text (gramsCoffee (amount model.selectedBrew model.strength model.yield)))
        , el [ centerX ] (text (gramsWater (amount model.selectedBrew model.strength model.yield)))
        ]


brewSelect : Brew -> Element Msg
brewSelect selectedBrew =
    row [ width fill, paddingXY 32 16, spaceEvenly ]
        [ brewButton (selectedBrew == Drip) Drip
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
        [ height (px 30)
        , behindContent
            (el
                [ width fill
                , height (px 2)
                , centerY
                , Background.color brown
                , Border.rounded 3
                ]
                none
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
        [ height (px 30)
        , behindContent
            (el
                [ width fill
                , height (px 2)
                , centerY
                , Background.color brown
                , Border.rounded 3
                ]
                none
            )
        ]
        { onChange = SelectYield
        , label = Input.labelAbove [] (text ("Yield: " ++ String.fromFloat yield ++ " servings"))
        , min = 1
        , max = 5
        , step = Just 0.1
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
    , height (px 54)
    , width (px 92)
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
