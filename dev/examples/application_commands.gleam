import application_commands.{IntegerValue as IntVal, StringValue as StrVal} as command
import gleam/dict
import gleam/list
import gleam/string

pub fn chat_input() {
  // --- /ping
  let signature = command.signature(name: "ping", desc: "pongs")

  use _i, _opts <- command.chat_input(signature:, opts: [])

  "Pong!"
}

pub fn colour_picker() {
  let signature =
    command.signature(name: "colours", desc: "pick your fav. colour")
  let opts = [
    command.string_option(name: "colour", desc: "your fav colour")
    |> command.string_choices([
      #("Red", "#ff0000"),
      #("Green", "#00ff00"),
      #("Blue", "#0000ff"),
      #("Other", "#7985e2"),
    ]),
  ]

  use _i, opts <- command.chat_input(signature:, opts:)
  let assert Ok(StrVal(colour)) = dict.get(opts, "colour")

  "You picked the value: `" <> colour <> "` !"
}

pub fn chat_input_group() {
  command.chat_input_group(name: "hello", desc: "greeting commands")
  |> command.add_subcommand_group(
    command.subcommand_group(name: "world", desc: "greet the world", sub: [
      // --- /hello world times [int]
      times_subcommand(),
      // --- /hello world caps
      caps_subcommand("Hello World!"),
    ]),
  )
  |> command.add_subcommand(
    // --- /hello name <string>
    name_subcommand(),
  )
}

fn times_subcommand() {
  let signature =
    command.signature(name: "times", desc: "greets the world a number of times")
  let opts = [
    command.integer_option(name: "times", desc: "times to say hello")
    |> command.integer_min_value(2)
    |> command.integer_max_value(5)
    |> command.required(False),
  ]

  use _i, opts <- command.subcommand(signature:, opts:)
  let times = case dict.get(opts, "times") {
    Ok(IntVal(val)) -> val
    _ -> 2
  }

  list.repeat("Hello World!", times:)
  |> string.join("\n")
}

fn caps_subcommand(hello_world) {
  let signature =
    command.signature(name: "caps", desc: "greets the world in all caps")

  use _i, _opts <- command.subcommand(signature:, opts: [])

  string.uppercase(hello_world)
}

fn name_subcommand() {
  let signature = command.signature(name: "name", desc: "greet a name")
  let opts = [
    command.string_option(name: "name", desc: "name to greet")
    |> command.min_length(1)
    |> command.max_length(64),
  ]

  use _i, opts <- command.subcommand(signature:, opts:)
  let assert Ok(StrVal(name)) = dict.get(opts, "name")

  "Hello " <> name <> "!"
}
