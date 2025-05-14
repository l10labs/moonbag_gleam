import gleam/int
import gleam/list
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import newtypes.{
  type Health, type MarketItem, type Msg, type Player, Health, Player,
}

pub fn clean_button(msg: Msg, title: String) -> Element(Msg) {
  html.button(
    [
      attribute.class(
        "px-8 py-3 mt-4 font-semibold text-sm "
        <> "border-2 border-black rounded tracking-wider uppercase "
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

// --- New Health Bar Component ---

fn health_segment(is_filled: Bool) -> Element(Msg) {
  let base_class = "w-4 h-6"
  // Width and height of each segment
  let filled_class = "bg-black"
  let empty_class = "bg-white border border-black"

  html.div(
    [
      attribute.class(
        // base_class <> " " <> if is_filled { filled_class } else { empty_class },
        base_class
        <> " "
        <> case is_filled {
          True -> filled_class
          False -> empty_class
        },
        // { filled_class } else { empty_class },
      ),
    ],
    [],
  )
}

fn health_bar_view(current_health: Health) -> Element(Msg) {
  // Assuming max health is 5, based on init_player() in newtypes.gleam.
  // If max_health can change, this should be passed as a parameter.
  let max_health_segments = 5
  let Health(filled_count) = current_health

  let segments =
    list.range(1, max_health_segments)
    |> list.map(fn(segment_index) {
      health_segment(segment_index <= filled_count)
    })

  html.div(
    [attribute.class("flex flex-row space-x-1 items-center")],
    segments
      |> list.prepend(
        html.div(
          [attribute.class("text-md font-semibold text-black tracking-tight")],
          [html.text("HEALTH: ")],
        ),
      ),
  )
}

// --- Updated Nav Bar View ---

pub fn nav_bar_view(player: Player) -> Element(Msg) {
  let Player(health, _, credits, _, _, _) = player

  html.nav(
    [
      attribute.class(
        "bg-white px-4 sm:px-6 py-3 flex justify-between items-center border-b-2 border-black sticky top-0 z-10",
      ),
    ],
    [
      // Health bar on the left
      health_bar_view(health),
      // Credits on the right
      html.div(
        [attribute.class("text-md font-semibold text-black tracking-tight")],
        [
          html.text("CREDITS: $"),
          html.span([attribute.class("font-bold")], [
            int.to_string(credits.value) |> html.text,
          ]),
        ],
      ),
    ],
  )
}

pub fn square_view(content_string: String) -> Element(Msg) {
  html.div(
    [
      attribute.class(
        "w-24 h-24 flex items-center justify-center border-2 border-black bg-white",
      ),
    ],
    [
      html.span([attribute.class("text-xl font-semibold text-black")], [
        html.text(content_string),
      ]),
    ],
  )
}

pub fn market_item_view(item_with_key: #(Int, MarketItem)) -> Element(Msg) {
  let #(_, item) = item_with_key
  let price = item.price.value |> int.to_string
  let #(name, value) = case item.item {
    newtypes.BombOrb(value) -> #("Bomb", value |> int.to_string)
    newtypes.PointOrb(value) -> #("Point", value |> int.to_string)
    newtypes.EmptyOrb -> #("Empty", 0 |> int.to_string)
  }

  html.div(
    [
      attribute.class(
        "flex flex-col items-center justify-center p-2 border-2 border-black rounded bg-white hover:shadow-lg transition-shadow",
      ),
    ],
    [
      html.button(
        [
          event.on_click(newtypes.PlayerBuyItem(item_with_key)),
          attribute.class("flex flex-col items-center space-y-1 w-full"),
        ],
        [
          square_view([name, " ", value] |> string.concat),
          html.h4([attribute.class("text-sm font-medium text-black mt-1")], [
            html.text("Cost: " <> price),
          ]),
        ],
      ),
    ],
  )
}
