import command/chat_input
import command/handler
import locale

pub fn temp() -> chat_input.Definition(ctx) {
  let comm =
    chat_input.new_definition(name: "Hello", desc: "World")
    |> chat_input.definition_locales([#(locale.French, "Bonjour", "Monde")])
    |> chat_input.definition_contexts([1, 2])

  use _i, _bot, _ctx, _opts <- chat_input.definition_options_handler(comm, [])
  Error(handler.NotImplemented)
}

pub fn temp1() -> chat_input.Definition(ctx) {
  chat_input.new_definition(name: "Hello", desc: "World")
  |> chat_input.definition_locales([#(locale.French, "Bonjour", "Monde")])
  |> chat_input.definition_contexts([1, 2])
  |> chat_input.definition_sub_commands([sub1(), group1([sub2()])])
}

fn sub1() {
  let sub =
    chat_input.new_sub_command(name: "sub1", desc: "sub1")
    |> chat_input.sub_command_locales([])

  use _i, _bot, _ctx, _opts <- chat_input.sub_command_handler_definition(
    sub,
    [],
  )
  // Some code ...
  Error(handler.NotImplemented)
}

fn group1(commands: List(chat_input.SubCommandTreeDefinition(ctx))) {
  chat_input.new_sub_command_group(name: "group1", desc: "group1")
  |> chat_input.sub_command_group_locales([])
  |> chat_input.sub_command_group_definition(commands)
}

fn sub2() {
  let sub =
    chat_input.new_sub_command(name: "sub2", desc: "sub2")
    |> chat_input.sub_command_locales([])

  use _i, _bot, _ctx, _opts <- chat_input.sub_command_handler_definition(
    sub,
    [],
  )
  // Some code ...
  Error(handler.NotImplemented)
}
