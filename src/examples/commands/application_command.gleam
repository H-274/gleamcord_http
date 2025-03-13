import interaction/application_command as ac
import interaction/response

pub fn chat_input_command() -> ac.ApplicationCommand(_) {
  let def =
    ac.CommandDefinition(
      ..ac.new_definition(name: "ping", desc: "pongs", integs: [], contexts: []),
      name_locales: [],
    )
  let params = []

  use _i, _params, _bot <- ac.chat_input_command(def, params)

  // Replace with your command logic
  Error(response.NotImplemented)
}

pub fn chat_input_command_tree() -> ac.ApplicationCommand(_) {
  let def =
    ac.CommandDefinition(
      ..ac.new_definition(
        name: "tree",
        desc: "names the invoked command branch",
        integs: [],
        contexts: [],
      ),
      name_locales: [],
    )

  ac.chat_input_tree_commands(def, [
    chat_input_command_tree_node([chat_input_command_tree_leaf()]),
  ])
}

pub fn chat_input_command_tree_node(
  _sub_commands: List(ac.CommandTreeNode(bot)),
) -> ac.CommandTreeNode(bot) {
  todo
}

pub fn chat_input_command_tree_leaf() -> ac.CommandTreeNode(bot) {
  todo
}

pub fn user_command() -> ac.ApplicationCommand(_) {
  let command =
    ac.CommandDefinition(
      ..ac.new_definition(
        name: "greet",
        desc: "greets user",
        integs: [],
        contexts: [],
      ),
      name_locales: [],
    )

  use _i, _bot <- ac.user_command(command)

  // Replace with your command logic
  Error(response.NotImplemented)
}

pub fn message_command() -> ac.ApplicationCommand(_) {
  let def =
    ac.CommandDefinition(
      ..ac.new_definition(
        name: "repeat",
        desc: "repeats message",
        integs: [],
        contexts: [],
      ),
      name_locales: [],
    )

  use _i, _bot <- ac.message_command(def)

  // Replace with your command logic
  Error(response.NotImplemented)
}
