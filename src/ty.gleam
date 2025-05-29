import gleam/int
import gleam/list
import gleam/option.{type Option}

pub type Player {
  Player(
    health: Health,
    points: Points,
    credits: Credits,
    last_played_orb: Orb,
    starter_orbs: OrbBag,
    purchased_orbs: OrbBag,
    curses: Curses,
  )
}

pub type Health {
  Health(value: Int)
}

pub type Points {
  Points(value: Int)
}

pub type Credits {
  Credits(value: Int)
}

pub type OrbBag {
  OrbBag(orbs: List(Orb))
}

pub type Orb {
  PointOrb(Int)
  BombOrb(Int)
  DoubleFuturePointsOrb
  EmptyOrb
}

pub type Curses {
  Curses(curses: List(Curse))
}

pub type Curse {
  NothingCurse
}

pub type Market {
  Market(items: List(#(Int, MarketItem)))
}

pub type MarketItem {
  MarketItem(item: Orb, price: Credits)
}

pub type Level {
  Level(current_level: Int, current_round: Int, milestone: Points)
}

pub type Game {
  Game(player: Player, level: Level, market: Market)
}

pub type FrontendViews {
  HomeView
  GameView(Game)
  MarketView(Game)
  WinView(Game)
  LoseView(Game)
  ErrorView
}

pub fn init_player() -> Player {
  Player(
    health: Health(5),
    points: Points(0),
    credits: Credits(0),
    last_played_orb: EmptyOrb,
    // starter_orbs: init_orbs() |> list.shuffle |> OrbBag,
    starter_orbs: init_starter_orbs() |> OrbBag,
    purchased_orbs: [] |> OrbBag,
    curses: [NothingCurse] |> Curses,
  )
}

fn init_starter_orbs() -> List(Orb) {
  [
    // build_orb(PointOrb(1), times: 4),
    // build_orb(PointOrb(2), times: 3),
    // build_orb(PointOrb(3), times: 2),
    // build_orb(BombOrb(1), times: 3),
    // build_orb(BombOrb(2), times: 2),
    build_orb(DoubleFuturePointsOrb, 1),
    build_orb(PointOrb(5), 2),
    build_orb(BombOrb(1), 3),
    build_orb(BombOrb(2), 2),
    build_orb(BombOrb(3), 1),
  ]
  |> list.flatten
}

fn build_orb(orb_type: Orb, times times: Int) -> List(Orb) {
  list.repeat(orb_type, times)
}

fn init_market_items() -> List(MarketItem) {
  [
    build_market_item(PointOrb(1), price: 2, times: 4),
    build_market_item(PointOrb(2), price: 5, times: 3),
    build_market_item(PointOrb(3), price: 8, times: 2),
    build_market_item(PointOrb(5), price: 20, times: 2),
    build_market_item(PointOrb(10), price: 50, times: 1),
  ]
  |> list.flatten
}

fn build_market_item(
  item: Orb,
  price price: Int,
  times times: Int,
) -> List(MarketItem) {
  build_orb(item, times)
  |> list.map(MarketItem(_, Credits(price)))
}

fn init_market() -> Market {
  init_market_items() |> list.index_map(fn(x, i) { #(i, x) }) |> Market
}

fn init_level() -> Level {
  Level(current_level: 1, current_round: 1, milestone: Points(10))
}

pub fn init_game() -> Game {
  Game(player: init_player(), market: init_market(), level: init_level())
}

pub fn orb_to_string(orb: Orb) -> String {
  case orb {
    BombOrb(value) -> value |> int.to_string <> "💣 "
    EmptyOrb -> ""
    PointOrb(value) -> value |> int.to_string <> "⭐"
    DoubleFuturePointsOrb -> "2x⭐"
  }
}

pub fn get_first_orb(orb_list: List(Orb)) -> Orb {
  case orb_list {
    [] -> EmptyOrb
    [first, ..] -> first
  }
}

fn get_remaining_orb_list(orb_list: List(Orb)) -> List(Orb) {
  case orb_list {
    [] -> []
    [_, ..rest] -> rest
  }
}

fn resolve_player_orb_pull(player: Player, orb: Orb) -> Player {
  let new_player = case orb {
    EmptyOrb -> player
    BombOrb(damage) ->
      Player(..player, health: Health(player.health.value - damage))
    PointOrb(points) ->
      Player(..player, points: Points(player.points.value + points))
    DoubleFuturePointsOrb -> {
      let new_bag =
        player.starter_orbs.orbs
        |> list.map(fn(b) {
          case b {
            PointOrb(value) -> PointOrb(2 * value)
            orb -> orb
          }
        })
      Player(..player, starter_orbs: OrbBag(new_bag))
    }
  }

  let new_orb_list = new_player.starter_orbs.orbs |> get_remaining_orb_list

  Player(
    ..new_player,
    last_played_orb: orb,
    starter_orbs: new_orb_list |> OrbBag,
  )
}

fn update_player_starter_orbs(player: Player, new_orb_list: List(Orb)) -> Player {
  Player(..player, starter_orbs: new_orb_list |> OrbBag)
}

pub fn pull_orb(game: Game) -> Game {
  let starter_orbs_list = game.player.starter_orbs.orbs
  let orb_pull = starter_orbs_list |> get_first_orb
  // let new_starter_orbs_list = starter_orbs_list |> get_remaining_orb_list
  let level = Level(..game.level, current_round: game.level.current_round + 1)

  let player =
    game.player
    |> resolve_player_orb_pull(orb_pull)
  // |> update_player_starter_orbs(new_starter_orbs_list)

  Game(..game, player:, level:)
}

pub fn update_view(game: Game) -> FrontendViews {
  let Game(player, level, _) = game
  let health = player.health.value
  let points = player.points.value
  let milestone = level.milestone.value

  game
  |> case health <= 0 {
    False ->
      case points >= milestone {
        False -> GameView
        True -> WinView
      }
    True -> LoseView
  }
}

pub fn reward_credits(game: Game) -> Game {
  let Game(player, _, _) = game
  let new_credits = player.points.value + player.credits.value
  let player = Player(..player, credits: Credits(value: new_credits))

  Game(..game, player:)
}

pub fn reset_for_next_round(game: Game) -> Game {
  let Game(player, level, _) = game
  let init_player = init_player()

  let starter_orbs =
    player.purchased_orbs.orbs
    |> list.append(init_player.starter_orbs.orbs)
    |> OrbBag

  let player =
    Player(
      ..init_player,
      credits: player.credits,
      starter_orbs:,
      purchased_orbs: player.purchased_orbs,
      curses: player.curses,
    )

  let level =
    Level(
      current_round: 1,
      current_level: level.current_level + 1,
      milestone: Points(level.milestone.value + 5),
    )

  Game(..game, player:, level:)
}

pub fn buy_market_item(game: Game, keyed_item: #(Int, MarketItem)) -> Game {
  let updated_game = case check_credits(game, keyed_item.1) {
    False -> option.None
    True -> {
      game
      |> deduct_credits_for_item(keyed_item.1)
      |> add_new_item_to_player(keyed_item.1)
      |> remove_item_from_market(keyed_item)
    }
  }

  case updated_game {
    option.None -> game
    option.Some(new_game) -> new_game
  }
}

fn deduct_credits_for_item(game: Game, item: MarketItem) -> Game {
  let credits = game.player.credits.value - item.price.value
  let player = Player(..game.player, credits: Credits(credits))

  Game(..game, player:)
}

fn add_new_item_to_player(game: Game, item: MarketItem) -> Game {
  let purchased_orbs =
    game.player.purchased_orbs.orbs |> list.prepend(item.item) |> OrbBag
  let player = Player(..game.player, purchased_orbs:)

  Game(..game, player:)
}

fn remove_item_from_market(
  game: Game,
  keyed_item: #(Int, MarketItem),
) -> Option(Game) {
  let market_list = game.market.items |> list.key_pop(keyed_item.0)
  case market_list {
    Error(_) -> option.None
    Ok(#(_, new_list)) -> {
      option.Some(Game(..game, market: Market(items: new_list)))
    }
  }
}

fn check_credits(game: Game, item: MarketItem) -> Bool {
  game.player.credits.value >= item.price.value
}

pub fn enable_shuffle(game: Game) -> Game {
  Game(
    ..game,
    player: Player(
      ..game.player,
      starter_orbs: game.player.starter_orbs.orbs |> list.shuffle |> OrbBag,
    ),
  )
}
