import lustre/attribute
import lustre/element/html
import lustre/event
import msg

// new_ui

pub fn button_view(msg: msg.Msg, text: String) {
  html.button(
    [
      event.on_click(msg),
      attribute.class(
        "
        font-semibold
        py-2
        px-6
        border
        border-black
        hover:bg-black
        hover:text-white
        hover:border-white
        transition-colors
        duration-500
        ease-in-out
    ",
      ),
    ],
    [html.text(text)],
  )
}

pub fn main_title_view(text: String) {
  html.h1(
    [
      attribute.class(
        "
        text-5xl
        md:text-6xl
        lg:text-7xl
        font-extrabold
        text-black
        text-center
        tracking-tight
        leading-tight
    ",
      ),
    ],
    [html.text(text)],
  )
}

pub fn heading_view(text: String) {
  html.h2(
    [
      attribute.class(
        "
        text-2xl
        sm:text-3xl
        font-bold
        text-black
        tracking-tight
    ",
      ),
    ],
    [html.text(text)],
  )
}

pub fn box_view(content: String) {
  html.div(
    [
      attribute.class(
        "
        flex
        items-center
        justify-center
        aspect-square
        border
        border-black
        w-24
        h-24
        p-2
    ",
      ),
    ],
    [html.span([attribute.class("text-3xl")], [html.text(content)])],
  )
}

pub fn game_element_view(title: String, content: String) {
  html.div(
    [attribute.class("flex flex-col items-center justify-center gap-1")],
    [html.text(title), box_view(content)],
  )
}
