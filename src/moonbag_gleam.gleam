import lustre
import lustre/element.{type Element}
import msg.{
  type Msg, PlayerBuyItem, PlayerNextRound, PlayerPullOrb, PlayerStartGame,
  PlayerVisitMarket,
}
import ty.{
  type FrontendViews, ErrorView, GameView, HomeView, LoseView, MarketView,
  WinView,
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

fn update(model: Model, message: Msg) -> Model {
  case model, message {
    HomeView, PlayerStartGame -> ty.init_game() |> GameView
    LoseView(_), PlayerStartGame -> ty.init_game() |> GameView
    GameView(game), PlayerPullOrb ->
      game
      |> ty.handle_game_state_transitions
      |> ty.handle_frontend_view_transitions
    WinView(game), PlayerVisitMarket ->
      game
      |> ty.update_credits
      |> MarketView
    MarketView(game), PlayerBuyItem(item) ->
      ty.buy_orb(game, item)
      |> MarketView
    MarketView(game), PlayerNextRound ->
      game
      |> ty.reset_for_next_round
      |> GameView
    _, _ -> ErrorView
  }
}

fn view(model: Model) -> Element(Msg) {
  case model {
    HomeView -> views.home()
    GameView(game) -> game |> views.game
    WinView(_) -> views.win()
    LoseView(_) -> views.lose()
    MarketView(game) -> game |> views.market
    ErrorView -> views.error()
  }
}
