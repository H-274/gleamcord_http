import command/message_command.{type MessageCommand}
import command/user_command.{type UserCommand}
import interaction
import locale

pub fn greet() -> UserCommand(Nil) {
  let command =
    user_command.new(
      name: "greet",
      integration_types: [interaction.GuildInstall],
      contexts: [interaction.Guild],
    )
    |> user_command.name_locales([#(locale.French, "saluer")])

  use _i, _bot, _ctx <- user_command.handler(command)
  Error(user_command.NotImplemented)
}

pub fn delete() -> MessageCommand(Nil) {
  let command =
    message_command.new(
      name: "delete",
      integration_types: [interaction.GuildInstall],
      contexts: [interaction.Guild],
    )
    |> message_command.name_locales([#(locale.French, "supprimer")])

  use _i, _bot, _ctx <- message_command.handler(command)
  Error(message_command.NotImplemented)
}
