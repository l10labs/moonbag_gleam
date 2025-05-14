import gleam/int
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import msg.{
  type Msg, PlayerBuyItem, PlayerNextRound, PlayerPullOrb, PlayerStartGame,
  PlayerVisitMarket,
}
import ty.{type Game, Game, Points}
import ui

fn page_wrapper(
  styles: List(String),
  content: List(Element(Msg)),
) -> Element(Msg) {
  html.div(
    [
      attribute.class(
        "bg-white text-black min-h-screen flex flex-col "
        <> list.fold(styles, "", fn(acc, s) { acc <> " " <> s }),
      ),
    ],
    content,
  )
}

fn centered_content_wrapper(
  additional_styles: List(String),
  content: List(Element(Msg)),
) -> Element(Msg) {
  page_wrapper(
    ["items-center justify-center p-8"] |> list.append(additional_styles),
    [
      html.div(
        [attribute.class("flex flex-col items-center text-center space-y-8")],
        content,
      ),
    ],
  )
}

pub fn home() -> Element(Msg) {
  centered_content_wrapper([], [
    html.h1([attribute.class("text-6xl font-bold text-black tracking-tight")], [
      html.text("MOON BAG"),
    ]),
    ui.clean_button(PlayerStartGame, "Start Game"),
  ])
}

pub fn game(game_data: Game) -> Element(Msg) {
  let Game(player, level, _) = game_data
  let Points(points) = player.points
  let Points(milestone) = level.milestone

  page_wrapper([], [
    ui.nav_bar_view(player),
    html.main(
      [
        attribute.class(
          "flex-grow flex flex-col items-center justify-center p-8 space-y-6",
        ),
      ],
      [
        html.h1([attribute.class("text-4xl font-semibold text-black mb-4")], [
          html.text("LEVEL " <> int.to_string(level.current_level)),
        ]),
        html.div([attribute.class("flex flex-row space-x-8 mb-6")], [
          html.div([attribute.class("flex flex-col items-center")], [
            html.span(
              [
                attribute.class(
                  "text-sm text-black mb-1 uppercase tracking-wider",
                ),
              ],
              [html.text("Points")],
            ),
            ui.square_view(points |> int.to_string),
          ]),
          html.div([attribute.class("flex flex-col items-center")], [
            html.span(
              [
                attribute.class(
                  "text-sm text-black mb-1 uppercase tracking-wider",
                ),
              ],
              [html.text("Milestone")],
            ),
            ui.square_view(milestone |> int.to_string),
          ]),
        ]),
        ui.clean_button(PlayerPullOrb, "Pull Orb"),
      ],
    ),
  ])
}

pub fn win() -> Element(Msg) {
  centered_content_wrapper([], [
    html.h1([attribute.class("text-5xl font-bold text-black mb-2")], [
      html.text("YOU WON!"),
    ]),
    html.p([attribute.class("text-lg text-black mb-4")], [
      html.text("Congratulations on reaching the milestone!"),
    ]),
    ui.clean_button(PlayerVisitMarket, "Visit the Market"),
  ])
}

pub fn lose() -> Element(Msg) {
  centered_content_wrapper([], [
    html.h1([attribute.class("text-5xl font-bold text-black mb-2")], [
      html.text("GAME OVER"),
    ]),
    html.p([attribute.class("text-lg text-black mb-4")], [
      html.text("Better luck next time!"),
    ]),
    ui.clean_button(PlayerStartGame, "Restart"),
  ])
}

pub fn market(game_data: Game) -> Element(Msg) {
  let Game(player, _, market) = game_data
  let items = market.items

  page_wrapper([], [
    ui.nav_bar_view(player),
    html.main(
      [attribute.class("flex-grow flex flex-col items-center p-8 space-y-6")],
      [
        html.h1([attribute.class("text-4xl font-semibold text-black mb-6")], [
          html.text("Market"),
        ]),
        case list.is_empty(items) {
          True ->
            html.p([attribute.class("text-lg text-black")], [
              html.text("The market is currently empty."),
            ])
          False ->
            html.div(
              [
                attribute.class(
                  "grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-6",
                ),
              ],
              list.map(items, ui.market_item_view(_, PlayerBuyItem)),
            )
        },
        ui.clean_button(PlayerNextRound, "Next Round"),
      ],
    ),
  ])
}

pub fn error() -> Element(Msg) {
  centered_content_wrapper([], [
    html.h1([attribute.class("text-5xl font-bold text-black")], [
      html.text("404"),
    ]),
    html.p([attribute.class("text-xl text-black")], [
      html.text("Page Not Found"),
    ]),
  ])
}
