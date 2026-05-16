import command/command
import command/interaction.{MessageData, UserData}
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
  let assert interaction.User(UserData(target_id: target, ..)) = i.data

  { "Hello <@" <> target <> ">!" }
  |> message.NewText(flags: [])
  |> command.MessageResponse
}

pub fn report() {
  let sig = command.simple_signature(name: "report", desc: "")

  use i, _s <- command.message(sig:)
  let assert interaction.Message(MessageData(target_id: target, ..)) = i.data

  { "Successfully reported message with id: `" <> target <> "`" }
  |> message.NewText(flags: [message.Ephemeral])
  |> command.MessageResponse
}

/// TODO complete
const hex_opt = command.StringAutocomplete(name: "hex")

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

const name_opt = command.String("name")

pub fn group() {
  let sig = command.simple_signature(name: "hello", desc: "")

  command.group(sig:, elements: [
    // --- /hello name ... (can't be called)
    command.group_element(name: "name", desc: "", sub: [
      {
        let times_opt = command.Integer("times")
        let opts = [name_opt, times_opt]
        // --- /hello name repeat <name:string> <times:int>
        use _i, o, _s <- command.subcommand(name: "repeat", desc: "", opts:)
        let assert Ok(StrVal(value: name, ..)) = dict.get(o, name_opt.name)
        let assert Ok(IntVal(value: times, ..)) = dict.get(o, times_opt.name)

        list.repeat("Hello " <> name, times: times)
        |> string.join(", ")
        |> message.NewText(flags: [])
        |> command.MessageResponse
      },
      {
        let opts = [name_opt]
        // --- /hello name caps <name:string>
        use _i, o, _s <- command.subcommand(name: "caps", desc: "", opts:)
        let assert Ok(StrVal(value: name, ..)) = dict.get(o, name_opt.name)

        string.capitalise(name)
        |> message.NewText(flags: [])
        |> command.MessageResponse
      },
    ]),
    command.subcommand_element({
      // --- /hello world
      use _i, _o, _s <- command.subcommand(name: "world", desc: "", opts: [])
      { "Hello world! " }
      |> message.NewText(flags: [message.Ephemeral])
      |> command.MessageResponse
    }),
  ])
}
