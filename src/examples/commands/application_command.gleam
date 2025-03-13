import interaction/application_command/chat_input
import interaction/application_command/message
import interaction/application_command/user
import interaction/response

pub fn chat_input_command() {
  let builder = chat_input.new_command_builder("ping", "pongs", [], [])
  let params = []

  use _i, _params, _bot <- chat_input.with_command_handler(builder, params)

  use message <- response.new_message_reply()
  response.Message(..message, content: "Pong", components: [], embeds: [])
}

pub fn chat_input_command_tree() {
  chat_input.new_command_builder("set", "sets a value", [], [])
  |> chat_input.command_tree([
    chat_input_command_tree_group([chat_input_command_tree_leaf()]),
  ])
}

pub fn chat_input_command_tree_group(
  sub_commands: List(chat_input.CommandTree(_)),
) {
  chat_input.new_command_node("player", "player setters")
  |> chat_input.node_options(sub_commands)
}

pub fn chat_input_command_tree_leaf() {
  let leaf = chat_input.new_command_leaf("name", "sets players name")
  let params = []

  use _i, _params, _bot <- chat_input.with_leaf_handler(leaf, params)

  Error(response.NotImplemented)
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
