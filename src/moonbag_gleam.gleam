import lustre
import lustre/element.{type Element}
import newtypes.{
  type FrontendViews, type Msg, ErrorView, GameView, HomeView, LoseView,
  MarketView, WinView,
}
import views

pub fn main() {
  let app = lustre.simple(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}

type Model =
  FrontendViews

fn init(_) -> Model {
  HomeView
}

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
      |> MarketView
    MarketView(game), newtypes.PlayerBuyItem(item) ->
      newtypes.buy_orb(game, item)
      |> MarketView
    MarketView(game), newtypes.PlayerNextRound ->
      game
      |> newtypes.reset_for_next_round
      |> GameView
    _, _ -> HomeView
  }
}

fn view(model: Model) -> Element(Msg) {
  case model {
    HomeView -> views.home()
    GameView(game) -> views.game(game)
    WinView(_) -> views.win()
    LoseView(_) -> views.lose()
    MarketView(game) -> views.market(game)
    ErrorView -> views.error()
  }
}
