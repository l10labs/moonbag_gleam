// IMPORTS ---------------------------------------------------------------------

import lustre
import lustre/element.{type Element}
import models.{type GameState, type Msg, DoNothing, UserStartGame}
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
  case msg {
    DoNothing -> model
    UserStartGame -> GameScreen(models.init_gamestate())
  }
}

// VIEW ------------------------------------------------------------------------

/// The `view` function is called after every `update`. It takes the current
/// state of our application and renders it as an `Element`
///
fn view(model: Model) -> Element(Msg) {
  case model {
    HomeScreen -> views.home_screen_view()
    GameScreen(game_state) -> views.game_state_view(game_state)
  }
}
