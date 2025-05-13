import gleam/int
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import newtypes.{type Game, type Msg, Game, Points}
import ui

pub fn home() -> Element(Msg) {
  html.div(
    [
      attribute.class(
        "min-h-screen flex flex-col items-center justify-center p-4",
      ),
    ],
    [
      html.div(
        [attribute.class("flex flex-col items-center gap-10 text-center")],
        [
          html.h1(
            [
              attribute.class(
                "text-5xl sm:text-6xl font-semibold tracking-wider",
              ),
            ],
            [html.text("MOON BAG")],
          ),
          ui.clean_button(newtypes.PlayerStartGame, "Start Game"),
        ],
      ),
    ],
  )
}

pub fn game(game: Game) -> Element(Msg) {
  let Game(player, level, _) = game
  let Points(points) = player.points
  let Points(milestone) = level.milestone

  html.div([attribute.class("")], [
    ui.nav_bar_view(game.player),
    html.div(
      [
        attribute.class(
          "min-h-screen flex flex-col items-center justify-center p-4",
        ),
      ],
      [
        html.h1([], [html.text("Game View")]),
        html.div([attribute.class("flex flex-row p-4")], [
          html.div([], [
            html.text("Points"),
            ui.square_view(points |> int.to_string),
          ]),
          html.div([], [
            html.text("Milestone"),
            ui.square_view(milestone |> int.to_string),
          ]),
        ]),
        ui.clean_button(newtypes.PlayerPullOrb, "Pull Orb"),
        // html.div([attribute.class("flex flex-row gap-2")], [
      //   ui.clean_button(newtypes.TestWinView, "Win View"),
      //   ui.clean_button(newtypes.PlayerNextLevel, "Lose View"),
      //   ui.clean_button(newtypes.PlayerNextLevel, "Market View"),
      // ]),
      ],
    ),
  ])
}

pub fn win() -> Element(Msg) {
  html.div(
    [
      attribute.class(
        "min-h-screen flex flex-col items-center justify-center p-4",
      ),
    ],
    [
      html.h1([], [html.text("YOU WON!")]),
      html.div([attribute.class("flex flex-row gap-2")], [
        ui.clean_button(newtypes.PlayerVisitMarket, "Visit the Market"),
      ]),
    ],
  )
}

pub fn lose() -> Element(Msg) {
  html.div(
    [
      attribute.class(
        "min-h-screen flex flex-col items-center justify-center p-4",
      ),
    ],
    [
      html.h1([], [html.text("YOU LOSE!")]),
      html.div([attribute.class("flex flex-row gap-2")], [
        ui.clean_button(newtypes.PlayerStartGame, "Restart"),
      ]),
    ],
  )
}

pub fn market(game: Game) -> Element(Msg) {
  let Game(_, _, market) = game
  let items = market.items
  html.div([attribute.class("")], [
    ui.nav_bar_view(game.player),
    html.div(
      [
        attribute.class(
          "min-h-screen flex flex-col items-center justify-center p-4",
        ),
      ],
      [
        html.h1([], [html.text("Market View")]),
        html.div(
          [attribute.class("flex flex-row")],
          items |> list.map(ui.market_item_view),
        ),
        ui.clean_button(newtypes.PlayerNextRound, "Next Round"),
      ],
    ),
  ])
}

pub fn error() -> Element(Msg) {
  html.div(
    [
      attribute.class(
        "min-h-screen flex flex-col items-center justify-center p-4 text-4xl",
      ),
    ],
    [html.h1([], [html.text("404 ERROR")])],
  )
}
