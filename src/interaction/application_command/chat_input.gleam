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

pub type Command(bot) {
  Command(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    params: List(CommandParam),
    default_member_permissions: Option(String),
    nsfw: Bool,
    integration_types: List(base.ApplicationIntegration),
    contexts: List(base.Context),
    version: String,
    handler: HandlerWithParams(bot),
  )
  CommandTree(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    sub_commands: List(CommandTree(bot)),
    default_member_permissions: Option(String),
    nsfw: Bool,
    integration_types: List(base.ApplicationIntegration),
    contexts: List(base.Context),
    version: String,
  )
}

pub type CommandTree(bot) {
  Node(Node(bot))
  Leaf(Leaf(bot))
}

pub type Node(bot) {
  CommandNode(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    options: List(CommandTree(bot)),
  )
}

pub type Leaf(bot) {
  CommandLeaf(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    options: List(CommandParam),
    handler: HandlerWithParams(bot),
  )
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
