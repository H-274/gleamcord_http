import interaction/application_command/message
import interaction/application_command/user
import interaction/response

pub fn chat_input_command() {
  todo
}

pub fn chat_input_command_tree() {
  todo
}

pub fn message_command() {
  let command =
    message.new_command("save", "saves a message", [], [])
    |> message.command_name_locales([#("fr-fr", "sauvegarde")])

  use _i, _bot <- message.with_command_handler(command)

  Error(response.NotImplemented)
}

pub fn user_command() {
  let command =
    user.new_command("save", "saves a user", [], [])
    |> user.command_name_locales([#("fr-fr", "sauvegarde")])

  use _i, _bot <- user.with_command_handler(command)

  Error(response.NotImplemented)
}
