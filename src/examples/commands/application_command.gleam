import gleam/dict
import gleam/int
import gleam/io
import gleam/result
import interaction/application_command as ac
import interaction/response

pub fn chat_input_command() -> ac.ApplicationCommand(_) {
  let def =
    ac.CommandDefinition(
      ..ac.new_definition(name: "ping", desc: "pongs", integs: [], contexts: []),
      name_locales: [],
    )
  let params = [ac.StringDef(ac.ParamBase), ac.IntegerDef(ac.ParamBase)]

  use _i, _params, _bot <- ac.chat_input_command(def:, params:)

  // Replace with your command logic
  Error(response.NotImplemented)
}

pub fn chat_input_command_tree() -> ac.ApplicationCommand(_) {
  let def =
    ac.CommandDefinition(
      ..ac.new_definition(
        name: "various",
        desc: "collection of various commands",
        integs: [],
        contexts: [],
      ),
      name_locales: [],
    )
  let commands = [
    chat_input_command_tree_node([chat_input_command_tree_leaf()]),
  ]

  ac.chat_input_tree_commands(def:, commands:)
}

pub fn chat_input_command_tree_node(
  commands: List(ac.CommandTreeNode(bot)),
) -> ac.CommandTreeNode(bot) {
  let def = ac.new_node_definition(name: "node", desc: "")

  ac.tree_node(def:, commands:)
}

pub fn chat_input_command_tree_leaf() -> ac.CommandTreeNode(_) {
  let def =
    ac.NodeDefinition(
      ..ac.new_node_definition(name: "hello", desc: "says hello"),
      name_locales: [],
    )
  let params = [todo, todo]

  use _i, params, _bot <- ac.tree_leaf(def:, params:)

  use name <- result.try(case dict.get(params, "name") {
    Ok(ac.StringParam(value: value, ..)) -> Ok(value)
    _ -> Error(response.InternalServerError)
  })
  use age <- result.try(case dict.get(params, "age") {
    Ok(ac.IntegerParam(value: value, ..)) -> Ok(value)
    _ -> Error(response.InternalServerError)
  })

  { "Hello " <> name <> ", you are " <> int.to_string(age) <> " years old" }
  |> io.println()

  todo as "Message response types not yet complete"
}

pub fn user_command() -> ac.ApplicationCommand(_) {
  let def =
    ac.CommandDefinition(
      ..ac.new_definition(
        name: "greet",
        desc: "greets user",
        integs: [],
        contexts: [],
      ),
      name_locales: [],
    )

  use _i, _bot <- ac.user_command(def:)

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

  use _i, _bot <- ac.message_command(def:)

  // Replace with your command logic
  Error(response.NotImplemented)
}
