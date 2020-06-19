module Test.Generated.Main4202318156 exposing (main)

import Example

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "Example" [Example.decodesBoredGif] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 287760362292023, processes = 8, paths = ["/Users/ababur/Desktop/learning/bored-API-working/tests/Example.elm"]}