// IMPORTS ---------------------------------------------------------------------

import lustre
import lustre/element.{type Element}
import models.{
  type GameState, type Msg, PlayerNextLevel, PlayerPullOrb, PlayerStartGame,
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
type Model {
  HomeScreen
  GameScreen(GameState)
}

/// The `init` function gets called when we first start our app. It sets the
/// initial state of the app.
///
fn init(_) -> Model {
  // models.init_gamestate()
  HomeScreen
}

// UPDATE ----------------------------------------------------------------------

/// The `update` function is called every time we receive a message from the
/// outside world. We get the message and the current state of the app, and we
/// use those to calculate the new state.
///
fn update(model: Model, msg: Msg) -> Model {
  case model, msg {
    HomeScreen, PlayerStartGame -> GameScreen(models.init_gamestate())
    GameScreen(game_state), PlayerPullOrb ->
      GameScreen(models.pull_orb(game_state))
    GameScreen(game_state), PlayerNextLevel -> {
      GameScreen(models.next_level(game_state))
    }
    HomeScreen, _ -> HomeScreen
    GameScreen(_), _ -> HomeScreen
  }
}

// VIEW ------------------------------------------------------------------------

/// The `view` function is called after every `update`. It takes the current
/// state of our application and renders it as an `Element`
///
fn view(model: Model) -> Element(Msg) {
  case model {
    HomeScreen -> views.home_screen_view()
    GameScreen(game_state) -> {
      case game_state.points, game_state.health {
        p, _ if p >= game_state.milestone -> {
          views.win_screen_view(game_state)
        }
        _, h if h <= 0 -> views.home_screen_view()
        _, _ -> views.game_state_view(game_state)
      }
    }
  }
}
