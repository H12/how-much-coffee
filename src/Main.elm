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
import Element
    exposing
        ( Attribute
        , Color
        , Element
        , alignRight
        , behindContent
        , centerX
        , centerY
        , column
        , el
        , fill
        , fillPortion
        , focusStyle
        , fromRgb
        , height
        , image
        , layoutWith
        , none
        , padding
        , paddingXY
        , px
        , rgb255
        , row
        , spaceEvenly
        , spacing
        , text
        , toRgb
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)


main : Program () Model Msg
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



-- MODEL


type alias Model =
    { selectedBrew : Brew
    , strength : Float
    , yield : Float
    }


init : Model
init =
    { selectedBrew = Drip
    , strength = 0.06
    , yield = 500
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


calculateAmounts : Brew -> Float -> Float -> ( Float, Float )
calculateAmounts brewType strength yield =
    ( calculateGramsCoffee brewType strength yield
    , calculateGramsWater brewType strength yield
    )


calculateGramsCoffee : Brew -> Float -> Float -> Float
calculateGramsCoffee brewType strength yield =
    case brewType of
        Drip ->
            strength * calculateGramsWater brewType strength yield

        Press ->
            pressStrengthFromDrip strength * calculateGramsWater brewType strength yield


calculateGramsWater : Brew -> Float -> Float -> Float
calculateGramsWater brewType strength yield =
    case brewType of
        Drip ->
            yield / (1 - 2.25 * strength)

        Press ->
            yield / (1 - 2.25 * pressStrengthFromDrip strength)


pressStrengthFromDrip : Float -> Float
pressStrengthFromDrip dripStrength =
    dripStrength * 17 / 14



-- VIEW


view : Model -> Html Msg
view model =
    layoutWith
        { options =
            [ focusStyle
                { borderColor = Nothing
                , backgroundColor = Nothing
                , shadow = Nothing
                }
            ]
        }
        [ Background.color creme ]
        (pageLayout model)


pageLayout : Model -> Element Msg
pageLayout model =
    column [ centerX, height fill ]
        [ el [ centerY, height <| fillPortion 20 ] (calculator model)
        , el
            [ Font.color (darken3 creme)
            , Font.size 12
            , Font.family [ Font.monospace ]
            , centerX
            , height <| fillPortion 1
            ]
            (text "Iconography courtesy of stockio")
        ]


calculator : Model -> Element Msg
calculator model =
    column
        [ centerX, centerY, padding 10, spacing 30, width <| px 320 ]
        [ brewSelect model.selectedBrew
        , strengthSlider model.strength
        , yieldSlider model.yield
        , coffeeResults <| calculateAmounts model.selectedBrew model.strength model.yield
        ]


brewSelect : Brew -> Element Msg
brewSelect selectedBrew =
    row [ width fill, paddingXY 32 16, spaceEvenly ]
        [ brewButton (selectedBrew == Drip) Drip
        , brewButton (selectedBrew == Press) Press
        ]


strengthSlider : Float -> Element Msg
strengthSlider strength =
    Input.slider
        [ height (px 30), sliderTrack ]
        { onChange = SelectStrength
        , label = Input.labelAbove sliderLabelAttrs (strengthLabel strength)
        , min = 0.045
        , max = 0.075
        , step = Nothing
        , value = strength
        , thumb = sliderThumb
        }


strengthLabel : Float -> Element Msg
strengthLabel strength =
    row
        [ spaceEvenly, width fill ]
        [ text "Strength:"
        , text (strengthString strength)
        ]


strengthString : Float -> String
strengthString strength =
    if strength > 0.065 then
        "Strong"

    else if strength > 0.055 then
        "Normal"

    else
        "Weak"


yieldSlider : Float -> Element Msg
yieldSlider yield =
    Input.slider
        [ height (px 30)
        , sliderTrack
        ]
        { onChange = SelectYield
        , label = Input.labelAbove sliderLabelAttrs (yieldLabel yield)
        , min = 0
        , max = 1000
        , step = Just 5
        , value = yield
        , thumb =
            sliderThumb
        }


yieldLabel : Float -> Element msg
yieldLabel yield =
    row
        [ spaceEvenly, width fill ]
        [ text "Yield:"
        , text (yieldString yield ++ " mL")
        ]


yieldString : Float -> String
yieldString yield =
    let
        base =
            toFloat (truncate yield)

        remainder =
            yield - base
    in
    if remainder > 0.9375 then
        String.fromFloat (base + 1) ++ " "

    else if remainder > 0.8125 && remainder <= 0.9375 then
        String.fromFloat base ++ "⅞"

    else if remainder > 0.6875 && remainder <= 0.8125 then
        String.fromFloat base ++ "¾"

    else if remainder > 0.5625 && remainder <= 0.6875 then
        String.fromFloat base ++ "⅝"

    else if remainder > 0.4375 && remainder <= 0.5625 then
        String.fromFloat base ++ "½"

    else if remainder > 0.3125 && remainder <= 0.4375 then
        String.fromFloat base ++ "⅜"

    else if remainder > 0.1875 && remainder <= 0.3125 then
        String.fromFloat base ++ "¼"

    else if remainder > 0.0625 && remainder <= 0.1875 then
        String.fromFloat base ++ "⅛"

    else
        String.fromFloat base ++ ""


sliderLabelAttrs : List (Attribute Msg)
sliderLabelAttrs =
    [ Font.family
        [ Font.monospace ]
    ]


sliderTrack : Attribute msg
sliderTrack =
    behindContent
        (el
            [ width fill
            , height (px 12)
            , centerY
            , Background.color brown
            , Border.rounded 6
            , Border.width 2
            ]
            none
        )


sliderThumb : Input.Thumb
sliderThumb =
    Input.thumb
        (thumbSize 24
            ++ [ Background.color white
               , Border.color black
               ]
        )


thumbSize : Int -> List (Attribute Never)
thumbSize size =
    [ Border.width 2
    , Border.rounded size
    , height (px size)
    , width (px <| round (toFloat size * 1.618))
    ]


brewButton : Bool -> Brew -> Element Msg
brewButton selected brew =
    Input.button
        (statusAttrs selected)
        { onPress = Just (SelectBrew brew)
        , label = el [ centerX, centerY ] (brewImage brew 48)
        }


brewImage : Brew -> Int -> Element Msg
brewImage brew =
    case brew of
        Drip ->
            chemexSvg

        Press ->
            frenchPressSvg


chemexSvg : Int -> Element Msg
chemexSvg size =
    image
        [ height (px size)
        , width (px size)
        ]
        { src = "chemex.svg", description = "Percolation Brewing" }


frenchPressSvg : Int -> Element Msg
frenchPressSvg size =
    image
        [ height (px size)
        , width (px size)
        ]
        { src = "french-press.svg", description = "Immersion Brewing" }


statusAttrs : Bool -> List (Attribute Msg)
statusAttrs isActive =
    [ Background.color white
    , Border.color black
    , Border.widthEach
        { bottom = ternary isActive 2 5
        , left = 2
        , right = 2
        , top = 2
        }
    , Border.rounded 16
    , height (px <| ternary isActive 89 92)
    , width (px 72)
    ]


coffeeResults : ( Float, Float ) -> Element Msg
coffeeResults amountTuple =
    let
        ( gramsCoffee, gramsWater ) =
            amountTuple
    in
    column [ centerX, width fill ]
        [ formattedAmount gramsCoffee "g coffee"
        , formattedAmount gramsWater "g water"
        ]


formattedAmount : Float -> String -> Element Msg
formattedAmount amount label =
    row
        [ centerX, width fill ]
        [ amountText <| String.fromInt (round amount)
        , amountLabel label
        ]


amountText : String -> Element Msg
amountText amountString =
    el
        [ Border.color <| darken creme
        , Border.widthEach
            { bottom = 0
            , left = 0
            , right = 1
            , top = 0
            }
        , Font.family [ Font.monospace ]
        , Font.size 48
        , Font.extraLight
        , padding 8
        , width <| fillPortion 1
        ]
        (el [ alignRight ] <| text amountString)


amountLabel : String -> Element Msg
amountLabel labelText =
    el
        [ Font.family [ Font.monospace ]
        , padding 8
        , width <| fillPortion 1
        ]
        (text labelText)


black : Color
black =
    rgb255 5 4 2


brown : Color
brown =
    rgb255 111 69 42


creme : Color
creme =
    rgb255 231 222 205


white : Color
white =
    rgb255 251 250 248


darken3 : Color -> Color
darken3 color =
    darken (darken2 color)


darken2 : Color -> Color
darken2 color =
    darken (darken color)


darken : Color -> Color
darken color =
    let
        darkenFactor =
            0.75

        rgb =
            toRgb color
    in
    fromRgb <|
        { rgb
            | red = rgb.red * darkenFactor
            , green = rgb.green * darkenFactor
            , blue = rgb.green * darkenFactor
        }



-- UTILS


ternary : Bool -> a -> a -> a
ternary isTrue opt1 opt2 =
    if isTrue then
        opt1

    else
        opt2
