import command/command
import command/interaction
import command/option_value
import command/response
import component/layout
import gleam/dict
import gleam/int
import gleam/string
import message

pub fn ping() -> command.ChatInput(state) {
  let sig = command.simple_signature(name: "ping", desc: "Pongs!")

  use _interaction, _state, _options <- command.chat_input(sig:, opts: [])

  { "content: \"Pong!\"" }
  |> message.Raw(json: _)
  |> response.MessageWithSource
}

pub fn high_five() -> command.Command(state) {
  let sig =
    command.simple_signature(name: "high_five", desc: "High five this user")

  use interaction, _state <- command.user(sig:)
  let assert interaction.User(data) = interaction.data

  { "High five <@" <> data.target_id <> "> !" }
  |> message.NewText(flags: [])
  |> response.MessageWithSource
}

pub fn report_message() -> command.Command(state) {
  let sig =
    command.simple_signature(name: "report", desc: "Report this message")

  use _interaction, _state <- command.message(sig:)

  use <- response.DeferredMessageWithSource

  // process.sleep(5000)

  { "Message reported" }
  |> message.NewText(flags: [message.Ephemeral])
}

const hex_option = command.StringAutocompleteOption(
  name: "hex",
  description: "hex code of your colour",
  min_len: 6,
  max_len: 6,
  autocomplete: colour_autocomplete,
  required: True,
)

fn colour_autocomplete(_interaction, _state, partial, _options) {
  case int.base_parse(partial, 16) {
    Ok(value) if value >= 0 -> {
      let suggestion_w = string.pad_end(partial, 6, "f")
      let suggestion_b = string.pad_end(partial, 6, "0")
      [#(suggestion_w, suggestion_w), #(suggestion_b, suggestion_b)]
    }
    _ -> [
      #("white", "ffffff"),
      #("red", "ff0000"),
      #("yellow", "ffff00"),
      #("pink", "ff00ff"),
      #("green", "00ff00"),
      #("aqua", "00ffff"),
      #("blue", "0000ff"),
      #("black", "000000"),
    ]
  }
}

pub fn colour() -> command.ChatInput(state) {
  let sig =
    command.simple_signature(name: "colour", desc: "choose your fav colour")
  let opts = [hex_option]

  use _interaction, _state, options <- command.chat_input(sig:, opts:)
  let assert Ok(option_value.String(value: hex, ..)) =
    dict.get(options, hex_option.name)

  case int.base_parse(hex, 16) {
    Ok(value) if value >= 0 ->
      [colour_container(hex, value)]
      |> message.NewComponent(flags: [message.SuppressNotifications])
      |> response.MessageWithSource
    _ ->
      "Invalid colour, please try again. Make sure all the characters are from 0-9 or a-f"
      |> message.NewText(flags: [message.Ephemeral])
      |> response.MessageWithSource
  }
}

fn colour_container(hex: String, value: Int) -> message.ComponentRoot {
  message.root_container(
    components: [
      layout.container_section(
        components: ["Selected the following colour: " <> hex],
        accessories: [
          layout.section_thumbnail(
            media: "https://placehold.co/150/" <> hex <> "/jpeg",
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

const game_title = command.StringOption(
  name: "title",
  description: "game title",
  min_len: 1,
  max_len: 100,
  required: True,
)

pub fn adventure() {
  let sig =
    command.simple_signature(
      name: "adventure",
      desc: "favourite adventure game",
    )
  let opts = [game_title]

  use _interaction, _state, options <- command.chat_input(sig:, opts:)
  let assert Ok(option_value.String(value: title, ..)) =
    dict.get(options, game_title.name)

  { title <> " is a good adventure! Tell me more!" }
  |> message.NewText(flags: [])
  |> response.MessageWithSource
}

pub fn favourite() {
  command.chat_input_group(
    name: "favourite",
    desc: "questions about favourites",
    sub: [
      // --- /favourite colour <hex:string>
      colour() |> command.subcommand,
      command.subcommand_group(
        name: "games",
        desc: "questions about fav games",
        sub: [
          // --- /favourite games adventure <title:string>
          adventure(),
        ],
      ),
    ],
  )
}
