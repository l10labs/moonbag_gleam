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
  HomePage
  GamePage(GameState)
}

/// The `init` function gets called when we first start our app. It sets the
/// initial state of the app.
///
fn init(_) -> Model {
  // models.init_gamestate()
  HomePage
}

// UPDATE ----------------------------------------------------------------------

/// The `update` function is called every time we receive a message from the
/// outside world. We get the message and the current state of the app, and we
/// use those to calculate the new state.
///
fn update(model: Model, msg: Msg) -> Model {
  case model, msg {
    HomePage, PlayerStartGame -> GamePage(models.init_gamestate())
    GamePage(game_state), PlayerPullOrb -> GamePage(models.pull_orb(game_state))
    GamePage(game_state), PlayerNextLevel -> {
      GamePage(models.next_level(game_state))
    }
    GamePage(_), PlayerStartGame -> GamePage(models.init_gamestate())
    HomePage, _ -> HomePage
  }
}

// VIEW ------------------------------------------------------------------------

/// The `view` function is called after every `update`. It takes the current
/// state of our application and renders it as an `Element`
///
fn view(model: Model) -> Element(Msg) {
  case model {
    HomePage -> views.home_screen_view()
    GamePage(game_state) -> {
      case game_state.points, game_state.health {
        p, _ if p >= game_state.milestone -> {
          views.win_screen_view(game_state)
        }
        _, h if h <= 0 -> views.lose_screen_view()
        _, _ -> views.game_state_view(game_state)
      }
    }
  }
}
