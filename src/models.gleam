import gleam/int
import gleam/list
import gleam/string

pub type GameState {
  GameState(
    player_health: Int,
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
  let player_health = 0
  let points = 0
  let cheddah = 0
  let milestone = 10
  let orb_bag_in = init_orb_bag() |> list.shuffle
  let orb_bag_out = []

  GameState(
    player_health:,
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

pub type Msg {
  DoNothing
  UserStartGame
}
