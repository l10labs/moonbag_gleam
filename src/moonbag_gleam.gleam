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
    HomeView, PlayerStartGame ->
      ty.init_game()
      // |> ty.enable_shuffle
      |> GameView
    LoseView(_), PlayerStartGame -> ty.init_game() |> GameView
    GameView(game), PlayerPullOrb ->
      game
      |> ty.pull_orb
      |> ty.update_view
    WinView(game), PlayerVisitMarket ->
      game
      |> ty.reward_credits
      |> MarketView
    MarketView(game), PlayerBuyItem(item) ->
      ty.buy_market_item(game, item)
      |> MarketView
    MarketView(game), PlayerNextRound ->
      game
      |> ty.reset_for_next_round
      // |> ty.enable_shuffle
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
