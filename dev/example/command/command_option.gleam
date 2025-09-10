import command/command_option.{StringCommandOption, StringOption, string_option}
import command/text_command
import entities/message
import gleam/option

pub fn string_option_example() {
  let handle = fn(handler) {
    text_command.private_new(
      name: "hello",
      description: "greets user",
      options: [
        StringOption(string_option(name: "name", desc: "username")),
        StringOption(
          StringCommandOption(
            ..string_option(name: "age", desc: "your age"),
            required: False,
            autocomplete: option.Some(age_autocomplete),
          ),
        ),
      ],
      handler:,
    )
  }

  use _i, _bot <- handle()
  // TODO

  message.Create(..message.create_default(), content: "Hello, user")
  |> text_command.MessageResponse()
}

fn age_autocomplete() {
  Nil
}
