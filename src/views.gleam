import gleam/int
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import msg.{
  type Msg, PlayerBuyItem, PlayerNextRound, PlayerPullOrb, PlayerStartGame,
  PlayerVisitMarket,
}
import new_ui
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
  html.section(
    [
      attribute.class(
        "min-h-screen flex flex-col items-center justify-center space-y-4",
      ),
    ],
    [
      new_ui.main_title_view("MOON BAG"),
      new_ui.button_view(PlayerStartGame, "Start Game"),
    ],
  )
}

pub fn game(game_data: Game) -> Element(Msg) {
  let Game(player:, level:, ..) = game_data
  let Points(points) = player.points
  let Points(milestone) = level.milestone
  let health = player.health.value
  let credits = player.credits.value
  let round = level.current_round
  let last_orb = player.last_played_orb
  let next_orb = player.starter_orbs.orbs |> ty.get_first_orb

  html.section(
    [
      attribute.class(
        "min-h-screen flex flex-col items-center justify-center space-y-4",
      ),
    ],
    [
      new_ui.heading_view("LEVEL " <> int.to_string(level.current_level)),
      html.div([attribute.class("flex flex-row space-x-8 mb-6")], [
        new_ui.game_element_view("Health", health |> int.to_string),
        new_ui.game_element_view("Points", points |> int.to_string),
        new_ui.game_element_view("Milestone", milestone |> int.to_string),
        new_ui.game_element_view("Credits", "$" <> credits |> int.to_string),
      ]),
      html.div([attribute.class("flex flex-col space-x-8 mb-6")], [
        new_ui.game_element_view(
          "Round " <> round |> int.to_string,
          last_orb |> ty.orb_to_string,
        ),
        html.text("Next Orb: " <> next_orb |> ty.orb_to_string),
      ]),
      new_ui.button_view(PlayerPullOrb, "Pull Orb"),
    ],
  )
}

pub fn win() -> Element(Msg) {
  centered_content_wrapper([], [
    html.h1([attribute.class("text-5xl font-bold text-black mb-2")], [
      html.text("YOU WON!"),
    ]),
    html.p([attribute.class("text-lg text-black mb-4")], [
      html.text("Congratulations on reaching the milestone!"),
    ]),
    new_ui.button_view(PlayerVisitMarket, "Visit the Market"),
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
    new_ui.button_view(PlayerStartGame, "Restart"),
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
        new_ui.button_view(PlayerNextRound, "Next Round"),
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
