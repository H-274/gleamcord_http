import command/command
import command/option_value
import command/response
import component/content
import component/layout
import gleam/dict
import gleam/int
import gleam/string
import message

pub fn ping() {
  let sig = command.simple_signature(name: "ping", desc: "Pongs!")

  use _i, _s, _o <- command.chat_input(sig:, opts: [])

  { "Pong!" }
  |> message.NewText([])
  |> response.MessageWithSource
}

pub fn high_five() {
  let signature =
    command.simple_signature(name: "high_five", desc: "High five this user")

  use _i, _s <- command.User(signature:)

  { todo as "mention user" }
  |> message.NewText([])
  |> response.MessageWithSource
}

pub fn report_message() {
  let signature =
    command.simple_signature(name: "report", desc: "Report this message")

  use _i, _s <- command.Message(signature:)

  use <- response.DeferredMessageWithSource

  // process.sleep(5000)

  { "Message reported" }
  |> message.NewText([message.Ephemeral])
}

const hex_option = command.StringAutocompleteOption(
  name: "hex",
  description: "hex code of your colour",
  min_len: 7,
  max_len: 7,
  autocomplete: colour_autocomplete,
  required: True,
)

const default_suggestion = [
  #("white", "#ffffff"),
  #("red", "#ff0000"),
  #("yellow", "#ffff00"),
  #("pink", "#ff00ff"),
  #("green", "#00ff00"),
  #("aqua", "#00ffff"),
  #("blue", "#0000ff"),
  #("black", "#000000"),
]

fn colour_autocomplete(_i, _s, partial, _o) {
  case partial {
    "#" <> rest ->
      case int.base_parse(rest, 16) {
        Ok(value) if value >= 0 -> {
          let suggestion_w = "#" <> string.pad_end(rest, 6, "f")
          let suggestion_b = "#" <> string.pad_end(rest, 6, "0")
          [#(suggestion_w, suggestion_w), #(suggestion_b, suggestion_b)]
        }
        _ -> default_suggestion
      }
    _ -> default_suggestion
  }
}

const default_colour_response = message.NewText(
  "Invalid colour",
  [message.Ephemeral],
)

pub fn colour() {
  let sig =
    command.simple_signature(name: "colour", desc: "choose your fav colour")
  let opts = [hex_option]

  use _i, _s, o <- command.chat_input(sig:, opts:)
  let assert Ok(option_value.String(value: hex, ..)) =
    dict.get(o, hex_option.name)

  case hex {
    "#" <> rest ->
      case int.base_parse(rest, 16) {
        Ok(value) if value >= 0 ->
          [colour_container(hex, rest, value)]
          |> message.NewComponent([message.SuppressNotifications])
          |> response.MessageWithSource
        _ -> default_colour_response |> response.MessageWithSource
      }
    _ -> default_colour_response |> response.MessageWithSource
  }
}

fn colour_container(hex: String, rest: String, value: Int) {
  message.root_container(
    components: [
      layout.container_section(
        components: ["Selected the following colour: " <> hex],
        accessories: [
          layout.section_thumbnail(
            media: "https://placehold.co/150/" <> rest <> "/jpeg",
            description: hex,
            spoiler: False,
          ),
        ],
      ),
      layout.container_large_separator(divider: True),
      layout.ContainerText("**Great choice!**"),
    ],
    accent: value,
    spoiler: False,
  )
}
