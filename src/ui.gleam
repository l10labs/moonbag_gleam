import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import newtypes.{type MarketItem, type Msg, type Player, Player}

pub fn clean_button(msg: Msg, title: String) -> Element(Msg) {
  html.button(
    [
      attribute.class(
        "px-8 py-3 mt-4 font-medium "
        <> "border-2 border-black rounded "
        <> "hover:bg-black hover:text-white "
        <> "focus:outline-none focus:ring-2 focus:ring-white "
        <> "focus:ring-offset-2 focus:ring-offset-black "
        <> "transition-colors duration-150 ease-in-out",
      ),
      event.on_click(msg),
    ],
    [html.text(title)],
  )
}

pub fn nav_bar_view(player: Player) -> Element(Msg) {
  let Player(health, _, credits, _, _) = player

  html.nav(
    [attribute.class("px-4 sm:px-6 py-2 flex justify-between items-center")],
    [
      html.div([], [html.text(newtypes.health_to_string(health))]),
      html.div([], [html.text(newtypes.credits_to_string(credits))]),
    ],
  )
}

pub fn square_view(content_string: String) -> Element(Msg) {
  html.div(
    [
      attribute.class(
        "w-24 h-24 flex items-center justify-center border border-black",
      ),
    ],
    [
      html.span([attribute.class("text-lg font-medium text-center")], [
        html.text(content_string),
      ]),
    ],
  )
}

pub fn market_item_view(item: MarketItem) -> Element(Msg) {
  let price = item.price.value |> int.to_string
  let #(name, value) = case item.item {
    newtypes.BombOrb(value) -> #("Bomb", value |> int.to_string)
    newtypes.PointOrb(value) -> #("Point", value |> int.to_string)
    newtypes.EmptyOrb -> #("Empty", 0 |> int.to_string)
  }

  html.div([attribute.class("flex flex-col items-center justify-center")], [
    square_view([name, " ", value] |> string.concat),
    html.h4([], [html.text("cost: " <> price)]),
  ])
}
