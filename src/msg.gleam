import ty.{type MarketItem}

pub type Msg {
  PlayerStartGame
  PlayerPullOrb
  PlayerVisitMarket
  PlayerNextRound
  PlayerBuyItem(#(Int, MarketItem))
}
