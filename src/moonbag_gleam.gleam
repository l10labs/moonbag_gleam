// IMPORTS ---------------------------------------------------------------------

import lustre
import lustre/element.{type Element}
import newtypes.{
  type FrontendViews, type Msg, ErrorView, GameView, HomeView, LoseView,
  MarketView, WinView,
}
import views

// MAIN ------------------------------------------------------------------------

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

// MODEL -----------------------------------------------------------------------

/// The `Model` is the state of our entire application.
///
type Model =
  FrontendViews

/// The `init` function gets called when we first start our app. It sets the
/// initial state of the app.
///
fn init(_) -> Model {
  HomeView
}

// UPDATE ----------------------------------------------------------------------

/// The `update` function is called every time we receive a message from the
/// outside world. We get the message and the current state of the app, and we
/// use those to calculate the new state.
///
fn update(model: Model, msg: Msg) -> Model {
  case model, msg {
    HomeView, newtypes.PlayerStartGame -> GameView(newtypes.init_game())
    LoseView(_), newtypes.PlayerStartGame -> GameView(newtypes.init_game())
    GameView(game), newtypes.PlayerPullOrb ->
      game
      |> newtypes.handle_game_state_transitions
      |> newtypes.handle_frontend_view_transitions
    WinView(game), newtypes.PlayerVisitMarket ->
      game
      |> newtypes.update_credits
      |> newtypes.reset_for_next_round
      |> MarketView
    MarketView(game), newtypes.PlayerBuyItem(item) ->
      newtypes.buy_orb(game, item) |> MarketView
    MarketView(game), newtypes.PlayerNextRound -> game |> GameView
    _, _ -> HomeView
  }
}

// VIEW ------------------------------------------------------------------------

/// The `view` function is called after every `update`. It takes the current
/// state of our application and renders it as an `Element`
///
fn view(model: Model) -> Element(Msg) {
  case model {
    HomeView -> views.home()
    GameView(game) -> views.game(game)
    WinView(_) -> views.win()
    LoseView(_) -> views.lose()
    MarketView(game) -> views.market(game)
    ErrorView -> views.error()
  }
  // case model {
  //   HomePage -> views.home_screen_view()
  //   GamePage(game_state) -> {
  //     case game_state.points, game_state.health {
  //       p, _ if p >= game_state.milestone -> {
  //         views.win_screen_view(game_state)
  //       }
  //       _, h if h <= 0 -> views.lose_screen_view()
  //       _, _ -> views.game_state_view(game_state)
  //     }
  //   }
  // }
}
