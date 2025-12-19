import application_commands.{type ChatInputOptionValue, ChatInputSignature} as command
import gleam/dict.{type Dict}
import gleam/string

pub fn chat_input() {
  let with_command = command.chat_input(ChatInputSignature, _)
  use _i: Nil, opts: Dict(String, ChatInputOptionValue) <- with_command()
  let assert Ok(command.StringValue(name)) = dict.get(opts, "name")

  "Hello " <> name <> "!"
}

pub fn chat_input_group() {
  command.chat_input_group(ChatInputSignature)
  |> command.add_subcommand_group(
    command.subcommand_group(ChatInputSignature, [
      command.subcommand(ChatInputSignature, fn(_i, opts) {
        let assert Ok(command.StringValue(name)) = dict.get(opts, "name")
        let assert Ok(command.IntegerValue(times)) = dict.get(opts, "times")

        string.repeat("Hello " <> name <> "!", times:)
      }),
    ]),
  )
  |> command.add_subcommand(
    command.subcommand(
      ChatInputSignature,
      fn(_i: Nil, opts: Dict(String, ChatInputOptionValue)) -> String {
        let assert Ok(command.StringValue(name)) = dict.get(opts, "name")

        "Hello " <> name <> "!"
      },
    ),
  )
}
