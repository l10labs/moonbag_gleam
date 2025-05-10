import gleam/int
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import models.{
  type GameState, type Msg, type Orb, Empty, PlayerNextLevel, PlayerPullOrb,
  PlayerStartGame,
}

// pub fn home_screen_view() -> Element(Msg) {
//   html.div(
//     [attribute.class("flex flex-col gaps-2 justify-center items-center")],
//     [
//       html.text("Moon Bag"),
//       html.button(
//         [
//           attribute.class("border border-black rounded"),
//           event.on_click(PlayerStartGame),
//         ],
//         [html.text("Start Game")],
//       ),
//     ],
//   )
// }

pub fn home_screen_view() -> Element(Msg) {
  html.div(
    [
      // Main container: full screen, dark gradient, centered content
      attribute.class(
        "flex flex-col min-h-screen justify-center items-center bg-gradient-to-br from-slate-900 via-purple-900 to-indigo-900 p-8 text-white antialiased",
      ),
    ],
    [
      // Game Title
      html.h1(
        [
          attribute.class(
            // Large, bold, with a subtle text shadow or a gradient text effect
            // Option 1: Simple, large, white text with shadow
            // "text-7xl font-bold tracking-tight text-white drop-shadow-lg mb-6"
            // Option 2: Gradient text (more flashy)
            "text-7xl font-extrabold tracking-tight mb-6 bg-gradient-to-r from-pink-400 via-purple-400 to-indigo-500 text-transparent bg-clip-text",
          ),
        ],
        [html.text("Moon Bag")],
      ),
      // Optional: A little tagline
      html.p(
        [attribute.class("text-xl text-slate-300 mb-12 text-center max-w-md")],
        [
          html.text(
            "Embark on a lunar adventure and fill your bag with cosmic treasures!",
          ),
        ],
      ),
      // Start Game Button
      html.button(
        [
          attribute.class(
            "bg-pink-500 hover:bg-pink-600 text-white font-semibold text-lg py-4 px-10 rounded-lg shadow-xl transform transition-all duration-300 ease-in-out hover:scale-105 focus:outline-none focus:ring-4 focus:ring-pink-300 focus:ring-opacity-50 active:bg-pink-700",
          ),
          event.on_click(PlayerStartGame),
          // Optional: Add an attribute to disable button if needed, e.g. during loading
        // attribute.disabled(model_is_loading_or_whatever)
        ],
        [
          // You can even add an icon here if you have SVGs
          // html.span([attribute.class("mr-2")], [html.text("🚀")]),
          html.text("🚀 Start Adventure"),
        ],
      ),
      // Optional: Footer or version number
      html.footer(
        [attribute.class("absolute bottom-4 text-sm text-slate-500")],
        [html.text("v0.1.0 - A Gleamy Game")],
      ),
    ],
  )
}

// pub fn game_state_view(game_state: GameState) -> Element(Msg) {
//   let level = game_state.level |> int.to_string
//   let health = game_state.health |> int.to_string
//   let points = game_state.points |> int.to_string
//   let cheddah = game_state.cheddah |> int.to_string
//   let milestone = game_state.milestone |> int.to_string
//   let orb_pull_view = game_state.orb_bag_in |> next_orb_pull_view
//   // let orb_bag = game_state.orb_bag_in |> list.map(orb_view)

//   html.div(
//     [attribute.class("flex flex-col gaps-2 justify-center items-center")],
//     [
//       html.p([], [html.text("level: " <> level)]),
//       html.p([], [html.text("health: " <> health)]),
//       html.p([], [html.text("points: " <> points)]),
//       html.p([], [html.text("cheddah: " <> cheddah)]),
//       html.p([], [html.text("milestone: " <> milestone)]),
//       html.div([], [html.text("next orb pull: "), orb_pull_view]),
//       html.button(
//         [
//           attribute.class("border border-black rounded"),
//           event.on_click(PlayerPullOrb),
//         ],
//         [html.text("Pull Orb From Bag")],
//       ),
//       // html.div([attribute.class("flex flex-col")], orb_bag),
//     ],
//   )
// }

