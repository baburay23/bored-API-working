module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (id)
import Html.Events exposing (onInput)
import Http exposing (Error(..))
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Activity =
    { name : String
    , accessibility : Maybe Float
    , type_ : String
    , participants : Int
    , price : Maybe Float
    , link : String
    , key : String
    }


type alias Model =
    { randomActivity : Result Error (Maybe Activity)
    , chosenActivity : Result Error (Maybe Activity)
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (Ok Nothing) (Ok Nothing), getRandomIdea )


activityTypes =
    [ "cooking", "charity", "education", "relaxation", "music" ]



-- UPDATE


type Msg
    = ChosenIdea (Result Error Activity)
    | RandomIdea (Result Error Activity)
    | TypeSelected String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChosenIdea result ->
            case result of
                Ok a ->
                    ( { model | chosenActivity = Ok (Just a) }, Cmd.none )

                Err e ->
                    ( { model | chosenActivity = Err e }, Cmd.none )

        RandomIdea result ->
            case result of
                Ok a ->
                    ( { model | randomActivity = Ok (Just a) }, Cmd.none )

                Err e ->
                    ( { model | randomActivity = Err e }, Cmd.none )

        TypeSelected string ->
            ( model, getChosenIdea string )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        optionView t =
            option [ id t ] [ text t ]
    in
    div []
        [ h2 [] [ text "Random idea for Boredom" ]
        , case model.randomActivity of
            Ok a ->
                ideaView a

            Err e ->
                errorView e
        , h2 [] [ text "Choose an idea" ]
        , select [ onInput TypeSelected ] (List.map optionView activityTypes)
        , case model.chosenActivity of
            Ok a ->
                ideaView a

            Err e ->
                errorView e
        ]


ideaView : Maybe Activity -> Html Msg
ideaView ma =
    case ma of
        Just a ->
            div
                []
                [ div [] [ text a.name ]
                ]

        Nothing ->
            div [] [ text "no activity" ]


errorView : Error -> Html Msg
errorView e =
    case e of
        BadUrl string ->
            div [] [ text string ]

        Timeout ->
            div [] [ text "timout" ]

        NetworkError ->
            div [] [ text "network error" ]

        BadStatus int ->
            div [] [ text "bad status" ]

        BadBody string ->
            div [] [ text string ]


getRandomIdea : Cmd Msg
getRandomIdea =
    Http.get
        { url = "http://www.boredapi.com/api/activity"
        , expect = Http.expectJson RandomIdea activityDecoder
        }


getChosenIdea : String -> Cmd Msg
getChosenIdea type_ =
    Http.get
        { url = "http://www.boredapi.com/api/activity?type=" ++ type_
        , expect = Http.expectJson ChosenIdea activityDecoder
        }


nothingDecoder : String -> Decoder (Maybe a)
nothingDecoder s =
    Decode.succeed Nothing


maybeFloatDecoder : Float -> Decoder (Maybe Float)
maybeFloatDecoder p =
    Decode.succeed (Just p)


activityDecoder : Decoder Activity
activityDecoder =
    Decode.succeed Activity
        |> Pipeline.required "activity" Decode.string
        |> Pipeline.required "accessibility"
            (Decode.oneOf
                [ Decode.string |> Decode.andThen nothingDecoder
                , Decode.float |> Decode.andThen maybeFloatDecoder
                ]
            )
        |> Pipeline.required "type" Decode.string
        |> Pipeline.required "participants" Decode.int
        |> Pipeline.required "price"
            (Decode.oneOf
                [ Decode.string |> Decode.andThen nothingDecoder
                , Decode.float |> Decode.andThen maybeFloatDecoder
                ]
            )
        |> Pipeline.required "link" Decode.string
        |> Pipeline.required "key" Decode.string
