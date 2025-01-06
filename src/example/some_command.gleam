import bot.{type Bot}
import command/chat_input_command.{type ChatInputCommand} as cic
import command/command_option as co
import command/message_command.{type MessageCommand} as mc
import command/user_command.{type UserCommand} as uc
import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import gleam/result
import interaction
import locale

pub fn create() -> ChatInputCommand(Nil) {
  cic.new_tree(
    name: "create",
    desc: "",
    integration_types: [interaction.GuildInstall],
    contexts: [interaction.Guild],
  )
  |> cic.tree_sub_commands([event()])
}

fn event() -> cic.SubCommandNode(Nil) {
  let command =
    cic.new_sub_command(name: "event", desc: "")
    |> cic.sub_command_options([
      co.new_string_def(name: "name", desc: "")
        |> co.string_def_required()
        |> co.string_def(),
      co.new_user_def(name: "host", desc: "")
        |> co.user_def,
    ])

  use i, bot, ctx, opts <- cic.sub_command_handler(command)
  use name <- result.try(
    co.extract_string(opts, "name")
    |> result.replace_error(cic.InvalidParam("name")),
  )
  let host = co.extract_user(opts, "host") |> option.from_result()

  event_run(i, bot, ctx, name, host)
}

fn event_run(_i, _bot: Bot, _ctx: Nil, _name: String, _host: Option(Dynamic)) {
  Error(cic.NotImplemented)
}

pub fn greet() -> UserCommand(Nil) {
  let command =
    uc.new(
      name: "greet",
      integration_types: [interaction.GuildInstall],
      contexts: [interaction.Guild],
    )
    |> uc.name_locales([#(locale.French, "saluer")])

  use _i, _bot, _ctx <- uc.handler(command)
  Error(uc.NotImplemented)
}

pub fn delete() -> MessageCommand(Nil) {
  let command =
    mc.new(
      name: "delete",
      integration_types: [interaction.GuildInstall],
      contexts: [interaction.Guild],
    )
    |> mc.name_locales([#(locale.French, "supprimer")])

  use _i, _bot, _ctx <- mc.handler(command)
  Error(mc.NotImplemented)
}
