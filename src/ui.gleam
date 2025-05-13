import gleam/int
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import newtypes.{type Msg, type Player, Player, Points}

pub fn clean_button(msg: Msg, title: String) -> Element(Msg) {
  html.button(
    [
      attribute.class(
        "px-8 py-3 mt-4 font-medium "
        <> "border-2 border-white rounded "
        <> "hover:bg-white hover:text-black "
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
    [
      attribute.class(
        "bg-black text-white px-4 sm:px-6 py-2 flex justify-between items-center border border-white",
      ),
    ],
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
        "bg-black text-white border border-white w-24 h-24 flex items-center justify-center",
      ),
    ],
    [
      html.span([attribute.class("text-lg font-medium text-center")], [
        html.text(content_string),
      ]),
    ],
  )
}
