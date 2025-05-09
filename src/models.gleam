import gleam/int
import gleam/list
import gleam/string

pub type GameState {
  GameState(
    level: Int,
    health: Int,
    points: Int,
    cheddah: Int,
    milestone: Int,
    orb_bag_in: List(Orb),
    orb_bag_out: List(Orb),
  )
}

pub type Orb {
  Point(Int)
  Bomb(Int)
  Empty
}

pub fn orb_to_string(orb: Orb) -> String {
  case orb {
    Point(i) -> string.concat(["Point Orb of (", int.to_string(i), ")"])
    Bomb(i) -> string.concat(["Bomb Orb of (", int.to_string(i), ")"])
    Empty -> "Empty"
  }
}

pub fn init_gamestate() -> GameState {
  let level = 1
  let health = 5
  let points = 0
  let cheddah = 0
  let milestone = 10
  let orb_bag_in = init_orb_bag() |> list.shuffle
  let orb_bag_out = []

  GameState(
    level:,
    health:,
    points:,
    cheddah:,
    milestone:,
    orb_bag_in:,
    orb_bag_out:,
  )
}

pub fn init_orb_bag() -> List(Orb) {
  let orb_bag_in = [
    Point(1),
    Point(1),
    Point(1),
    Point(1),
    Point(2),
    Point(2),
    Point(2),
    Point(2),
    Point(3),
    Point(3),
    Bomb(1),
    Bomb(1),
    Bomb(1),
    Bomb(2),
    Bomb(2),
  ]

  orb_bag_in
}

pub fn pull_orb(game_state: GameState) -> GameState {
  let #(first_orb, new_bag_in) = case game_state.orb_bag_in {
    [] -> panic
    [first, ..rest] -> #(first, rest)
  }

  let orb_bag_in = new_bag_in
  let orb_bag_out = game_state.orb_bag_out |> list.append([first_orb])

  let #(health, points, cheddah) = case first_orb {
    Bomb(damage) -> #(
      game_state.health - damage,
      game_state.points,
      game_state.cheddah,
    )
    Empty -> #(game_state.health, game_state.points, game_state.cheddah)
    Point(amount) -> #(
      game_state.health,
      game_state.points + amount,
      game_state.cheddah + amount,
    )
  }

  GameState(..game_state, health:, points:, cheddah:, orb_bag_in:, orb_bag_out:)
}

pub type Msg {
  PlayerStartGame
  PlayerPullOrb
}
