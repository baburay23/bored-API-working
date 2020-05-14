module Example exposing (..)

import Expect
import Json.Decode exposing (Decoder, field, string)
import Main exposing (activityDecoder)
import String
import Test exposing (..)


runActivityDecoder json =
    Json.Decode.decodeString
        Main.activityDecoder
        json


decodesBoredApi : Test
decodesBoredApi =
    test "Properly decodes the bored activity string" <|
        \() ->
            let
                input =
                    """
                     {    activity: "" 
                        , accessibility : 0.0 
                        , type_ : "" 
                        , participants : 0
                        , price : 0.0
                        , link : "" 
                        , key : "" 
                        }
                    """

                decodedOutput =
                    runActivityDecoder input
            in
            Expect.equal decodedOutput
                (Ok
                    { name = ""
                    , accessibility = 0.0
                    , type_ = ""
                    , participants = 0
                    , price = 0.0
                    , link = ""
                    , key = ""
                    }
                )
