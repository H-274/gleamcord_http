//// TODO review type names and type variant names

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
  def: CommandDefinition(bot),
  params: List(ParamDefinition),
  handler: ParamsHandler(bot),
) {
  ChatInputCommand(def, params, handler)
}

pub fn chat_input_tree_commands(
  def: CommandDefinition(bot),
  sub_commands: List(CommandTreeNode(bot)),
) {
  ChatInputCommandTree(def, sub_commands)
}

pub opaque type CommandTreeNode(bot) {
  TreeNode(NodeDefinition, List(CommandTreeNode(bot)))
  TreeLeaf(NodeDefinition, List(ParamDefinition), ParamsHandler(bot))
}

/// TODO
pub type NodeDefinition {
  NodeDefinition
}

pub fn tree_node(def: NodeDefinition, sub_commands: List(CommandTreeNode(_))) {
  TreeNode(def, sub_commands)
}

pub fn tree_leaf(
  def: NodeDefinition,
  params: List(ParamDefinition),
  handler: ParamsHandler(_),
) {
  TreeLeaf(def, params, handler)
}

pub type ParamDefinition

pub type Param

pub fn user_command(def: CommandDefinition(bot), handler: Handler(bot)) {
  UserCommand(def, handler)
}

pub fn message_command(def: CommandDefinition(bot), handler: Handler(bot)) {
  MessageCommand(def, handler)
}

pub type Handler(bot) =
  fn(ApplicationCommandInteraction, bot) -> Result(Success, response.Failure)

pub type ParamsHandler(bot) =
  fn(ApplicationCommandInteraction, List(Param), bot) ->
    Result(Success, response.Failure)

/// TODO
pub opaque type Success {
  MessageReply
  DeferredMessage
}
