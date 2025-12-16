import application_commands.{ChatInputSignature} as command
import gleam/dynamic.{type Dynamic}
import gleam/io

pub fn chat_input() {
  let with_command = command.ChatInput(ChatInputSignature, _)
  use i: String, opts: Dynamic <- with_command()
  io.println(i)
  io.println(dynamic.classify(opts))

  "Hello World!"
}

pub fn chat_input_group() {
  command.ChatInputGroup(ChatInputSignature, [
    #(ChatInputSignature, {
      fn(i: String, opts: Dynamic) -> String {
        io.println(i)
        io.println(dynamic.classify(opts))

        "Hello World!"
      }
    }),
  ])
}
