module Tests exposing (suite)

import Expect
import Main exposing (Brew(..))
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Main"
        [ describe "Main.brewToString"
            [ testBrewString Drip "Drip"
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
                |> Main.brewToString
                |> Expect.equal brewString
