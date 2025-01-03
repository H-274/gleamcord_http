import command/chat_input
import command/command_option
import command/handler
import gleam/option.{type Option}
import gleam/result
import locale

pub fn root_command() -> chat_input.Command(ctx) {
  let comm =
    chat_input.new_command(name: "Hello", desc: "World")
    |> chat_input.command_locales([#(locale.French, "Bonjour", "Monde")])
    |> chat_input.command_contexts([1, 2])

  use i, bot, ctx, opts <- chat_input.command_handler(comm, [
    command_option.new_integer_def("age", "your age", [], option.None)
      |> command_option.integer_min_val(1)
      |> command_option.integer_max_val(150)
      |> command_option.required(),
    command_option.new_string_def("optional", "uhhhhh", [], option.None),
  ])

  use age <- result.try(
    command_option.extract_integer(from: opts, name: "age")
    |> result.map(fn(x) { x.0 })
    |> result.replace_error(handler.Silent("Bad argument: \"age\"")),
  )
  let optional =
    command_option.extract_string(from: opts, name: "optional")
    |> result.map(fn(x) { x.0 })
    |> option.from_result()

  run(i, bot, ctx, age, optional)
}

fn run(_i, _bot, _ctx, _age: Int, _optional: Option(String)) {
  Error(handler.NotImplemented)
}

pub fn command_group() -> chat_input.Command(ctx) {
  chat_input.new_command(name: "Hello", desc: "World")
  |> chat_input.command_locales([#(locale.French, "Bonjour", "Monde")])
  |> chat_input.command_contexts([1, 2])
  |> chat_input.command_sub_commands([sub1(), group1([sub2()])])
}

fn sub1() {
  let sub =
    chat_input.new_sub_command(name: "sub1", desc: "sub1")
    |> chat_input.sub_command_locales([])

  use _, _, _, _ <- chat_input.sub_command_handler(sub, [])
  // Some code ...
  Error(handler.NotImplemented)
}

fn group1(commands: List(chat_input.SubCommandTree(ctx))) {
  chat_input.new_sub_command_group(name: "group1", desc: "group1")
  |> chat_input.sub_command_group_locales([])
  |> chat_input.sub_command_group_sub_trees(commands)
}

fn sub2() {
  let sub =
    chat_input.new_sub_command(name: "sub2", desc: "sub2")
    |> chat_input.sub_command_locales([])

  use _, _, _, _ <- chat_input.sub_command_handler(sub, [])
  // Some code ...
  Error(handler.NotImplemented)
}
