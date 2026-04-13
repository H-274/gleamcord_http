import application_command/chat_input as ci
import application_command/chat_input_group as cig
import application_command/message as mc
import application_command/option_definition as opt_def
import application_command/option_value.{
  IntegerValue as IntVal, StringValue as StrVal,
}
import application_command/response as cr
import application_command/signature as cs
import application_command/user as uc
import gleam/dict
import gleam/list
import gleam/string

pub fn chat_input() {
  // --- /ping
  let signature = cs.new(name: "ping", desc: "pongs")

  use _i, _s, _opts <- ci.new(signature:, opts: [])

  "Pong!"
  |> cr.MessageWithSource
}

pub fn slow() {
  // --- /slow
  let signature = cs.new(name: "slow", desc: "delayed response")

  use _i, _s, _opts <- ci.new(signature:, opts: [])

  use <- cr.DeferredMessageWithSource

  // process.sleep(5000)

  "Waited 5 seconds!"
}

pub fn chat_input_group() {
  cig.new(name: "demo", desc: "demonstration commands", subs: [
    cig.subcommand_group(name: "hello", desc: "greet the world", subs: [
      // --- /demo hello times [int]
      times_subcommand(),
      // --- /demo hello caps
      caps_subcommand("Hello World!"),
    ]),
    // --- /demo colours <Red|Green|Blue|Other>
    colour_picker_subcommand() |> cig.subcommand,
    // --- /demo words <string>
    words_subcommand() |> cig.subcommand,
    // --- /demo name <string>
    name_subcommand() |> cig.subcommand,
  ])
}

fn times_subcommand() {
  let signature =
    cs.new(name: "times", desc: "greets the world a number of times")
  let opts = [
    opt_def.Integer(
      name: "times",
      description: "times to say hello",
      required: False,
      details: [opt_def.min_int(2), opt_def.max_int(5)],
    ),
  ]

  use _i, _s, opts <- ci.new(signature:, opts:)
  let times = case dict.get(opts, "times") {
    Ok(IntVal(value:, ..)) -> value
    _ -> 2
  }

  list.repeat("Hello World!", times:)
  |> string.join("\n")
  |> cr.MessageWithSource
}

fn caps_subcommand(hello_world) {
  let signature = cs.new(name: "caps", desc: "greets the world in all caps")

  use _i, _s, _opts <- ci.new(signature:, opts: [])

  string.uppercase(hello_world)
  |> cr.MessageWithSource
}

fn colour_picker_subcommand() {
  let signature = cs.new(name: "colours", desc: "pick your fav. colour")
  let opts = [
    opt_def.StringChoices(
      name: "colour",
      description: "your fav colour",
      required: True,
      choices: [
        #("Red", "#ff0000"),
        #("Green", "#00ff00"),
        #("Blue", "#0000ff"),
        #("Other", "#7985e2"),
      ],
    ),
  ]

  use _i, _s, opts <- ci.new(signature:, opts:)
  let assert Ok(StrVal(value: colour, ..)) = dict.get(opts, "colour")

  { "You picked the value: `" <> colour <> "` !" }
  |> cr.MessageWithSource
}

fn words_subcommand() {
  let signature = cs.new(name: "words", desc: "write a word")
  let opts = [
    opt_def.StringAutocomplete(
      name: "word",
      description: "any word",
      details: [],
      required: True,
      autocomplete: fn(_i, _s, partial, _opts) {
        let case_adjusted_partial = string.capitalise(partial)

        ["Timeline", "Times", "Tinker"]
        |> list.filter(string.starts_with(_, case_adjusted_partial))
        |> list.map(fn(x) { #(x, x) })
      },
    ),
  ]

  use _i, _s, opts <- ci.new(signature:, opts:)
  let assert Ok(StrVal(value: word, ..)) = dict.get(opts, "word")

  { "You picked the word: `" <> word <> "` !" }
  |> cr.MessageWithSource
}

fn name_subcommand() {
  let signature = cs.new(name: "name", desc: "greet a name")
  let opts = [
    opt_def.String(
      name: "name",
      description: "name to greet",
      required: True,
      details: [opt_def.max_length(64)],
    ),
  ]

  use _i, _s, opts <- ci.new(signature:, opts:)
  let assert Ok(StrVal(value: name, ..)) = dict.get(opts, "name")

  { "Hello " <> name <> "!" }
  |> cr.MessageWithSource
}

pub fn user_command() {
  let signature = cs.new(name: "high-five", desc: "gives user a high-five")

  use _i, _s <- uc.new(signature:)

  { "Someone got a high-five!" }
  |> cr.MessageWithSource
}

pub fn message_command() {
  let signature = cs.new(name: "report", desc: "reports a message")

  use _i, _s <- mc.new(signature:)

  { "Message reported successfully" }
  |> cr.MessageWithSource
}
