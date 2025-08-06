import command/command_option.{
  StringCommandOption, StringOption, default_string_option,
}
import command/text_command.{text_command}
import entities/integration
import entities/interaction_context
import entities/message
import gleam/option

pub fn string_option() {
  let handle = fn(options, handler) {
    text_command(
      name: "hello",
      description: "greets user",
      options: options,
      integ_types: [integration.GuildInstall],
      contexts: [interaction_context.Guild],
      handler: handler,
    )
  }

  let options = [
    StringOption(default_string_option("name", "username")),
    StringOption(
      StringCommandOption(
        ..default_string_option("age", "your age"),
        required: False,
        autocomplete: option.Some(age_autocomplete),
      ),
    ),
  ]

  use <- handle(options)

  // TODO
  message.Create(..message.create_default(), content: "Hello, user")
  |> text_command.MessageResponse()
}

fn age_autocomplete() {
  Nil
}
