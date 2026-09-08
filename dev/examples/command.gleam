import gleamcord_http.{
  ChatCommand, ChatCommandGroup, ChatGroupSubCommand, ChatSubCommand,
  ChatSubCommandGroup, CommandDeferredMessageResponse, CommandMessageResponse,
  MessageCommand, UserCommand, basic_command_definition,
  command_group_element_dict, sub_command_dict,
}
import gleamcord_http/command_option

pub fn chat_command() {
  use _i, _o <- ChatCommand(
    def: basic_command_definition(name: "hello", desc: "world"),
    options: [],
  )

  CommandMessageResponse(todo as "Missing message type")
}

const user_opt = command_option.User(
  name: "user",
  description: "",
  required: True,
)

pub fn slow_command() {
  use i, o <- ChatCommand(
    def: basic_command_definition(name: "slow", desc: "hello"),
    options: [user_opt],
  )

  use <- CommandDeferredMessageResponse
  let resolved = i.data |> fn(_) { todo as "get resolved" }
  let assert Ok(#(Ok(user), Ok(member))) =
    command_option.get_user_value(o, resolved, "user")

  // process.sleep(10_000)

  echo #(user, member)
  todo as "Missing message type"
}

pub fn chat_command_group_example() {
  ChatCommandGroup(
    def: basic_command_definition(name: "settings", desc: "settings"),
    elements: command_group_element_dict([
      ChatSubCommandGroup(
        name: "user",
        description: "user settings",
        sub_commands: sub_command_dict([example_sub_command()]),
      ),
      ChatGroupSubCommand(example_group_sub_command()),
    ]),
  )
}

const nickname_option = command_option.String(
  name: "value",
  description: "new nickname",
  min_len: 1,
  max_len: 50,
  required: True,
)

fn example_sub_command() {
  use _i, o <- ChatSubCommand(
    name: "nickname",
    description: "set nickname",
    options: [nickname_option],
  )

  let assert Ok(value) = command_option.get_string_value(o, "value")

  echo value

  CommandMessageResponse(todo as "Missing message type")
}

fn example_group_sub_command() {
  use _i, _o <- ChatSubCommand(
    name: "secret",
    description: "secret setting",
    options: [],
  )

  CommandMessageResponse(todo as "Missing message type")
}

pub fn user_command() {
  use _i <- UserCommand(basic_command_definition(
    name: "greet",
    desc: "greets user",
  ))

  CommandMessageResponse(todo as "Missing message type")
}

pub fn message_command() {
  use _i <- MessageCommand(def: basic_command_definition(
    name: "report",
    desc: "reports message",
  ))

  CommandMessageResponse(todo as "Missing message type")
}
