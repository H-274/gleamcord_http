import command/chat_input
import command/command_option
import command/handler
import gleam/option.{type Option}
import gleam/result
import locale

pub fn root_command() -> chat_input.Command(Nil) {
  let command =
    chat_input.new_command(name: "Hello", desc: "World")
    |> chat_input.command_locales([#(locale.French, "Bonjour", "Monde")])
    |> chat_input.command_contexts([1, 2])
  use i, bot, _, opts <- chat_input.command_handler(command, [
    command_option.new_integer_def(
      name: "age",
      desc: "your age",
      choices: [1, 2, 6, 10, 69],
      autocomplete: option.None,
    )
      |> command_option.integer_min_val(1)
      |> command_option.integer_max_val(150)
      |> command_option.required(),
    command_option.new_string_def(
      name: "optional",
      desc: "uhhhhh",
      choices: ["Your mom"],
      autocomplete: option.None,
    ),
  ])

  use age <- result.try(
    command_option.extract_integer(from: opts, name: "age")
    |> result.replace_error(handler.Silent("Bad argument: \"age\"")),
  )
  let optional =
    command_option.extract_string(from: opts, name: "optional")
    |> option.from_result()

  run(i, bot, age, optional)
}

fn run(_i, _bot, _age: Int, _optional: Option(String)) {
  Error(handler.NotImplemented)
}

pub fn create() -> chat_input.Command(ctx) {
  chat_input.new_command(name: "create", desc: "")
  |> chat_input.command_contexts([1, 2])
  |> chat_input.command_sub_commands([channel(), events([dance_event()])])
}

fn channel() {
  let sub = chat_input.new_sub_command(name: "channel", desc: "")
  use _, _, _, _ <- chat_input.sub_command_handler(sub, [])
  // Some code ...
  Error(handler.NotImplemented)
}

fn events(commands: List(chat_input.SubCommandTree(ctx))) {
  chat_input.new_sub_command_group(name: "events", desc: "")
  |> chat_input.sub_command_group_sub_trees(commands)
}

fn dance_event() {
  let sub = chat_input.new_sub_command(name: "dance_event", desc: "")
  use _, _, _, _ <- chat_input.sub_command_handler(sub, [])
  // Some code ...
  Error(handler.NotImplemented)
}
