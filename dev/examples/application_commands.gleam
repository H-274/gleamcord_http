import application_commands.{type ChatInputOptionValue, ChatInputSignature} as command
import gleam/dict.{type Dict}
import gleam/io

pub fn chat_input() {
  let with_command = command.ChatInput(ChatInputSignature, _)
  use i: String, opts: Dict(String, ChatInputOptionValue) <- with_command()
  let assert Ok(command.StringValue(name)) = dict.get(opts, "name")
  io.println(i)

  "Hello " <> name <> "!"
}

pub fn chat_input_group() {
  command.ChatInputGroup(ChatInputSignature, [
    #(ChatInputSignature, {
      fn(i: String, opts: Dict(String, ChatInputOptionValue)) -> String {
        let assert Ok(command.StringValue(name)) = dict.get(opts, "name")
        io.println(i)

        "Hello " <> name <> "!"
      }
    }),
  ])
}
