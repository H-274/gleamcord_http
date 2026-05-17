import command/command
import command/interaction
import command/option_value.{IntegerValue as IntVal, StringValue as StrVal}
import component/layout
import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import message

pub fn greet() {
  let sig = command.simple_signature(name: "greet", desc: "")

  use i, _s <- command.user(sig:)
  let assert interaction.User(data) = i.data

  { "Hello <@" <> data.target_id <> ">!" }
  |> message.NewText(flags: [])
  |> command.MessageResponse
}

pub fn report() {
  let sig = command.simple_signature(name: "report", desc: "")

  use i, _s <- command.message(sig:)
  let assert interaction.Message(data) = i.data

  { "Successfully reported message with id: `" <> data.target_id <> "`" }
  |> message.NewText(flags: [message.Ephemeral])
  |> command.MessageResponse
}

const hex_opt = command.StringAutocompleteOption(
  name: "hex",
  description: "hex code for a colour",
  min_len: 6,
  max_len: 6,
  required: True,
  autocomplete: hex_autocomplete,
)

const color_suggestions = [
  #("red", "ff0000"),
  #("green", "00ff00"),
  #("blue", "0000ff"),
]

fn hex_autocomplete(_interaction, _options, partial, _state) {
  case int.base_parse(partial, 16) {
    Ok(val) if val >= 0 -> {
      let pad_0 = string.pad_end(partial, 6, "0")
      let pad_f = string.pad_end(partial, 6, "f")
      [#(pad_0, pad_0), #(pad_f, pad_f)]
    }
    _ -> color_suggestions
  }
}

pub fn colour() {
  let sig = command.simple_signature(name: "colour", desc: "choose a colour")
  let opts = [hex_opt]

  use _i, o, _s <- command.chat_input(sig:, opts:)
  let assert Ok(StrVal(value: hex_string, ..)) = dict.get(o, hex_opt.name)

  case int.base_parse(hex_string, 16) {
    Ok(val) if val > 0 ->
      [colour_container(hex_string, val)]
      |> message.NewComponent(flags: [])
    _ ->
      "Invalid hex value"
      |> message.NewText(flags: [message.Ephemeral])
  }
  |> command.MessageResponse
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

const name_opt = command.StringOption(
  name: "name",
  description: "name to greet",
  required: True,
  min_len: 1,
  max_len: 100,
)

pub fn group() {
  let sig = command.simple_signature(name: "hello", desc: "")

  command.group(sig:, elements: [
    // --- /hello name ... (can't be called)
    command.group_element(name: "name", desc: "", sub: [
      // --- /hello name repeat <name:string> <times:int>
      hello_name_repeat(),
      // --- /hello name caps <name:string>
      hello_name_caps(),
    ]),
    // --- /hello world
    hello_world()
      |> command.subcommand_element,
  ])
}

fn hello_name_repeat() {
  let times_opt = command.IntegerOption("times", "", True, 0, 5)
  let opts = [name_opt, times_opt]

  use _i, o, _s <- command.subcommand(name: "repeat", desc: "", opts:)
  let assert Ok(StrVal(value: name, ..)) = dict.get(o, name_opt.name)
  let assert Ok(IntVal(value: times, ..)) = dict.get(o, times_opt.name)

  list.repeat("Hello " <> name, times:)
  |> string.join(", ")
  |> message.NewText(flags: [])
  |> command.MessageResponse
}

fn hello_name_caps() {
  let opts = [name_opt]

  use _i, o, _s <- command.subcommand(name: "caps", desc: "", opts:)
  let assert Ok(StrVal(value: name, ..)) = dict.get(o, name_opt.name)

  string.capitalise(name)
  |> message.NewText(flags: [])
  |> command.MessageResponse
}

fn hello_world() {
  // --- /hello world
  use _i, _o, _s <- command.subcommand(name: "world", desc: "", opts: [])

  { "Hello world! " }
  |> message.NewText(flags: [message.Ephemeral])
  |> command.MessageResponse
}
