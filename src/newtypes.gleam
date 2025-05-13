// NEW TYPES FOR MOON BAG
import gleam/int
import gleam/list
import gleam/string

pub type Player {
  Player(
    health: Health,
    points: Points,
    credits: Credits,
    orb_bag: OrbBag,
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
  EmptyOrb
}

pub type Curses {
  Curses(curses: List(Curse))
}

pub type Curse {
  NothingCurse
}

pub type Market {
  Market(items: List(MarketItem))
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

pub type Msg {
  PlayerStartGame
  PlayerPullOrb
  PlayerVisitMarket
  PlayerNextRound
}

pub fn init_player() -> Player {
  let health = Health(5)
  let points = Points(0)
  let credits = Credits(0)
  // let orb_bag = init_orbs() |> list.shuffle |> OrbBag
  let orb_bag = init_orbs() |> OrbBag
  let curses = Curses(curses: [NothingCurse])

  Player(health:, points:, credits:, orb_bag:, curses:)
}

pub fn init_orbs() -> List(Orb) {
  [
    build_orb(PointOrb(1), times: 4),
    build_orb(PointOrb(2), times: 3),
    build_orb(PointOrb(3), times: 2),
    build_orb(BombOrb(1), times: 3),
    build_orb(BombOrb(2), times: 2),
  ]
  |> list.flatten
}

pub fn build_orb(orb_type: Orb, times times: Int) -> List(Orb) {
  list.repeat(orb_type, times)
}

pub fn init_market_items() -> List(MarketItem) {
  [
    build_market_item(PointOrb(1), 2),
    build_market_item(PointOrb(1), 2),
    build_market_item(PointOrb(1), 2),
    build_market_item(PointOrb(2), 5),
    build_market_item(PointOrb(3), 8),
  ]
}

pub fn build_market_item(item: Orb, price: Int) -> MarketItem {
  MarketItem(item:, price: Credits(price))
}

pub fn init_market() -> Market {
  init_market_items() |> Market
}

pub fn init_level() -> Level {
  Level(current_level: 1, current_round: 1, milestone: Points(10))
}

pub fn init_game() -> Game {
  let player = init_player()
  let market = init_market()
  let level = init_level()

  Game(player:, market:, level:)
}

pub fn handle_game_state_transitions(game: Game) -> Game {
  let Game(player, _, _) = game
  let orb_bag = player.orb_bag.orbs

  let #(orb_pull, new_orb_bag) = case orb_bag {
    [] -> #(EmptyOrb, [])
    [first, ..rest] -> {
      #(first, rest)
    }
  }

  let #(health, points) = case orb_pull {
    BombOrb(damage) -> #(player.health.value - damage, player.points.value)
    PointOrb(points) -> #(player.health.value, player.points.value + points)
    EmptyOrb -> #(player.health.value, player.points.value)
  }

  let new_player =
    Player(
      ..player,
      health: Health(health),
      points: Points(points),
      orb_bag: OrbBag(new_orb_bag),
    )
  let new_game = Game(..game, player: new_player)

  new_game
}

pub fn handle_frontend_view_transitions(game: Game) -> FrontendViews {
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

pub fn update_credits(game: Game) -> Game {
  let Game(player, _, _) = game
  let new_credits = player.points.value + player.credits.value
  let player = Player(..player, credits: Credits(value: new_credits))

  Game(..game, player:)
}

pub fn reset_for_next_round(game: Game) -> Game {
  let Game(player, level, _) = game
  let player =
    Player(..init_player(), credits: player.credits, curses: player.curses)
  let level =
    Level(
      ..level,
      current_level: level.current_level + 1,
      milestone: Points(level.milestone.value + 5),
    )

  Game(..game, player:, level:)
}

pub fn buy_orbs(player: Player) -> Player {
  todo
}

// Functions for types to strings

// --- to_string Functions ---

pub fn health_to_string(health: Health) -> String {
  let Health(value) = health
  "Health(" <> int.to_string(value) <> ")"
}

pub fn points_to_string(points: Points) -> String {
  let Points(value) = points
  "Points(" <> int.to_string(value) <> ")"
}

pub fn credits_to_string(credits: Credits) -> String {
  let Credits(value) = credits
  "Credits(" <> int.to_string(value) <> ")"
}

pub fn orb_to_string(orb: Orb) -> String {
  case orb {
    PointOrb(value) -> "Orb.Point(" <> int.to_string(value) <> ")"
    BombOrb(value) -> "Orb.Bomb(" <> int.to_string(value) <> ")"
    EmptyOrb -> "Empty Orb"
  }
}

pub fn orbs_to_string(orbs: OrbBag) -> String {
  let OrbBag(orb_list) = orbs
  let item_strings = list.map(orb_list, orb_to_string)
  "Orbs([" <> string.join(item_strings, ", ") <> "])"
}

// For the opaque type `Curse`, we can only provide a generic string.
// If `Curse` had constructors or specific identifiable data, this would be different.
pub fn curse_to_string(_curse: Curse) -> String {
  // If Curse instances were created with some internal ID or distinguishable
  // feature (even if opaque), you might have a function in Curse's own module
  // to get that. For now, we assume a generic representation.
  "Curse"
}

pub fn curses_to_string(curses: Curses) -> String {
  let Curses(curse_list) = curses
  let item_strings = list.map(curse_list, curse_to_string)
  "Curses([" <> string.join(item_strings, ", ") <> "])"
}

pub fn market_item_to_string(market_item: MarketItem) -> String {
  let MarketItem(item, price) = market_item
  "MarketItem(item: "
  <> orb_to_string(item)
  <> ", price: "
  <> credits_to_string(price)
  <> ")"
}

pub fn market_to_string(market: Market) -> String {
  let Market(market_item_list) = market
  let item_strings = list.map(market_item_list, market_item_to_string)
  "Market([" <> string.join(item_strings, ", ") <> "])"
}

pub fn level_to_string(level: Level) -> String {
  let Level(current_level, current_round, milestone) = level
  "Level(current_level: "
  <> int.to_string(current_level)
  <> ", current_round: "
  <> int.to_string(current_round)
  <> ", milestone: "
  <> points_to_string(milestone)
  <> ")"
}

pub fn player_to_string(player: Player) -> String {
  let Player(health, points, credits, orbs, curses) = player
  "Player(health: "
  <> health_to_string(health)
  <> ", points: "
  <> points_to_string(points)
  <> ", credits: "
  <> credits_to_string(credits)
  <> ", orbs: "
  <> orbs_to_string(orbs)
  <> ", curses: "
  <> curses_to_string(curses)
  <> ")"
}

pub fn game_to_string(game: Game) -> String {
  let Game(player, level, market) = game
  "Game(player: "
  <> player_to_string(player)
  <> ", market: "
  <> market_to_string(market)
  <> ", level: "
  <> level_to_string(level)
  <> ")"
}
