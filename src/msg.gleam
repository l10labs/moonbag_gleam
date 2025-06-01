import ty.{type MarketItem, type Orb}

pub type Msg {
  PlayerStartGame
  PlayerPullOrb
  PlayerPull2Put1Back
  PlayerSelectOrb(Orb)
  PlayerVisitMarket
  PlayerNextRound
  PlayerBuyItem(#(Int, MarketItem))
}
