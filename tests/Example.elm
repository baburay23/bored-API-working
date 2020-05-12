module Example exposing (..)

import Expect
import Json.Decode exposing (Decoder, field, string)
import Main exposing (gifDecoder)
import String
import Test exposing (..)



--runGifDecoder : Decoder gifDecoder -> String -> Result String gifDecoder


runGifDecoder json =
    Json.Decode.decodeString
        Main.gifDecoder
        json


decodesBoredGif : Test
decodesBoredGif =
    test "Properly decodes the bored activity string" <|
        \() ->
            let
                input =
                    """
                     { "activity":"Learn how to play a new sport" }
                    """

                decodedOutput =
                    runGifDecoder input
            in
            Expect.equal decodedOutput
                (Ok
                    "Learn how to play a new sport"
                 --activity = "Learn how to play a new sport"
                )
