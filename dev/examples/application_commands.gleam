import application_command/application_command as command
import application_command/option_value.{
  IntegerValue as IntVal, StringValue as StrVal,
}
import gleam/dict
import gleam/list
import gleam/option
import gleam/string
import interaction/interaction

pub fn chat_input() {
  // --- /ping
  let signature = command.signature(name: "ping", desc: "pongs")

  use _i, _s, _opts <- command.chat_input(signature:, opts: [])

  "Pong!"
  |> command.MessageWithSource
}

pub fn chat_input_group() {
  command.chat_input_group(name: "demo", desc: "demonstration commands")
  |> command.add_subcommand_group(
    command.subcommand_group(name: "hello", desc: "greet the world", sub: [
      // --- /demo hello times [int]
      times_subcommand(),
      // --- /demo hello caps
      caps_subcommand("Hello World!"),
    ]),
  )
  |> command.add_subcommand(
    // --- /demo colours <Red|Green|Blue|Other>
    colour_picker_subcommand(),
  )
  |> command.add_subcommand(
    // --- /demo words <string>
    words_subcommand(),
  )
  |> command.add_subcommand(
    // --- /demo name <string>
    name_subcommand(),
  )
}

fn times_subcommand() {
  let signature =
    command.signature(name: "times", desc: "greets the world a number of times")
  let opts = [
    command.integer_option(
      name: "times",
      desc: "times to say hello",
      details: command.ValueIntegerOption(
        min_value: option.Some(2),
        max_value: option.Some(5),
      ),
    )
    |> command.required(False),
  ]

  use _i, _s, opts <- command.subcommand(signature:, opts:)
  let times = case dict.get(opts, "times") {
    Ok(IntVal(value:, ..)) -> value
    _ -> 2
  }

  list.repeat("Hello World!", times:)
  |> string.join("\n")
  |> command.MessageWithSource
}

fn caps_subcommand(hello_world) {
  let signature =
    command.signature(name: "caps", desc: "greets the world in all caps")

  use _i, _s, _opts <- command.subcommand(signature:, opts: [])

  string.uppercase(hello_world)
  |> command.MessageWithSource
}

fn colour_picker_subcommand() {
  let signature =
    command.signature(name: "colours", desc: "pick your fav. colour")
  let opts = [
    command.string_option(
      name: "colour",
      desc: "your fav colour",
      details: command.ChoicesStringOption(choices: [
        #("Red", "#ff0000"),
        #("Green", "#00ff00"),
        #("Blue", "#0000ff"),
        #("Other", "#7985e2"),
      ]),
    ),
  ]

  use _i, _s, opts <- command.subcommand(signature:, opts:)
  let assert Ok(StrVal(value: colour, ..)) = dict.get(opts, "colour")

  { "You picked the value: `" <> colour <> "` !" }
  |> command.MessageWithSource
}

fn words_subcommand() {
  let signature = command.signature(name: "words", desc: "write a word")
  let opts = [
    command.string_option(
      name: "word",
      desc: "any word",
      details: command.AutocompleteStringOption(
        min_length: option.None,
        max_length: option.None,
        autocomplete: fn(_i, _s, _opts, partial) {
          let case_adjusted_partial = string.capitalise(partial)

          ["Timeline", "Times", "Tinker"]
          |> list.filter(string.starts_with(_, case_adjusted_partial))
          |> list.map(fn(x) { #(x, x) })
        },
      ),
    ),
  ]

  use i, _s, opts <- command.subcommand(signature:, opts:)
  let assert interaction.ApplicationCommand(data: _data, ..) = i
  let assert Ok(StrVal(value: word, ..)) = dict.get(opts, "word")

  { "You picked the word: `" <> word <> "` !" }
  |> command.MessageWithSource
}

fn name_subcommand() {
  let signature = command.signature(name: "name", desc: "greet a name")
  let opts = [
    command.string_option(
      name: "name",
      desc: "name to greet",
      details: command.LengthStringOption(
        min_length: option.Some(1),
        max_length: option.Some(64),
      ),
    ),
  ]

  use _i, _s, opts <- command.subcommand(signature:, opts:)
  let assert Ok(StrVal(value: name, ..)) = dict.get(opts, "name")

  { "Hello " <> name <> "!" }
  |> command.MessageWithSource
}

pub fn user_command() {
  let signature =
    command.signature(name: "high-five", desc: "gives user a high-five")

  use _i, _s <- command.user(signature:)

  { "Someone got a high-five!" }
  |> command.MessageWithSource
}

pub fn message_command() {
  let signature = command.signature(name: "report", desc: "reports a message")

  use _i, _s <- command.message(signature:)

  { "Message reported successfully" }
  |> command.MessageWithSource
}
