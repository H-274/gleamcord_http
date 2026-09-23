import gleam/dict.{type Dict}
import gleamcord_http
import gleamcord_http/discord

pub const hello_command = gleamcord_http.ChatCommand(
  definition: gleamcord_http.CommandDefinition(
    ..gleamcord_http.guild_command_definition,
    name: "greet",
    description: "greets a name",
  ),
  options: [name_option],
  handle: hello_handle,
)

const name_option = gleamcord_http.StringOption(
  name: "name",
  description: "name to greet",
  required: True,
  min_length: 1,
  max_length: 128,
)

fn hello_handle(
  _i: discord.CommandInteraction,
  o: Dict(String, discord.ValueOption),
) -> gleamcord_http.CommandResponse {
  let assert Ok(name) = discord.string_value(o, name_option.name)

  { "Hello, " <> name <> "!" }
  |> gleamcord_http.CommandMessageResponse
}

pub const utils_tree = gleamcord_http.ChatCommandGroup(
  definition: gleamcord_http.CommandDefinition(
    ..gleamcord_http.guild_command_definition,
    name: "utils",
    description: "utilitary commands",
  ),
  elements: [
    gleamcord_http.SubCommandElement(
      // utils ping
      ping_sub_command,
    ),

    gleamcord_http.SubCommandGroup(
      name: "test",
      description: "test commands",
      sub_commands: [
        // utils test slow
        slow_sub_command,
      ],
    ),
  ],
)

const ping_sub_command = gleamcord_http.SubCommand(
  name: "ping",
  description: "pongs",
  options: [],
  handle: ping_handle,
)

fn ping_handle(
  _i: discord.CommandInteraction,
  _o: Dict(String, discord.ValueOption),
) {
  "Pong"
  |> gleamcord_http.CommandMessageResponse
}

const slow_sub_command = gleamcord_http.SubCommand(
  name: "slow",
  description: "slow command",
  options: [],
  handle: slow_handle,
)

fn slow_handle(
  _i: discord.CommandInteraction,
  _o: Dict(String, discord.ValueOption),
) {
  use <- gleamcord_http.CommandDeferredMessageResponse

  // process.sleep(5000)
  "Waited 5000 ms"
}
