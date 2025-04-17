import discord/context.{type Context}
import discord/integration_type.{type IntegrationType}
import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import interaction/application_command_param.{type Param, type ParamDefinition}

pub opaque type ApplicationCommand(
  command,
  autocomplete,
  bot,
  p_success,
  p_failure,
  success,
  failure,
) {
  ChatInputCommand(
    CommandDefinition(bot),
    List(ParamDefinition(autocomplete, bot, p_success, p_failure)),
    ParamsCommandHandler(command, bot, success, failure),
  )
  ChatInputCommandTree(
    CommandDefinition(bot),
    List(
      CommandTreeNode(
        command,
        autocomplete,
        bot,
        p_success,
        p_failure,
        success,
        failure,
      ),
    ),
  )
  UserCommand(
    CommandDefinition(bot),
    CommandHandler(command, bot, success, failure),
  )
  MessageCommand(
    CommandDefinition(bot),
    CommandHandler(command, bot, success, failure),
  )
}

pub fn is_valid(command: ApplicationCommand(_, _, _, _, _, _, _)) -> Bool {
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
    integration_types: List(IntegrationType),
    contexts: List(Context),
    nsfw: Bool,
  )
}

pub fn new_definition(
  name name: String,
  desc description: String,
  integs integration_types: List(IntegrationType),
  contexts contexts: List(Context),
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
  params params: List(ParamDefinition(_, bot, _, _)),
  handler handler: ParamsCommandHandler(_, bot, _, _),
) {
  ChatInputCommand(def, params, handler)
}

pub fn chat_input_tree_commands(
  def def: CommandDefinition(bot),
  commands sub_commands: List(CommandTreeNode(_, _, bot, _, _, _, _)),
) {
  ChatInputCommandTree(def, sub_commands)
}

pub opaque type CommandTreeNode(
  command,
  autocomplete,
  bot,
  p_success,
  p_failure,
  success,
  failure,
) {
  TreeNode(
    NodeDefinition,
    List(
      CommandTreeNode(
        command,
        autocomplete,
        bot,
        p_success,
        p_failure,
        success,
        failure,
      ),
    ),
  )
  TreeLeaf(
    NodeDefinition,
    List(ParamDefinition(autocomplete, bot, p_success, p_failure)),
    ParamsCommandHandler(command, bot, success, failure),
  )
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
  commands sub_commands: List(CommandTreeNode(_, _, _, _, _, _, _)),
) {
  TreeNode(def, sub_commands)
}

pub fn tree_leaf(
  def def: NodeDefinition,
  params params: List(ParamDefinition(_, bot, _, _)),
  handler handler: ParamsCommandHandler(_, bot, _, _),
) {
  TreeLeaf(def, params, handler)
}

pub fn user_command(
  def def: CommandDefinition(bot),
  handler handler: CommandHandler(_, bot, _, _),
) {
  UserCommand(def, handler)
}

pub fn message_command(
  def def: CommandDefinition(bot),
  handler handler: CommandHandler(_, bot, _, _),
) {
  MessageCommand(def, handler)
}

pub type CommandHandler(interaction, bot, success, failure) =
  fn(interaction, bot) -> Result(success, failure)

pub type ParamsCommandHandler(interaction, bot, success, failure) =
  fn(interaction, Dict(String, Param), bot) -> Result(success, failure)
