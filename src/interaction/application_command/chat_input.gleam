import gleam/option.{type Option}
import interaction/application_command/command_option.{type CommandOption}
import interaction/application_command/command_param.{type CommandParam}
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

pub type Command(bot, success, failure) {
  Command(handler: Handler(bot, success, failure))
  CommandTree
}

pub type CommandTree(bot, success, failure) {
  Node(Node(bot, success, failure))
  Leaf(Leaf(bot, success, failure))
}

pub type Node(bot, success, failure) {
  CommandNode(sub_commands: List(CommandTree(bot, success, failure)))
}

pub type Leaf(bot, success, failure) {
  CommandLeaf(handler: Handler(bot, success, failure))
}

pub fn extract_command_handler(
  command: Command(bot, success, failure),
  options: List(CommandOption),
) -> Result(HandlerWithParams(bot, success, failure), Nil) {
  case command {
    Command(handler: handler) -> {
      let handler_with_params = fn(i, bot) { handler(i, todo, bot) }
      Ok(handler_with_params)
    }
    CommandTree -> todo
  }
}

pub type Handler(bot, success, failure) =
  fn(Interaction, List(CommandParam), bot) -> Result(success, failure)

pub type HandlerWithParams(bot, success, failure) =
  fn(Interaction, bot) -> Result(success, failure)
