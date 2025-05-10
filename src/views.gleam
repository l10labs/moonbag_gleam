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

// --- THEME CONSTANTS (Conceptual - applied via Tailwind classes) ---
// Background: bg-black or bg-gray-950
// Primary Text: text-gray-100 or text-white
// Secondary Text: text-gray-400 or text-gray-500
// Borders/Accents: border-gray-700 or border-gray-800
// Font: font-mono

// --- HOME SCREEN ---
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

// --- GAME STATE VIEW ---
pub fn game_state_view(game_state: GameState) -> Element(Msg) {
  let level_str = game_state.level |> int.to_string
  let health_str = game_state.health |> int.to_string
  let points_str = game_state.points |> int.to_string
  let cheddah_str = game_state.cheddah |> int.to_string
  let milestone_str = game_state.milestone |> int.to_string

  html.div(
    [
      attribute.class(
        "min-h-screen bg-black text-gray-200 font-mono antialiased",
      ),
    ],
    [
      // Top Status Bar (Fixed)
      html.header(
        [
          attribute.class(
            "fixed top-0 left-0 right-0 z-50 bg-black/90 backdrop-blur-sm border-b border-gray-800 flex justify-between items-center px-4 sm:px-6 h-16",
          ),
        ],
        [
          // Level Display
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
          // "Cheddah" (renamed to Credits for theme)
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
      // Main Content Area
      html.main(
        [
          attribute.class(
            "flex flex-col items-center justify-start w-full px-4 sm:px-6 pb-8 pt-24",
            // pt-24 to clear h-16 bar + margin
          ),
        ],
        [
          // Stats Panel
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
                    "text-xl font-medium text-center mb-5 text-gray-300 tracking-wider uppercase",
                  ),
                ],
                [html.text("System Diagnostics")],
              ),
              html.div([attribute.class("space-y-3")], [
                game_stat_item("Integrity", health_str),
                // Health
                game_stat_item("Data Points", points_str),
                // Points
                game_stat_item_full_width("Signal Target", milestone_str),
                // Milestone
              ]),
            ],
          ),
          // Next Orb Pull Section
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
          // Pull Orb Button
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

// Helper for game stats
fn game_stat_item(label: String, value: String) -> Element(Msg) {
  html.div([attribute.class("flex justify-between items-baseline")], [
    html.span([attribute.class("text-sm text-gray-400 tracking-wider")], [
      html.text(label <> ":"),
    ]),
    html.span([attribute.class("text-base text-gray-100 font-medium")], [
      html.text(value),
    ]),
  ])
}

fn game_stat_item_full_width(label: String, value: String) -> Element(Msg) {
  html.div(
    [
      attribute.class(
        "pt-3 border-t border-gray-800 flex justify-between items-baseline",
      ),
    ],
    [
      html.span([attribute.class("text-sm text-gray-400 tracking-wider")], [
        html.text(label <> ":"),
      ]),
      html.span([attribute.class("text-base text-gray-100 font-medium")], [
        html.text(value),
      ]),
    ],
  )
}

// --- ORB RELATED VIEWS ---
pub fn orb_view(orb: Orb) -> Element(Msg) {
  // The styling is primarily handled by next_orb_pull_view for context
  // This just provides the text content
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

// --- WIN SCREEN ---
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

// --- LOSE SCREEN ---
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
            // Dimmer for loss
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
