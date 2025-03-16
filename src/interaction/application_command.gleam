//// TODO review type names and type variant names

import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import interaction.{type ApplicationCommandInteraction}
import interaction/response

pub opaque type ApplicationCommand(bot) {
  ChatInputCommand(
    CommandDefinition(bot),
    List(ParamDefinition),
    ParamsHandler(bot),
  )
  ChatInputCommandTree(CommandDefinition(bot), List(CommandTreeNode(bot)))
  UserCommand(CommandDefinition(bot), Handler(bot))
  MessageCommand(CommandDefinition(bot), Handler(bot))
}

pub fn is_valid(command: ApplicationCommand(_)) -> Bool {
  case command {
    ChatInputCommand(def, ..) | ChatInputCommandTree(def, ..) ->
      is_valid_definition(def:) |> bool.and(!string.is_empty(def.description))

    UserCommand(def, ..) | MessageCommand(def, ..) -> is_valid_definition(def:)
  }
}

fn is_valid_definition(def definition: CommandDefinition(_)) {
  { !string.is_empty(definition.name) }
  |> bool.and(list.length(definition.contexts) > 0)
  |> bool.and(list.length(definition.integration_types) > 0)
}

pub type CommandDefinition(bot) {
  CommandDefinition(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    default_member_permissions: String,
    // TODO
    integration_types: List(Nil),
    // TODO
    contexts: List(Nil),
    nsfw: Bool,
  )
}

pub fn new_definition(
  name name: String,
  desc description: String,
  integs integration_types: List(Nil),
  contexts contexts: List(Nil),
) {
  CommandDefinition(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    default_member_permissions: "",
    integration_types:,
    contexts:,
    nsfw: False,
  )
}

pub fn chat_input_command(
  def def: CommandDefinition(bot),
  params params: List(ParamDefinition),
  handler handler: ParamsHandler(bot),
) {
  ChatInputCommand(def, params, handler)
}

pub fn chat_input_tree_commands(
  def def: CommandDefinition(bot),
  commands sub_commands: List(CommandTreeNode(bot)),
) {
  ChatInputCommandTree(def, sub_commands)
}

pub opaque type CommandTreeNode(bot) {
  TreeNode(NodeDefinition, List(CommandTreeNode(bot)))
  TreeLeaf(NodeDefinition, List(ParamDefinition), ParamsHandler(bot))
}

pub type NodeDefinition {
  NodeDefinition(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
  )
}

pub fn new_node_definition(name name: String, desc description: String) {
  NodeDefinition(name:, name_locales: [], description:, description_locales: [])
}

pub fn tree_node(
  def def: NodeDefinition,
  commands sub_commands: List(CommandTreeNode(_)),
) {
  TreeNode(def, sub_commands)
}

pub fn tree_leaf(
  def def: NodeDefinition,
  params params: List(ParamDefinition),
  handler handler: ParamsHandler(_),
) {
  TreeLeaf(def, params, handler)
}

// TODO

pub type ParamBase {
  ParamBase
}

pub opaque type ParamDefinition {
  StringDef(ParamBase)
  IntegerDef(ParamBase)
}

pub fn new_string_definition(base: ParamBase) -> ParamDefinition {
  StringDef(base)
}

pub fn new_integer_definition(base: ParamBase) -> ParamDefinition {
  IntegerDef(base)
}

// TODO
pub type Param {
  StringParam(name: String, value: String, focused: Bool)
  IntegerParam(name: String, value: Int, focused: Bool)
  FloatParam(name: String, value: Float, focused: Bool)
}

pub fn user_command(def: CommandDefinition(bot), handler: Handler(bot)) {
  UserCommand(def, handler)
}

pub fn message_command(
  def def: CommandDefinition(bot),
  handler handler: Handler(bot),
) {
  MessageCommand(def, handler)
}

pub type Handler(bot) =
  fn(ApplicationCommandInteraction, bot) ->
    Result(response.Success, response.Failure)

pub type ParamsHandler(bot) =
  fn(ApplicationCommandInteraction, Dict(String, Param), bot) ->
    Result(response.Success, response.Failure)
