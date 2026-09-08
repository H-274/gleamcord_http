import gleam/option
import gleamcord_http.{
  basic_command_definition as command_def, command_group_element_dict,
  sub_command_dict,
}
import gleamcord_http/command_option
import gleamcord_http/discord

pub fn chat_command() {
  use _i, _o <- gleamcord_http.ChatCommand(
    def: gleamcord_http.basic_command_definition(name: "hello", desc: "world"),
    options: [],
  )

  gleamcord_http.CommandMessageResponse(todo as "Missing message type")
}

const user_opt = command_option.User(
  name: "user",
  description: "",
  required: True,
)

pub fn slow_command() {
  use i, o <- gleamcord_http.ChatCommand(
    def: command_def(name: "slow", desc: "hello"),
    options: [user_opt],
  )
  let assert discord.CommandInteraction(
    data: discord.ChatCommandData(resolved: option.Some(resolved), ..),
    ..,
  ) = i

  use <- gleamcord_http.CommandDeferredMessageResponse
  let assert Ok(#(Ok(user), Ok(member))) =
    command_option.get_user_value(o, resolved, "user")

  // process.sleep(10_000)

  echo #(user, member)
  todo as "Missing message type"
}

pub fn chat_command_group_example() {
  gleamcord_http.ChatCommandGroup(
    def: command_def(name: "settings", desc: "settings"),
    elements: command_group_element_dict([
      gleamcord_http.ChatSubCommandGroup(
        name: "user",
        description: "user settings",
        sub_commands: sub_command_dict([
          sub_command_group_command(),
        ]),
      ),
      group_element_command()
        |> gleamcord_http.ChatGroupSubCommand,
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

fn sub_command_group_command() {
  use _i, o <- gleamcord_http.ChatSubCommand(
    name: "nickname",
    description: "set nickname",
    options: [nickname_option],
  )

  let assert Ok(value) = command_option.get_string_value(o, "value")

  echo value

  gleamcord_http.CommandMessageResponse(todo as "Missing message type")
}

fn group_element_command() {
  use _i, _o <- gleamcord_http.ChatSubCommand(
    name: "secret",
    description: "secret setting",
    options: [],
  )

  gleamcord_http.CommandMessageResponse(todo as "Missing message type")
}

pub fn user_command() {
  use _i <- gleamcord_http.UserCommand(command_def(
    name: "greet",
    desc: "greets user",
  ))

  gleamcord_http.CommandMessageResponse(todo as "Missing message type")
}

pub fn message_command() {
  use _i <- gleamcord_http.MessageCommand(def: command_def(
    name: "report",
    desc: "reports message",
  ))

  gleamcord_http.CommandMessageResponse(todo as "Missing message type")
}
