module Tests exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Main"
        [ describe "Main.brewToString"
            [ testBrewString Drip "Drip"
            , testBrewString Pour "Pour"
            , testBrewString Press "Press"
            , test "returns empty string when passed Nothing" <|
                \_ ->
                    Nothing
                        |> Main.brewToString
                        |> Expect.equal ""
            ]
        ]


testBrewString : Brew -> String -> Test
testBrewString brewType brewString =
    test ("returns the String '" ++ brewString ++ "' for its given Brew") <|
        \_ ->
            Just brewType
                |> brewToString
                |> Expect.equal brewString
