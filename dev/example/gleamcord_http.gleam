import gleamcord_http

pub const hello_command = gleamcord_http.ChatCommand(
  definition: gleamcord_http.CommandDefinition(
    name: "greet",
    description: "greets a name",
  ),
  options: [name_option],
  handler: hello_handler,
)

const name_option = gleamcord_http.StringOption(name: "name")

fn hello_handler(_i) {
  let name = todo as "extract name option"

  todo as { "Hello, " <> name <> "!" }
}

pub const utils_tree = gleamcord_http.ChatCommandGroup(
  definition: gleamcord_http.CommandDefinition(
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
  handler: ping_handler,
)

fn ping_handler(_i) {
  todo as "Pong"
}

const slow_sub_command = gleamcord_http.SubCommand(
  name: "slow",
  description: "slow command",
  options: [],
  handler: slow_handler,
)

fn slow_handler(_i) {
  // process.sleep(5000)
  todo as "Waited 5000 ms"
}
