import application_command/chat_input
import application_command/chat_input_group
import application_command/message
import application_command/option_value.{
  IntegerValue as IntVal, StringValue as StrVal,
}
import application_command/response as command_response
import application_command/signature
import application_command/user
import gleam/dict
import gleam/list
import gleam/option
import gleam/string

pub fn chat_input() {
  // --- /ping
  let signature = signature.new(name: "ping", desc: "pongs")

  use _i, _s, _opts <- chat_input.new(signature:, opts: [])

  "Pong!"
  |> command_response.MessageWithSource
}

pub fn slow() {
  // --- /slow
  let signature = signature.new(name: "slow", desc: "delayed response")

  use _i, _s, _opts <- chat_input.new(signature:, opts: [])

  use <- command_response.DeferredMessageWithSource

  // process.sleep(5000)

  "Waited 5 seconds!"
}

pub fn chat_input_group() {
  chat_input_group.new(name: "demo", desc: "demonstration commands", subs: [
    chat_input_group.subcommand_group(
      name: "hello",
      desc: "greet the world",
      subs: [
        // --- /demo hello times [int]
        times_subcommand(),
        // --- /demo hello caps
        caps_subcommand("Hello World!"),
      ],
    ),
    // --- /demo colours <Red|Green|Blue|Other>
    colour_picker_subcommand() |> chat_input_group.subcommand,
    // --- /demo words <string>
    words_subcommand() |> chat_input_group.subcommand,
    // --- /demo name <string>
    name_subcommand() |> chat_input_group.subcommand,
  ])
}

fn times_subcommand() {
  let signature =
    signature.new(name: "times", desc: "greets the world a number of times")
  let opts = [
    signature.integer_option(
      name: "times",
      desc: "times to say hello",
      details: signature.ValueIntegerOption(
        min_value: option.Some(2),
        max_value: option.Some(5),
      ),
    )
    |> signature.required(False),
  ]

  use _i, _s, opts <- chat_input.new(signature:, opts:)
  let times = case dict.get(opts, "times") {
    Ok(IntVal(value:, ..)) -> value
    _ -> 2
  }

  list.repeat("Hello World!", times:)
  |> string.join("\n")
  |> command_response.MessageWithSource
}

fn caps_subcommand(hello_world) {
  let signature =
    signature.new(name: "caps", desc: "greets the world in all caps")

  use _i, _s, _opts <- chat_input.new(signature:, opts: [])

  string.uppercase(hello_world)
  |> command_response.MessageWithSource
}

fn colour_picker_subcommand() {
  let signature = signature.new(name: "colours", desc: "pick your fav. colour")
  let opts = [
    signature.string_option(
      name: "colour",
      desc: "your fav colour",
      details: signature.ChoicesStringOption(choices: [
        #("Red", "#ff0000"),
        #("Green", "#00ff00"),
        #("Blue", "#0000ff"),
        #("Other", "#7985e2"),
      ]),
    ),
  ]

  use _i, _s, opts <- chat_input.new(signature:, opts:)
  let assert Ok(StrVal(value: colour, ..)) = dict.get(opts, "colour")

  { "You picked the value: `" <> colour <> "` !" }
  |> command_response.MessageWithSource
}

fn words_subcommand() {
  let signature = signature.new(name: "words", desc: "write a word")
  let opts = [
    signature.string_option(
      name: "word",
      desc: "any word",
      details: signature.AutocompleteStringOption(
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

  use _i, _s, opts <- chat_input.new(signature:, opts:)
  let assert Ok(StrVal(value: word, ..)) = dict.get(opts, "word")

  { "You picked the word: `" <> word <> "` !" }
  |> command_response.MessageWithSource
}

fn name_subcommand() {
  let signature = signature.new(name: "name", desc: "greet a name")
  let opts = [
    signature.string_option(
      name: "name",
      desc: "name to greet",
      details: signature.LengthStringOption(
        min_length: option.Some(1),
        max_length: option.Some(64),
      ),
    ),
  ]

  use _i, _s, opts <- chat_input.new(signature:, opts:)
  let assert Ok(StrVal(value: name, ..)) = dict.get(opts, "name")

  { "Hello " <> name <> "!" }
  |> command_response.MessageWithSource
}

pub fn user_command() {
  let signature =
    signature.new(name: "high-five", desc: "gives user a high-five")

  use _i, _s <- user.new(signature:)

  { "Someone got a high-five!" }
  |> command_response.MessageWithSource
}

pub fn message_command() {
  let signature = signature.new(name: "report", desc: "reports a message")

  use _i, _s <- message.new(signature:)

  { "Message reported successfully" }
  |> command_response.MessageWithSource
}
