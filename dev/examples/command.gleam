import gleamcord_http.{
  ChatCommand, ChatCommandGroup, ChatInputSubCommand, ChatSubCommandGroup,
  CommandDeferredMessageResponse, CommandMessageResponse, MessageCommand,
  UserCommand, group_sub_command, simple_definition,
}
import gleamcord_http/command_option

pub fn chat_command_example() {
  let def = simple_definition(name: "hello", desc: "world")

  use _interaction, _options <- ChatCommand(def:, options: [])
  CommandMessageResponse(todo as "Missing message type")
}

pub fn slow_chat_command_example() {
  let def = simple_definition(name: "hello", desc: "world")

  use _interaction, _options <- ChatCommand(def:, options: [])
  use <- CommandDeferredMessageResponse

  // process.sleep(10_000)

  todo as "Missing message type"
}

pub fn chat_command_group_example() {
  let def = simple_definition(name: "settings", desc: "settings")
  ChatCommandGroup(def:, elements: [
    ChatSubCommandGroup(
      name: "user",
      description: "user settings",
      sub_commands: [example_sub_command],
    ),
    example_group_sub_command(),
  ])
}

/// Unsure why this doesn't error, I'm passing a function to a constant 
pub const example_sub_command = ChatInputSubCommand(
  name: "nickname",
  description: "set nickname",
  options: [
    command_option.String(
      name: "value",
      description: "new nickname",
      min_len: 1,
      max_len: 50,
      required: True,
    ),
  ],
  run: example_sub_command_run,
)

fn example_sub_command_run(_interaction, options) {
  let assert Ok(value) = command_option.get_string_value(options, "value")

  let _ = echo value

  CommandMessageResponse(todo as "Missing message type")
}

pub fn example_group_sub_command() {
  use _interaction, _options <- group_sub_command(
    name: "secret",
    desc: "secret setting",
    opts: [],
  )
  CommandMessageResponse(todo as "Missing message type")
}

pub fn user_command() {
  let def = simple_definition(name: "greet", desc: "greets user")

  use _interaction <- UserCommand(def:)
  CommandMessageResponse(todo as "Missing message type")
}

pub fn message_command() {
  let def = simple_definition(name: "report", desc: "report message")

  use _interaction <- MessageCommand(def:)
  CommandMessageResponse(todo as "Missing message type")
}
