import gleam/float
import gleam/int
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import models.{
  type GameState, type Msg, type Orb, PlayerNextLevel, PlayerPullOrb,
  PlayerStartGame,
}

pub fn home_screen_view() -> Element(Msg) {
  html.div(
    [
      attribute.class(
        "flex flex-col min-h-screen justify-center items-center bg-black text-gray-200 p-8 font-mono antialiased text-center",
      ),
    ],
    [
      html.h1(
        [
          attribute.class(
            "text-5xl sm:text-7xl text-white font-medium tracking-widest mb-3",
          ),
        ],
        [html.text("MOON BAG")],
      ),
      html.p(
        [
          attribute.class(
            "text-sm sm:text-base text-gray-400 mb-16 max-w-md tracking-wider",
          ),
        ],
        [
          html.text(
            "Anomalous signals detected. Prepare for resource extraction.",
          ),
        ],
      ),
      html.button(
        [
          attribute.class(
            "border border-gray-600 hover:border-white text-gray-300 hover:text-white py-3 px-10 rounded-none text-lg tracking-wider uppercase transition-colors duration-300 ease-in-out focus:outline-none focus:ring-1 focus:ring-gray-500",
          ),
          event.on_click(PlayerStartGame),
        ],
        [html.text("Initiate Expedition")],
      ),
      html.footer(
        [
          attribute.class(
            "absolute bottom-6 text-xs text-gray-700 tracking-widest uppercase",
          ),
        ],
        [html.text("System v0.1.0")],
      ),
    ],
  )
}

fn stat_bar_view(
  label: String,
  current_value: Int,
  max_value: Int,
  bar_fill_class: String,
) -> Element(Msg) {
  let percentage = {
    let current = int.to_float(current_value)
    let max = int.to_float(max_value)
    case max >. 0.0 {
      True -> {
        let p = current /. max *. 100.0
        float.max(0.0, float.min(p, 100.0))
        // Clamp between 0 and 100
      }
      False -> {
        case current >. 0.0 {
          True -> 100.0
          // If max is 0 but current is positive, show full
          False -> 0.0
          // If both 0, show empty
        }
      }
    }
  }

  let display_percentage =
    percentage
    |> float.round
    |> int.to_string

  html.div([attribute.class("space-y-1 w-full")], [
    html.div([attribute.class("flex justify-between items-baseline text-sm")], [
      html.span([attribute.class("text-gray-400 tracking-wider")], [
        html.text(label),
      ]),
      html.span([attribute.class("text-gray-300 font-medium")], [
        html.text(
          int.to_string(current_value) <> "/" <> int.to_string(max_value),
        ),
      ]),
    ]),
    html.div(
      [
        attribute.class(
          "w-full bg-gray-800 rounded-none h-3 overflow-hidden border border-gray-700",
        ),
      ],
      [
        html.div(
          [
            attribute.class(
              bar_fill_class
              <> " h-full rounded-none transition-all duration-300 ease-in-out",
            ),
            attribute.style("width", display_percentage <> "%"),
          ],
          [],
        ),
      ],
    ),
  ])
}

