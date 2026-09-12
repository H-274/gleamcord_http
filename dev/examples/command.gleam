import gleam/option
import gleamcord_http.{
  basic_command_definition as command_def, command_group_elements, sub_commands,
}
import gleamcord_http/discord

pub fn chat_command() {
  use _i, _o <- gleamcord_http.ChatCommand(
    def: command_def(name: "hello", desc: "world"),
    options: [],
  )

  todo as "Missing message type"
  |> gleamcord_http.CommandMessageResponse
}

const user_opt = gleamcord_http.UserOption(
  name: "user",
  description: "",
  required: True,
)

pub fn slow_command() {
  use i, o <- gleamcord_http.ChatCommand(
    def: command_def(name: "slow", desc: "hello"),
    options: [user_opt],
  )

  let assert discord.CommandInteraction(data:, ..) = i
  let assert option.Some(resolved) = data.resolved

  let assert Ok(#(option.Some(user), _)) =
    discord.options_user(o, user_opt.name, resolved)

  use <- gleamcord_http.CommandDeferredMessageResponse

  // process.sleep(10_000)

  echo user
  todo as "Missing message type"
}

pub fn chat_command_group_example() {
  gleamcord_http.ChatCommandGroup(
    def: command_def(name: "settings", desc: "settings"),
    elements: command_group_elements([
      gleamcord_http.ChatSubCommandGroup(
        name: "user",
        description: "user settings",
        sub_commands: sub_commands([
          sub_command_group_command(),
        ]),
      ),
      group_element_command()
        |> gleamcord_http.ChatGroupSubCommand,
    ]),
  )
}

const nickname_option = gleamcord_http.StringOption(
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

  let assert Ok(value) = discord.options_string(o, nickname_option.name)

  echo value

  todo as "Missing message type"
  |> gleamcord_http.CommandMessageResponse
}

fn group_element_command() {
  use _i, _o <- gleamcord_http.ChatSubCommand(
    name: "secret",
    description: "secret setting",
    options: [],
  )

  todo as "Missing message type"
  |> gleamcord_http.CommandMessageResponse
}

pub fn user_command() {
  use _i <- gleamcord_http.UserCommand(command_def(
    name: "greet",
    desc: "greets user",
  ))

  todo as "Missing message type"
  |> gleamcord_http.CommandMessageResponse
}

pub fn message_command() {
  use _i <- gleamcord_http.MessageCommand(def: command_def(
    name: "report",
    desc: "reports message",
  ))

  todo as "Missing message type"
  |> gleamcord_http.CommandMessageResponse
}
