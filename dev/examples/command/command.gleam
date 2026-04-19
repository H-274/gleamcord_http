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
  let signature = command.simple_signature(name: "ping", desc: "Pongs!")

  use _i, _s, _o <- command.ChatInput(signature:, options: dict.from_list([]))

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

const hex_option = command.StringAutocompleteOption(
  name: "hex",
  description: "hex code of your colour",
  min_len: 7,
  max_len: 7,
  autocomplete: colour_autocomplete,
  required: True,
)

const default_suggestion = [#("#ffffff", "#ffffff")]

fn colour_autocomplete(_i, _s, partial, _o) {
  case partial {
    "#" <> rest ->
      case int.base_parse(rest, 16) {
        Ok(value) if value >= 0 -> {
          let suggestion = "#" <> string.pad_end(rest, 6, "f")
          [#(suggestion, suggestion)]
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
  let signature =
    command.simple_signature(name: "colour", desc: "choose your fav colour")
  let options =
    [#(hex_option.name, hex_option)]
    |> dict.from_list()

  use _i, _s, o <- command.ChatInput(signature:, options:)
  let assert Ok(option_value.String(value: hex, ..)) =
    dict.get(o, hex_option.name)

  case hex {
    "#" <> rest ->
      case int.base_parse(rest, 16) {
        Ok(value) if value >= 0 ->
          [message.RootContainer(colour_container(hex, rest, value))]
          |> message.NewComponent([message.SuppressNotifications])
          |> response.MessageWithSource
        _ -> default_colour_response |> response.MessageWithSource
      }
    _ -> default_colour_response |> response.MessageWithSource
  }
}

fn colour_container(hex: String, rest: String, value: Int) -> layout.Container {
  layout.Container(
    components: [
      layout.ContainerSection(
        layout.Section(
          components: ["Selected the following colour: " <> hex],
          accessories: [
            layout.SectionThumbnail(content.Thumbnail(
              media: "https://placehold.co/150/" <> rest <> "/jpeg",
              description: hex,
              spoiler: False,
            )),
          ],
        ),
      ),
      layout.ContainerSeparator(layout.LargeSeparator(divider: True)),
      layout.ContainerText("**Great choice!**"),
    ],
    accent: value,
    spoiler: False,
  )
}
