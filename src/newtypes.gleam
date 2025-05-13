// NEW TYPES FOR MOON BAG

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
  Orbs(List(Orb))
}

pub type Orb {
  Point(Int)
  Bomb(Int)
}

pub type Curses {
  Curses(List(Curse))
}

pub type Curse

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
