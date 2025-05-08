import gleam/int
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import models.{type GameState, type Msg, type Orb, Empty}

pub fn game_state_view(game_state: GameState) -> Element(Msg) {
  let health = game_state.player_health |> int.to_string
  let points = game_state.points |> int.to_string
  let cheddah = game_state.cheddah |> int.to_string
  let milestone = game_state.milestone |> int.to_string
  let orb_pull_view = game_state.orb_bag_in |> next_orb_pull_view
  // let orb_bag = game_state.orb_bag_in |> list.map(orb_view)

  html.div(
    [attribute.class("flex flex-col gaps-2 justify-center items-center")],
    [
      html.p([], [html.text("health: " <> health)]),
      html.p([], [html.text("points: " <> points)]),
      html.p([], [html.text("cheddah: " <> cheddah)]),
      html.p([], [html.text("milestone: " <> milestone)]),
      html.div([], [html.text("next orb pull: "), orb_pull_view]),
      // html.div([attribute.class("flex flex-col")], orb_bag),
    ],
  )
}

pub fn orb_view(orb: Orb) -> Element(Msg) {
  let orb_text = orb |> models.orb_to_string

  html.div([], [html.text(orb_text)])
}

pub fn next_orb_pull_view(orb_bag: List(Orb)) -> Element(Msg) {
  let result = orb_bag |> list.first
  let orb = case result {
    Error(_) -> Empty
    Ok(orb) -> orb
  }

  orb |> orb_view
}
