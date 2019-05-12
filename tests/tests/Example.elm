module Example exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Lib


suite : Test
suite =
    test "it wokrs" <|
        \() ->
            Lib.fn ()
                |> Expect.equal 42
