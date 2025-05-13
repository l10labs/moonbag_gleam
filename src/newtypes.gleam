// NEW TYPES FOR MOON BAG
import gleam/int
import gleam/list
import gleam/string

pub type Player {
  Player(
    health: Health,
    points: Points,
    credits: Credits,
    orbs: Orbs,
    curses: Curses,
  )
}

pub type Health {
  Health(Int)
}

pub type Points {
  Points(Int)
}

pub type Credits {
  Credits(Int)
}

pub type Orbs {
  Orbs(orbs: List(Orb))
}

pub type Orb {
  Point(Int)
  Bomb(Int)
}

pub type Curses {
  Curses(curses: List(Curse))
}

pub type Curse {
  NothingCurse
}

pub type Market {
  Market(List(MarketItem))
}

pub type MarketItem {
  MarketItem(item: Orb, price: Credits)
}

pub type Level {
  Level(current_level: Int, current_round: Int, milestone: Points)
}

pub type Game {
  Game(player: Player, market: Market, level: Level)
}

pub type FrontendViews {
  HomeView
  GameView(Game)
  MarketView(Game)
  WinView(Game)
  LoseView(Game)
}

pub type Msg {
  PlayerStartGame
  PlayerPullOrb
  PlayerNextLevel
  TestWinView
  TestLoseView
  TestMarketView
}

pub fn init_player() -> Player {
  let health = Health(5)
  let points = Points(0)
  let credits = Credits(0)
  let orbs = init_orbs()
  let curses = Curses(curses: [NothingCurse])

  Player(health:, points:, credits:, orbs:, curses:)
}

pub fn init_orbs() -> Orbs {
  list.fold(
    [
      build_orb(Point(1), times: 4),
      build_orb(Point(2), times: 3),
      build_orb(Point(3), times: 2),
      build_orb(Bomb(1), times: 3),
      build_orb(Bomb(2), times: 2),
    ],
    list.new(),
    list.append,
  )
  |> Orbs
}

pub fn build_orb(orb_type: Orb, times times: Int) {
  list.repeat(orb_type, times)
}

pub fn init_market() -> Market {
  Market([])
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
    Point(value) -> "Orb.Point(" <> int.to_string(value) <> ")"
    Bomb(value) -> "Orb.Bomb(" <> int.to_string(value) <> ")"
  }
}

pub fn orbs_to_string(orbs: Orbs) -> String {
  let Orbs(orb_list) = orbs
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
  let Game(player, market, level) = game
  "Game(player: "
  <> player_to_string(player)
  <> ", market: "
  <> market_to_string(market)
  <> ", level: "
  <> level_to_string(level)
  <> ")"
}
