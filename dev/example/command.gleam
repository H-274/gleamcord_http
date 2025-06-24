import command
import entities/integration
import entities/interaction_context

pub fn greet_message() {
  let command =
    command.message_command(
      name: "greet",
      integrations: [integration.GuildInstall],
      contexts: [interaction_context.Guild],
    )

  use input <- command.message_execute(command)

  "Hello, \"" <> input <> "\"!"
}

pub fn greet_user() {
  let command =
    command.user_command(
      name: "greet",
      integrations: [integration.GuildInstall],
      contexts: [interaction_context.Guild],
    )

  use input <- command.user_execute(command)

  "Hello, \"" <> input <> "\"!"
}

pub fn greet_text() {
  let command =
    command.text_command(
      name: "greet",
      description: "greets the text you put in",
      integrations: [integration.GuildInstall],
      contexts: [interaction_context.Guild],
    )
    |> command.text_options([command.String])

  use input <- command.text_execute(command)

  "Hello, \"" <> input <> "\"!"
}