pub fn game_state_view(game_state: GameState) -> Element(Msg) {
  let level_str = game_state.level |> int.to_string
  let health_str = game_state.health |> int.to_string
  let points_str = game_state.points |> int.to_string
  let cheddah_str = game_state.cheddah |> int.to_string
  let milestone_str = game_state.milestone |> int.to_string
  let orb_pull_view_content = game_state.orb_bag_in |> next_orb_pull_view

  // let orb_bag_elements = game_state.orb_bag_in |> list.map(orb_view)

  html.div(
    [
      // Outermost container: full screen, dark gradient.
      // No direct padding here as content is managed by inner divs.
      attribute.class(
        "min-h-screen bg-gradient-to-br from-slate-900 via-purple-900 to-indigo-900 text-white antialiased",
      ),
    ],
    [
      // Top Status Bar (Fixed)
      html.header(
        // Using <header> for semantic correctness
        [
          attribute.class(
            "fixed top-0 left-0 right-0 z-50 bg-slate-900/80 backdrop-blur-md shadow-lg flex justify-between items-center px-4 sm:px-8 h-16 sm:h-20",
            // h-16 (64px), sm:h-20 (80px)
          ),
        ],
        [
          // Level Display
          html.div([attribute.class("flex items-baseline gap-2")], [
            html.span(
              [
                attribute.class(
                  "text-sm sm:text-base text-slate-400 uppercase tracking-wider",
                ),
              ],
              [html.text("Level")],
            ),
            html.span(
              [attribute.class("text-xl sm:text-2xl font-bold text-purple-300")],
              [html.text(level_str)],
            ),
          ]),
          // Cheddah Display
          html.div([attribute.class("flex items-baseline gap-2")], [
            html.span(
              [
                attribute.class(
                  "text-sm sm:text-base text-slate-400 uppercase tracking-wider",
                ),
              ],
              [html.text("Cheddah")],
            ),
            html.span(
              [attribute.class("text-xl sm:text-2xl font-bold text-sky-300")],
              [html.text(cheddah_str)],
            ),
          ]),
        ],
      ),
      // Main Content Area (Scrollable, with padding to clear the fixed top bar)
      html.main(
        // Using <main> for semantic correctness
        [
          attribute.class(
            "flex flex-col items-center justify-start w-full px-4 sm:px-8 pb-8 pt-20 sm:pt-28",
            // pt-20/sm:pt-28 to clear h-16/sm:h-20 bar + some margin
          ),
        ],
        [
          // Stats Panel (now without Level and Cheddah)
          html.div(
            [
              attribute.class(
                "bg-slate-800/70 backdrop-blur-sm p-6 rounded-xl shadow-2xl w-full max-w-md mb-8",
              ),
            ],
            [
              html.h2(
                [
                  attribute.class(
                    "text-2xl sm:text-3xl font-bold text-center mb-6 text-pink-400 tracking-wide",
                  ),
                ],
                [html.text("Mission Vitals")],
                // Renamed slightly
              ),
              // Stats Grid (Health, Points, Milestone)
              html.div(
                [
                  attribute.class(
                    "grid grid-cols-1 sm:grid-cols-2 gap-x-6 gap-y-4 text-lg",
                  ),
                ],
                [
                  // Health (can be on its own row on small screens, or side-by-side on sm+)
                  stat_item("Health", health_str, "text-green-400"),
                  // Points
                  stat_item("Points", points_str, "text-yellow-300"),
                  // Milestone (spans full width)
                  html.div(
                    [
                      attribute.class(
                        "sm:col-span-2 mt-3 pt-3 border-t border-slate-700",
                      ),
                    ],
                    [
                      stat_item_full_width(
                        "Next Milestone",
                        milestone_str,
                        "text-teal-300",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Next Orb Pull Section
          html.div(
            [
              attribute.class(
                "bg-slate-800/50 backdrop-blur-xs p-6 rounded-xl shadow-xl w-full max-w-md mb-8 text-center",
              ),
            ],
            [
              html.p(
                [attribute.class("text-xl font-semibold text-slate-300 mb-3")],
                [html.text("Next Orb in Bag:")],
              ),
              html.div(
                [
                  attribute.class(
                    "text-2xl font-bold text-yellow-400 animate-pulse",
                  ),
                ],
                [orb_pull_view_content],
              ),
            ],
          ),
          // Pull Orb Button
          html.button(
            [
              attribute.class(
                "bg-pink-500 hover:bg-pink-600 text-white font-semibold text-lg py-3 px-8 rounded-lg shadow-xl transform transition-all duration-300 ease-in-out hover:scale-105 focus:outline-none focus:ring-4 focus:ring-pink-300 focus:ring-opacity-50 active:bg-pink-700 w-full max-w-xs",
              ),
              event.on_click(PlayerPullOrb),
            ],
            [html.text("✨ Pull Orb")],
          ),
          // Optional Orb Bag Display
        // ... (same as before)
        ],
      ),
    ],
  )
}

// Helper function for consistent stat item rendering (used in main stats panel)
fn stat_item(
  label: String,
  value: String,
  value_color_class: String,
) -> Element(Msg) {
  html.div(
    // Each stat item is now a div for better grid layout control
    [attribute.class("flex justify-between items-baseline sm:block")],
    // Side-by-side on small, stacked on sm
    [
      html.span(
        [
          attribute.class(
            "text-slate-300 mr-2 sm:mr-0 sm:block sm:text-sm sm:mb-1",
          ),
        ],
        [html.text(label <> ":")],
      ),
      html.span([attribute.class("font-semibold " <> value_color_class)], [
        html.text(value),
      ]),
    ],
  )
}

// Helper for a stat item that might span full width or need different layout
fn stat_item_full_width(
  label: String,
  value: String,
  value_color_class: String,
) -> Element(Msg) {
  html.div([attribute.class("flex justify-between items-center mt-1")], [
    html.span([attribute.class("text-slate-300 text-lg")], [
      html.text(label <> ":"),
    ]),
    html.span([attribute.class("font-bold text-xl " <> value_color_class)], [
      html.text(value),
    ]),
  ])
}

// pub fn win_screen_view(game_state: GameState) -> Element(Msg) {
//   html.div(
//     [attribute.class("flex flex-col gaps-2 justify-center items-center")],
//     [
//       html.p([], [html.text("You Won!")]),
//       html.p([], [
//         html.text(string.concat(["Level ", game_state.level |> int.to_string])),
//       ]),
//       html.button(
//         [
//           attribute.class("border border-black rounded"),
//           event.on_click(PlayerNextLevel),
//         ],
//         [html.text("Next Level")],
//       ),
//     ],
//   )
// }

// pub fn lose_screen_view() -> Element(Msg) {
//   html.div(
//     [attribute.class("flex flex-col gaps-2 justify-center items-center")],
//     [
//       html.text("You Lost!"),
//       html.button(
//         [
//           attribute.class("border border-black rounded"),
//           event.on_click(PlayerStartGame),
//         ],
//         [html.text("Restart?")],
//       ),
//     ],
//   )
// }

pub fn orb_view(orb: Orb) -> Element(Msg) {
  let orb_text = orb |> models.orb_to_string

  html.div([], [html.text(orb_text)])
}

pub fn next_orb_pull_view(orb_bag: List(Orb)) -> Element(Msg) {
  let result = orb_bag |> list.first
  let orb = case result {
    Error(_) -> Empty
    Ok(orb) -> orb
  }

  orb |> orb_view
}

pub fn win_screen_view(game_state: GameState) -> Element(Msg) {
  let current_level = game_state.level |> int.to_string

  html.div(
    [
      // Full-screen container, centered content, gradient background
      attribute.class(
        "flex flex-col min-h-screen justify-center items-center text-center p-8 bg-gradient-to-br from-slate-900 via-purple-800 to-teal-700 text-white antialiased",
        // Slightly different celebratory gradient
      ),
    ],
    [
      // "Victory!" Title
      html.h1(
        [
          attribute.class(
            // Large, bold, with a gold gradient text effect
            "text-7xl sm:text-8xl font-extrabold tracking-tight mb-3 bg-gradient-to-r from-yellow-300 via-amber-400 to-orange-500 text-transparent bg-clip-text",
          ),
        ],
        [html.text("VICTORY!")],
      ),
      // Optional: A little celebratory icon/text
      html.p(
        [attribute.class("text-4xl mb-6 animate-bounce")],
        // Simple bounce for fun
        [html.text("✨🚀✨")],
      ),
      // Level Achieved Message
      html.p([attribute.class("text-2xl text-slate-200 mb-10")], [
        html.text("You've conquered Level "),
        html.span([attribute.class("font-bold text-yellow-300")], [
          html.text(current_level),
        ]),
        html.text("!"),
      ]),
      // Next Level Button
      html.button(
        [
          attribute.class(
            // Using a vibrant green for "success" or "proceed"
            "bg-green-500 hover:bg-green-600 text-white font-semibold text-xl py-4 px-10 rounded-lg shadow-xl transform transition-all duration-300 ease-in-out hover:scale-105 focus:outline-none focus:ring-4 focus:ring-green-300 focus:ring-opacity-50 active:bg-green-700",
          ),
          event.on_click(PlayerNextLevel),
        ],
        [html.text("Next Mission")],
      ),
      // Optional: Return to Main Menu button (if you have such a Msg)
    // html.button(
    //   [
    //     attribute.class("mt-6 text-slate-400 hover:text-slate-200 transition-colors duration-150 text-lg underline"),
    //     // event.on_click(ReturnToMainMenu),
    //   ],
    //   [html.text("Return to Hangar")]
    // )
    ],
  )
}

pub fn lose_screen_view() -> Element(Msg) {
  html.div(
    [
      // Full-screen container, centered content, darker/more somber gradient background
      attribute.class(
        "flex flex-col min-h-screen justify-center items-center text-center p-8 bg-gradient-to-br from-slate-900 via-red-900 to-rose-900 text-white antialiased",
        // More somber gradient
      ),
    ],
    [
      // "Mission Failed" Title
      html.h1(
        [
          attribute.class(
            // Large, bold, with a strong red color
            "text-7xl sm:text-8xl font-extrabold tracking-tight mb-4 text-red-400 drop-shadow-md",
          ),
        ],
        [html.text("MISSION FAILED")],
      ),
      // Sub-message
      html.p([attribute.class("text-xl text-slate-300 mb-10 max-w-md")], [
        html.text(
          "The cosmic void can be unforgiving. Don't lose hope, astronaut!",
        ),
      ]),
      // Restart Button
      html.button(
        [
          attribute.class(
            // Using the established pink for primary action
            "bg-pink-500 hover:bg-pink-600 text-white font-semibold text-xl py-4 px-10 rounded-lg shadow-xl transform transition-all duration-300 ease-in-out hover:scale-105 focus:outline-none focus:ring-4 focus:ring-pink-300 focus:ring-opacity-50 active:bg-pink-700",
          ),
          event.on_click(PlayerStartGame),
          // Assumes PlayerStartGame restarts the current level or game
        ],
        [html.text("🚀 Try Again")],
      ),
      // Optional: Return to Main Menu button
    // html.button(
    //   [
    //     attribute.class("mt-6 text-slate-400 hover:text-slate-200 transition-colors duration-150 text-lg underline"),
    //     // event.on_click(ReturnToMainMenu), // Or PlayerStartGame if that takes to main menu
    //   ],
    //   [html.text("Back to Main Menu")]
    // )
    ],
  )
}
