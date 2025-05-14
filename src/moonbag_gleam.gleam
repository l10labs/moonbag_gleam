import lustre
import lustre/element.{type Element}
import msg.{type Msg}
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

fn update(model: Model, msg: Msg) -> Model {
  case model, msg {
    HomeView, msg.PlayerStartGame -> GameView(ty.init_game())
    LoseView(_), msg.PlayerStartGame -> GameView(ty.init_game())
    GameView(game), msg.PlayerPullOrb ->
      game
      |> ty.handle_game_state_transitions
      |> ty.handle_frontend_view_transitions
    WinView(game), msg.PlayerVisitMarket ->
      game
      |> ty.update_credits
      |> MarketView
    MarketView(game), msg.PlayerBuyItem(item) ->
      ty.buy_orb(game, item)
      |> MarketView
    MarketView(game), msg.PlayerNextRound ->
      game
      |> ty.reset_for_next_round
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
