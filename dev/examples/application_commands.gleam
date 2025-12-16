import application_commands.{ChatInputSignature}
import gleam/dynamic
import gleam/io

pub fn chat_input() {
  let with_command = application_commands.chat_input(ChatInputSignature, _)

  use interaction, options <- with_command()
  io.println(interaction)
  io.println(dynamic.classify(options))

  "Hello World!"
}
