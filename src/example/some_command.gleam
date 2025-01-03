import command/chat_input
import command/handler
import locale

pub fn temp() -> chat_input.Command(ctx) {
  let comm =
    chat_input.new_command(name: "Hello", desc: "World")
    |> chat_input.command_locales([#(locale.French, "Bonjour", "Monde")])
    |> chat_input.command_contexts([1, 2])

  use _i, _bot, _ctx, _opts <- chat_input.command_handler(comm, [])
  // Some code ...
  Error(handler.NotImplemented)
}

pub fn temp1() -> chat_input.Command(ctx) {
  chat_input.new_command(name: "Hello", desc: "World")
  |> chat_input.command_locales([#(locale.French, "Bonjour", "Monde")])
  |> chat_input.command_contexts([1, 2])
  |> chat_input.command_sub_commands([sub1(), group1([sub2()])])
}

fn sub1() {
  let sub =
    chat_input.new_sub_command(name: "sub1", desc: "sub1")
    |> chat_input.sub_command_locales([])

  use _i, _bot, _ctx, _opts <- chat_input.sub_command_handler(sub, [])
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

  use _i, _bot, _ctx, _opts <- chat_input.sub_command_handler(sub, [])
  // Some code ...
  Error(handler.NotImplemented)
}
