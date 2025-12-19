import application_commands.{type ChatInputOptionValue, ChatInputSignature} as command
import gleam/dict.{type Dict}
import gleam/string

pub fn chat_input() {
  // --- /hello <string>
  let signature =
    ChatInputSignature(
      name: "hello",
      description: "greets a name",
      options: [Nil],
      permissions: Nil,
      integration_types: [],
      contexts: [],
      nsfw: False,
    )
  let with_command = command.chat_input(signature:, handler: _)
  use _i: Nil, opts: Dict(String, ChatInputOptionValue) <- with_command()
  let assert Ok(command.StringValue(name)) = dict.get(opts, "name")

  "Hello " <> name <> "!"
}

pub fn chat_input_group() {
  command.chat_input_group("hello", "greeting commands")
  |> command.add_subcommand_group(
    command.subcommand_group("world", "greet the world", [
      // --- /hello world times <int>
      times_subcommand(),
    ]),
  )
  |> command.add_subcommand(
    // --- /hello name <string>
    name_subcommand(),
  )
}

fn times_subcommand() {
  let signature =
    ChatInputSignature(
      name: "times",
      description: "greets the world a number of times",
      options: [Nil],
      permissions: Nil,
      integration_types: [],
      contexts: [],
      nsfw: False,
    )
  let with_command = command.subcommand(signature:, handler: _)
  use _i, opts <- with_command()
  let assert Ok(command.IntegerValue(times)) = dict.get(opts, "times")

  string.repeat("Hello World!", times:)
}

fn name_subcommand() {
  let signature =
    ChatInputSignature(
      name: "name",
      description: "greet a name",
      options: [Nil],
      permissions: Nil,
      integration_types: [],
      contexts: [],
      nsfw: False,
    )
  let with_command = command.subcommand(signature:, handler: _)
  use _i, opts <- with_command()
  let assert Ok(command.StringValue(name)) = dict.get(opts, "times")

  "Hello " <> name <> "!"
}
