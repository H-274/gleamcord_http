import gleamcord_http.{
  ChatCommand, ChatCommandGroup, ChatGroupSubCommand, ChatSubCommand,
  ChatSubCommandGroup, CommandDeferredMessageResponse, CommandMessageResponse,
  GuildCommandDefinition, MessageCommand, UserCommand,
  command_group_element_dict, sub_command_dict,
}
import gleamcord_http/command_option
import gleamcord_http/discord

pub const chat_command = ChatCommand(
  def: GuildCommandDefinition(
    name: "hello",
    description: "world",
    default_member_permissions: "",
    nsfw: False,
  ),
  run: chat_command_handler,
  options: [],
)

pub fn chat_command_handler(_interaction, _options) {
  CommandMessageResponse(todo as "Missing message type")
}

const user_opt = command_option.User(
  name: "user",
  description: "",
  required: True,
)

pub const slow_command = ChatCommand(
  def: GuildCommandDefinition(
    name: "hello",
    description: "world",
    default_member_permissions: "",
    nsfw: False,
  ),
  options: [user_opt],
  run: slow_command_handler,
)

fn slow_command_handler(interaction: discord.CommandInteraction, options) {
  use <- CommandDeferredMessageResponse
  let resolved = interaction.data |> fn(_) { todo as "get resolved" }
  let assert Ok(#(Ok(user), Ok(member))) =
    command_option.get_user_value(options, resolved, "user")

  // process.sleep(10_000)

  echo #(user, member)

  todo as "Missing message type"
}

pub fn chat_command_group_example() {
  GuildCommandDefinition(
    name: "settings",
    description: "settings",
    default_member_permissions: "",
    nsfw: False,
  )
  |> ChatCommandGroup(
    elements: [
      ChatSubCommandGroup(
        name: "user",
        description: "user settings",
        sub_commands: [example_sub_command] |> sub_command_dict,
      ),
      ChatGroupSubCommand(example_group_sub_command),
    ]
    |> command_group_element_dict,
  )
}

const nickname_option = command_option.String(
  name: "value",
  description: "new nickname",
  min_len: 1,
  max_len: 50,
  required: True,
)

/// Unsure why this doesn't error at compile, I'm passing a function to a constant 
pub const example_sub_command = ChatSubCommand(
  name: "nickname",
  description: "set nickname",
  options: [nickname_option],
  run: example_sub_command_run,
)

fn example_sub_command_run(_interaction, options) {
  let assert Ok(value) = command_option.get_string_value(options, "value")

  echo value

  CommandMessageResponse(todo as "Missing message type")
}

pub const example_group_sub_command = ChatSubCommand(
  name: "secret",
  description: "secret setting",
  options: [],
  run: example_group_sub_command_handler,
)

fn example_group_sub_command_handler(_interaction, _options) {
  CommandMessageResponse(todo as "Missing message type")
}

pub const user_command = UserCommand(
  def: GuildCommandDefinition(
    name: "greet",
    description: "greets user",
    default_member_permissions: "",
    nsfw: False,
  ),
  run: user_command_handler,
)

fn user_command_handler(_interaction) {
  CommandMessageResponse(todo as "Missing message type")
}

pub const message_command = MessageCommand(
  def: GuildCommandDefinition(
    name: "report",
    description: "report message",
    default_member_permissions: "",
    nsfw: False,
  ),
  run: message_command_handler,
)

pub fn message_command_handler(_interaction) {
  CommandMessageResponse(todo as "Missing message type")
}
