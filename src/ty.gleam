import gleam/list
import gleam/option

pub type Player {
  Player(
    health: Health,
    points: Points,
    credits: Credits,
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
    // starter_orbs: init_orbs() |> list.shuffle |> OrbBag,
    starter_orbs: init_starter_orbs() |> OrbBag,
    purchased_orbs: [] |> OrbBag,
    curses: [NothingCurse] |> Curses,
  )
}

pub fn init_starter_orbs() -> List(Orb) {
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
    build_market_item(PointOrb(1), price: 2, times: 4),
    build_market_item(PointOrb(2), price: 5, times: 3),
    build_market_item(PointOrb(3), price: 8, times: 2),
    build_market_item(PointOrb(5), price: 20, times: 2),
    build_market_item(PointOrb(10), price: 50, times: 1),
  ]
  |> list.flatten
}

pub fn build_market_item(
  item: Orb,
  price price: Int,
  times times: Int,
) -> List(MarketItem) {
  build_orb(item, times)
  |> list.map(MarketItem(_, Credits(price)))
}

pub fn init_market() -> Market {
  init_market_items() |> list.index_map(fn(x, i) { #(i, x) }) |> Market
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
  let orb_bag = player.starter_orbs.orbs

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
      starter_orbs: OrbBag(new_orb_bag),
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
  let starter_orbs =
    player.purchased_orbs.orbs
    |> list.append(init_player().starter_orbs.orbs)
    |> OrbBag
  let player =
    Player(
      ..init_player(),
      credits: player.credits,
      starter_orbs:,
      purchased_orbs: player.purchased_orbs,
      curses: player.curses,
    )
  let level =
    Level(
      ..level,
      current_level: level.current_level + 1,
      milestone: Points(level.milestone.value + 5),
    )

  Game(..game, player:, level:)
}

pub fn buy_orb(game: Game, item_with_key: #(Int, MarketItem)) -> Game {
  let Game(player, _, market) = game
  let #(key, item) = item_with_key
  let MarketItem(_, price) = item

  let #(credits, new_items, player_new_item) = case
    player.credits.value >= price.value
  {
    False -> #(player.credits.value, market.items, option.None)
    True -> {
      let #(new_market_items, player_item) = case
        market.items |> list.key_pop(key)
      {
        Error(_) -> #(market.items, option.None)
        Ok(#(player_purchased_item, new_items)) -> #(
          new_items,
          option.Some(player_purchased_item),
        )
      }
      #(player.credits.value - price.value, new_market_items, player_item)
    }
  }

  let player_orb_list = case player_new_item {
    option.None -> player.purchased_orbs.orbs
    option.Some(new_orb) ->
      player.purchased_orbs.orbs |> list.prepend(new_orb.item)
  }

  let player =
    Player(
      ..player,
      credits: Credits(credits),
      purchased_orbs: OrbBag(player_orb_list),
    )

  Game(..game, player:, market: Market(items: new_items))
}
