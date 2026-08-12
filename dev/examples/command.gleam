import gleamcord_http.{
  ChatCommand, ChatCommandGroup, ChatSubCommand, ChatSubCommandGroup,
  CommandDeferredMessageResponse, CommandMessageResponse, MessageCommand,
  UserCommand, command_group_element_dict, group_sub_command, simple_definition,
  sub_command_dict,
}
import gleamcord_http/command_option

pub fn chat_command_example() {
  let set_command_run = fn(run) {
    simple_definition(name: "hello", desc: "world")
    |> ChatCommand(run:, options: [])
  }
  use _interaction, _options <- set_command_run

  CommandMessageResponse(todo as "Missing message type")
}

const user_opt = command_option.User(
  name: "user",
  description: "",
  required: True,
)

pub fn slow_chat_command_example() {
  let set_command_run = fn(run) {
    simple_definition(name: "hello", desc: "world")
    |> ChatCommand(run:, options: [user_opt])
  }
  use interaction, options <- set_command_run

  use <- CommandDeferredMessageResponse
  let resolved = interaction.data |> fn(_) { todo as "get resolved" }
  let assert Ok(#(Ok(user), Ok(member))) =
    command_option.get_user_value(options, resolved, "user")

  // process.sleep(10_000)

  echo #(user, member)

  todo as "Missing message type"
}

pub fn chat_command_group_example() {
  let def = simple_definition(name: "settings", desc: "settings")
  ChatCommandGroup(
    def:,
    elements: command_group_element_dict([
      ChatSubCommandGroup(
        name: "user",
        description: "user settings",
        sub_commands: sub_command_dict([example_sub_command]),
      ),
      example_group_sub_command(),
    ]),
  )
}

/// Unsure why this doesn't error at compile, I'm passing a function to a constant 
pub const example_sub_command = ChatSubCommand(
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
  let set_sub_command_run = fn(run) {
    group_sub_command(name: "secret", desc: "secret setting", run:, opts: [])
  }
  use _interaction, _options <- set_sub_command_run

  CommandMessageResponse(todo as "Missing message type")
}

pub fn user_command() {
  let set_command_run = fn(run) {
    simple_definition(name: "greet", desc: "greets user")
    |> UserCommand(run:)
  }
  use _interaction <- set_command_run

  CommandMessageResponse(todo as "Missing message type")
}

pub fn message_command() {
  let def = simple_definition(name: "report", desc: "report message")
  use _interaction <- MessageCommand(def:)

  CommandMessageResponse(todo as "Missing message type")
}
