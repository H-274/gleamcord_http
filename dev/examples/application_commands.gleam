import application_commands.{ChatInputSignature}
import gleam/dynamic.{type Dynamic}
import gleam/io

pub fn chat_input() {
  application_commands.chat_input(ChatInputSignature, command_handler)
}

pub fn command_handler(i: String, opts: Dynamic) -> String {
  io.println(i)
  io.println(dynamic.classify(opts))

  "Hello World!"
}

pub fn chat_input_group() {
  application_commands.chat_input_group(ChatInputSignature, [
    #(ChatInputSignature, subcommand_handler),
  ])
}

pub fn subcommand_handler(i: String, opts: Dynamic) -> String {
  io.println(i)
  io.println(dynamic.classify(opts))

  "Hello World!"
}
