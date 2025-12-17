import application_commands.{type ChatInputOptionValue, ChatInputSignature} as command
import gleam/dict.{type Dict}

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

        "Hello " <> name <> "!"
      }),
    ]),
  )
  |> command.add_subcommand(
    command.subcommand(ChatInputSignature, fn(_i, opts) {
      let assert Ok(command.StringValue(name)) = dict.get(opts, "name")

      "Hello " <> name <> "!"
    }),
  )
}
