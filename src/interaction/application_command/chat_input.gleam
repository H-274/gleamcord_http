import gleam/list
import gleam/option.{type Option}
import gleam/result
import interaction/application_command/command_option.{type CommandOption}
import interaction/application_command/command_param.{type CommandParam}
import interaction/base
import interaction/response
import resolved.{type Resolved}

pub type Interaction {
  Interaction(
    name: String,
    resolved: Resolved,
    options: List(CommandOption),
    guild_id: Option(String),
    target_id: Option(String),
  )
}

pub opaque type CommandBuilder {
  CommandBuilder(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    default_member_permissions: String,
    nsfw: Bool,
    integration_types: List(base.ApplicationIntegration),
    contexts: List(base.Context),
  )
}

pub opaque type Command(bot) {
  Command(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    default_member_permissions: String,
    nsfw: Bool,
    integration_types: List(base.ApplicationIntegration),
    contexts: List(base.Context),
    params: List(CommandParam),
    handler: HandlerWithParams(bot),
  )
  CommandTree(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    default_member_permissions: String,
    nsfw: Bool,
    integration_types: List(base.ApplicationIntegration),
    contexts: List(base.Context),
    sub_commands: List(CommandTree(bot)),
  )
}

pub fn new_command_builder(
  name name: String,
  desc description: String,
  integ_types integration_types: List(base.ApplicationIntegration),
  contexts contexts: List(base.Context),
) -> CommandBuilder {
  CommandBuilder(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    default_member_permissions: "",
    nsfw: False,
    integration_types:,
    contexts:,
  )
}

pub fn command_name_locales(
  builder: CommandBuilder,
  name_locales: List(#(String, String)),
) {
  CommandBuilder(..builder, name_locales:)
}

pub fn command_desc_locales(
  builder: CommandBuilder,
  description_locales: List(#(String, String)),
) {
  CommandBuilder(..builder, description_locales:)
}

pub fn command_default_member_perms(
  builder: CommandBuilder,
  default_member_permissions: String,
) {
  CommandBuilder(..builder, default_member_permissions:)
}

pub fn command_nsfw(builder: CommandBuilder, nsfw: Bool) {
  CommandBuilder(..builder, nsfw:)
}

pub fn with_command_handler(
  builder: CommandBuilder,
  params: List(CommandParam),
  handler: HandlerWithParams(bot),
) -> Command(bot) {
  Command(
    name: builder.name,
    name_locales: builder.name_locales,
    description: builder.description,
    description_locales: builder.description_locales,
    default_member_permissions: builder.default_member_permissions,
    nsfw: builder.nsfw,
    integration_types: builder.integration_types,
    contexts: builder.contexts,
    params:,
    handler:,
  )
}

pub fn command_tree(
  builder: CommandBuilder,
  sub_commands: List(CommandTree(bot)),
) -> Command(bot) {
  CommandTree(
    name: builder.name,
    name_locales: builder.name_locales,
    description: builder.description,
    description_locales: builder.description_locales,
    default_member_permissions: builder.default_member_permissions,
    nsfw: builder.nsfw,
    integration_types: builder.integration_types,
    contexts: builder.contexts,
    sub_commands:,
  )
}

pub type CommandTree(bot) {
  Node(Node(bot))
  Leaf(Leaf(bot))
}

pub opaque type Node(bot) {
  CommandNode(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    options: List(CommandTree(bot)),
  )
}

pub fn new_command_node(name: String, description: String) -> Node(_) {
  CommandNode(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    options: [],
  )
}

pub fn node_name_locales(
  node: Node(bot),
  name_locales: List(#(String, String)),
) -> Node(bot) {
  CommandNode(..node, name_locales:)
}

pub fn node_desc_locales(
  node: Node(bot),
  description_locales: List(#(String, String)),
) -> Node(bot) {
  CommandNode(..node, description_locales:)
}

pub fn node_options(
  node: Node(bot),
  options: List(CommandTree(bot)),
) -> CommandTree(bot) {
  Node(CommandNode(..node, options:))
}

pub opaque type Leaf(bot) {
  CommandLeaf(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    params: List(CommandParam),
    handler: HandlerWithParams(bot),
  )
}

pub fn new_command_leaf(name: String, description: String) -> Leaf(_) {
  CommandLeaf(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    params: [],
    handler: fn(_, _, _) { Error(response.NotImplemented) },
  )
}

pub fn leaf_name_locales(
  node: Leaf(bot),
  name_locales: List(#(String, String)),
) -> Leaf(bot) {
  CommandLeaf(..node, name_locales:)
}

pub fn leaf_desc_locales(
  node: Leaf(bot),
  description_locales: List(#(String, String)),
) -> Leaf(bot) {
  CommandLeaf(..node, description_locales:)
}

pub fn with_leaf_handler(
  node: Leaf(bot),
  params: List(CommandParam),
  handler: HandlerWithParams(bot),
) -> CommandTree(bot) {
  Leaf(CommandLeaf(..node, params:, handler:))
}

pub fn extract_command_handler(
  command: Command(bot),
  options: List(CommandOption),
) -> Result(Handler(bot), Nil) {
  case command {
    CommandTree(sub_commands: sub_commands, ..) ->
      extract_sub_command_handler(sub_commands, options)

    Command(handler: handler, ..) -> {
      use params <- result.try(list.try_map(options, command_option.to_param))
      let handler = fn(interaction, bot) { handler(interaction, params, bot) }
      Ok(handler)
    }
  }
}

fn extract_sub_command_handler(
  sub_commands: List(CommandTree(bot)),
  options: List(CommandOption),
) -> Result(Handler(bot), Nil) {
  case sub_commands, options {
    [Node(CommandNode(name: node_name, ..)), ..rest],
      [command_option.SubCommandGroup(name: group_name, ..)]
      if node_name != group_name
    -> extract_sub_command_handler(rest, options)
    [Node(CommandNode(options: sub_commands, ..)), ..],
      [command_option.SubCommandGroup(options: options, ..)]
    -> extract_sub_command_handler(sub_commands, options)

    [Leaf(CommandLeaf(name: leaf_name, ..)), ..rest],
      [command_option.SubCommand(name: sub_name, ..)]
      if leaf_name != sub_name
    -> extract_sub_command_handler(rest, options)
    [Leaf(CommandLeaf(handler: handler, ..)), ..],
      [command_option.SubCommand(options: options, ..)]
    -> {
      use params <- result.try(list.try_map(options, command_option.to_param))
      let handler = fn(interaction, bot) { handler(interaction, params, bot) }
      Ok(handler)
    }

    _, _ -> Error(Nil)
  }
}

pub type HandlerWithParams(bot) =
  fn(Interaction, List(CommandParam), bot) ->
    Result(response.Success, response.Failure)

pub type Handler(bot) =
  fn(Interaction, bot) -> Result(response.Success, response.Failure)
