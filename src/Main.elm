module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)



-- MAINelm


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL

type alias Model =
    { type_ : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
   ( getRandomIdea, Cmd.none)



-- UPDATE


type Msg
    = NewIdea
    | GetIdeaType
    | LoadedIdea --need this for the http request
    | Failure


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewIdea ->
            ( { model | type_ = type_ }, Cmd.none )
--this changes the idea each time something is inputted. a new record has to be produced each time.type alias recordName =
        GetIdeaType ->
            ( model, getRandomIdea model.type_ )
       
        LoadedIdea (ok loadedIdea) ->
          ({ loadedIdea | type_ = model.type_ }, Cmd.none)
        
        LoadedIdea (Err _) ->
            (model, Cmd.none)
  



-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- VIEW
view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Ideas for Boredom" ]
        , viewGif model
        ]



--you need to listen to the relevant input event and then use a command to make your http call with that value


viewIdea : Model -> Html Msg
viewIdea model =
    [ div []
        [ input
            [ value model.type_
            , placeholder "hello"
            ]
            []
        , button [ onClick GetIdeaType, style "display" "block" ] [ text "Give me specific Idea!" ]
        , span [] [ text model.type ]
        ]
    ]


getRandomIdea : Cmd Msg
getRandomIdea =
    Http.post
        { url = "http://www.boredapi.com/api/activity?type=:type"
        , body = Http.emptyBody
        , expect = Http.expectJson LoadedIdea () typeDecoder
        }


typeDecoder : String -> Decoder Model
typeDecoder type_ Model =
    map2 (Model type_)
       -- (field "type" string)
        (field "activity" string)
--I want to decode activity with a given type..
