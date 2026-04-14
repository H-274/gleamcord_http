import application_command/chat_input
import application_command/option_definition
import application_command/option_value.{StringValue}
import application_command/response as command_response
import application_command/signature
import component/content
import component/layout
import gleam/dict
import gleam/int
import gleam/string
import message

pub fn ping() {
  // --- /ping
  let signature = signature.new(name: "ping", desc: "pongs")

  use _i, _s, _opts <- chat_input.new(signature:, opts: [])

  "Pong!"
  |> message.NewText([message.Ephemeral])
  |> command_response.MessageWithSource
}

pub fn slow() {
  // --- /slow
  let signature = signature.new(name: "slow", desc: "delayed response")

  use _i, _s, _opts <- chat_input.new(signature:, opts: [])

  use <- command_response.DeferredMessageWithSource

  // process.sleep(5000)

  "Waited 5 seconds!"
  |> message.NewText([message.Ephemeral])
}

pub fn greeting() {
  // --- /hello
  let signature = signature.new(name: "hello", desc: "greets the name")
  let opts = [
    option_definition.String(
      name: "name",
      description: "name to greet",
      required: True,
      details: [option_definition.min_length(1)],
    ),
  ]

  use _i, _s, opts <- chat_input.new(signature:, opts:)
  let assert Ok(StringValue(name, ..)) = dict.get(opts, "name")

  [
    message.RootContainer(layout.Container(
      components: [
        layout.ContainerText("Hello " <> name),
        layout.ContainerSeparator(layout.LargeSeparator(False)),
        layout.ContainerText("This is a component message!"),
      ],
      accent: 0xffffff,
      spoiler: False,
    )),
  ]
  |> message.NewComponent([message.Ephemeral])
  |> command_response.MessageWithSource
}

/// To be used in chat_input_group examples
pub fn colour() {
  let signature = signature.new("colour", desc: "favourite colour")
  let opts = [
    option_definition.StringAutocomplete(
      name: "colour",
      description: "using hex format",
      required: True,
      details: [
        option_definition.min_length(7),
        option_definition.max_length(7),
      ],
      autocomplete: colour_autocomplete,
    ),
  ]

  use _i, _s, opts <- chat_input.new(signature:, opts:)
  let assert Ok(StringValue(value: colour, ..)) = dict.get(opts, "colour")

  let bad_format_response =
    { "Unexpected format" }
    |> message.NewText([message.Ephemeral])
    |> command_response.MessageWithSource

  case colour {
    "#" <> rest ->
      case int.parse("0x" <> rest) {
        Ok(val) if val >= 0 ->
          [message.RootContainer(colour_component(colour, rest, val))]
          |> message.NewComponent([message.SuppressNotifications])
          |> command_response.MessageWithSource
        _ -> bad_format_response
      }

    _ -> bad_format_response
  }
}

fn colour_autocomplete(_interaction, _state, partial: String, _opts) {
  let default = [#("#FFFFFF", "#FFFFFF")]

  case partial {
    "#" <> rest -> {
      let padded = string.pad_end(rest, 6, "F")
      case int.parse("0x" <> padded) {
        Ok(val) if val >= 0 -> [#("#" <> padded, "#" <> padded)]
        _ -> default
      }
    }
    _ -> default
  }
}

fn colour_component(colour, rest, val) {
  let text_colour = 0xffffff - val |> int.to_base16
  layout.Container(
    components: [
      layout.ContainerSection(
        layout.Section(
          components: ["Chosen colour was: " <> colour],
          accessories: [
            layout.SectionThumbnail(content.Thumbnail(
              "https://placehold.co/150/"
                <> rest
                <> "/"
                <> text_colour
                <> "/jpeg",
              description: "",
              spoiler: False,
            )),
          ],
        ),
      ),
    ],
    accent: val,
    spoiler: False,
  )
}

/// To be used in chat_input_group examples
pub fn adventure() {
  let signature =
    signature.new(name: "adventure", desc: "favourite adventure game")
  let opts = [
    option_definition.String(
      name: "title",
      description: "title of your fav. adventure game",
      required: True,
      details: [],
    ),
  ]

  use _i, _s, opts <- chat_input.new(signature:, opts:)
  let assert Ok(StringValue(value: title, ..)) = dict.get(opts, "title")

  { title <> " sounds really interesting, tell me more!" }
  |> message.NewText([])
  |> command_response.MessageWithSource
}
