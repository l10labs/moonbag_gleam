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
  let init_orb_bag =
    [
      build_orb(Point, 1, times: 4),
      build_orb(Point, 2, times: 4),
      build_orb(Point, 3, times: 2),
      build_orb(Bomb, 1, times: 3),
      build_orb(Bomb, 2, times: 2),
    ]
    |> list.fold([], list.append)

  init_orb_bag
}

pub fn build_orb(
  orb_type: fn(Int) -> Orb,
  value: Int,
  times quantity: Int,
) -> List(Orb) {
  list.repeat(orb_type(value), quantity)
}

pub fn pull_orb(game_state: GameState) -> GameState {
  let #(first_orb, new_bag_in) = case game_state.orb_bag_in {
    [] -> panic
    [first, ..rest] -> #(first, rest)
  }

  let orb_bag_in = new_bag_in
  let orb_bag_out = game_state.orb_bag_out |> list.append([first_orb])

  let #(health, points) = case first_orb {
    Bomb(damage) -> #(game_state.health - damage, game_state.points)
    Empty -> #(game_state.health, game_state.points)
    Point(amount) -> #(game_state.health, game_state.points + amount)
  }

  GameState(..game_state, health:, points:, orb_bag_in:, orb_bag_out:)
}

pub fn next_level(game_state: GameState) -> GameState {
  let init_game_state = init_gamestate()
  GameState(
    ..init_game_state,
    level: game_state.level + 1,
    cheddah: game_state.points,
    milestone: init_game_state.milestone + game_state.milestone,
  )
}

pub type Msg {
  PlayerStartGame
  PlayerPullOrb
  PlayerNextLevel
}