pub fn game_state_view(game_state: GameState) -> Element(Msg) {
  let level_str = game_state.level |> int.to_string
  let cheddah_str = game_state.cheddah |> int.to_string

  // Assume max_health is 100. Adjust if different.
  let max_health = 5
  let current_health = game_state.health
  let current_points = game_state.points
  let target_milestone = game_state.milestone

  html.div(
    [
      attribute.class(
        "min-h-screen bg-black text-gray-200 font-mono antialiased",
      ),
    ],
    [
      html.header(
        [
          attribute.class(
            "fixed top-0 left-0 right-0 z-50 bg-black/90 backdrop-blur-sm border-b border-gray-800 flex justify-between items-center px-4 sm:px-6 h-16",
          ),
        ],
        [
          html.div([attribute.class("flex items-baseline gap-2")], [
            html.span(
              [
                attribute.class(
                  "text-xs text-gray-500 uppercase tracking-wider",
                ),
              ],
              [html.text("Sector")],
            ),
            html.span([attribute.class("text-lg text-gray-100 font-medium")], [
              html.text(level_str),
            ]),
          ]),
          html.div([attribute.class("flex items-baseline gap-2")], [
            html.span(
              [
                attribute.class(
                  "text-xs text-gray-500 uppercase tracking-wider",
                ),
              ],
              [html.text("Credits")],
            ),
            html.span([attribute.class("text-lg text-gray-100 font-medium")], [
              html.text(cheddah_str),
            ]),
          ]),
        ],
      ),
      html.main(
        [
          attribute.class(
            "flex flex-col items-center justify-start w-full px-4 sm:px-6 pb-8 pt-24",
          ),
        ],
        [
          html.div(
            [
              attribute.class(
                "bg-gray-950/70 border border-gray-800 p-5 sm:p-6 rounded-none shadow-md w-full max-w-lg mb-8",
              ),
            ],
            [
              html.h2(
                [
                  attribute.class(
                    "text-xl font-medium text-center mb-6 text-gray-300 tracking-wider uppercase",
                  ),
                ],
                [html.text("System Diagnostics")],
              ),
              html.div(
                [attribute.class("space-y-5")],
                // Increased spacing for bars
                [
                  stat_bar_view(
                    "Integrity",
                    current_health,
                    max_health,
                    "bg-gray-300",
                    // White-ish bar for health
                  ),
                  stat_bar_view(
                    "Signal Progress",
                    current_points,
                    target_milestone,
                    "bg-gray-100",
                    // Slightly different white for progress
                  ),
                ],
              ),
            ],
          ),
          html.div(
            [
              attribute.class(
                "bg-gray-950/70 border border-gray-800 p-5 sm:p-6 rounded-none shadow-md w-full max-w-lg mb-8 text-center",
              ),
            ],
            [
              html.p(
                [
                  attribute.class(
                    "text-sm text-gray-500 uppercase tracking-wider mb-2",
                  ),
                ],
                [html.text("Next Anomaly Signature:")],
              ),
              next_orb_pull_view(game_state.orb_bag_in),
            ],
          ),
          html.button(
            [
              attribute.class(
                "bg-gray-800 hover:bg-gray-700 text-gray-100 py-3 px-8 rounded-none text-base sm:text-lg tracking-wider uppercase transition-colors duration-150 ease-in-out w-full max-w-sm focus:outline-none focus:ring-1 focus:ring-gray-500",
              ),
              event.on_click(PlayerPullOrb),
            ],
            [html.text("Extract Anomaly")],
          ),
        ],
      ),
    ],
  )
}

pub fn orb_view(orb: Orb) -> Element(Msg) {
  html.text(orb |> models.orb_to_string)
}

pub fn next_orb_pull_view(orb_bag: List(Orb)) -> Element(Msg) {
  case list.first(orb_bag) {
    Ok(orb) ->
      html.div(
        [attribute.class("text-xl text-white font-semibold tracking-wider")],
        [orb_view(orb)],
      )
    Error(_) ->
      html.div(
        [attribute.class("text-lg text-gray-600 italic tracking-wider")],
        [html.text("No Signal...")],
      )
  }
}

pub fn win_screen_view(game_state: GameState) -> Element(Msg) {
  let current_level = game_state.level |> int.to_string

  html.div(
    [
      attribute.class(
        "flex flex-col min-h-screen justify-center items-center bg-black text-gray-200 p-8 font-mono antialiased text-center",
      ),
    ],
    [
      html.h1(
        [
          attribute.class(
            "text-4xl sm:text-6xl text-white font-medium tracking-widest mb-4",
          ),
        ],
        [html.text("OBJECTIVE COMPLETE")],
      ),
      html.p([attribute.class("text-base text-gray-300 mb-12 tracking-wider")], [
        html.text("Sector " <> current_level <> " secured."),
        html.br([]),
        html.text("Awaiting further instructions."),
      ]),
      html.button(
        [
          attribute.class(
            "border-2 border-gray-300 hover:border-white hover:bg-white text-gray-100 hover:text-black py-3 px-10 rounded-none text-lg tracking-wider uppercase font-semibold transition-all duration-300 ease-in-out focus:outline-none focus:ring-1 focus:ring-white",
          ),
          event.on_click(PlayerNextLevel),
        ],
        [html.text("Proceed to Next Sector")],
      ),
    ],
  )
}

pub fn lose_screen_view() -> Element(Msg) {
  html.div(
    [
      attribute.class(
        "flex flex-col min-h-screen justify-center items-center bg-black text-gray-200 p-8 font-mono antialiased text-center",
      ),
    ],
    [
      html.h1(
        [
          attribute.class(
            "text-4xl sm:text-6xl text-gray-500 font-medium tracking-widest mb-4",
          ),
        ],
        [html.text("SYSTEM CRITICAL")],
      ),
      html.p([attribute.class("text-base text-gray-400 mb-12 tracking-wider")], [
        html.text("Integrity compromised. Signal lost."),
        html.br([]),
        html.text("Attempting system recalibration..."),
      ]),
      html.button(
        [
          attribute.class(
            "border border-gray-700 hover:border-gray-400 text-gray-400 hover:text-gray-100 py-3 px-10 rounded-none text-lg tracking-wider uppercase transition-colors duration-300 ease-in-out focus:outline-none focus:ring-1 focus:ring-gray-600",
          ),
          event.on_click(PlayerStartGame),
        ],
        [html.text("Re-engage Protocol")],
      ),
    ],
  )
}
