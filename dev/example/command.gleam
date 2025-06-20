import command
import entities/integration
import entities/interaction_context

pub fn greet_message() {
  let command =
    command.message_command("greet")
    |> command.message_integration_types([integration.GuildInstall])
    |> command.message_contexts([interaction_context.Guild])

  use input <- command.message_execute(command)

  "Hello, \"" <> input <> "\"!"
}

pub fn greet_user() {
  let command =
    command.user_command("greet")
    |> command.user_integration_types([integration.GuildInstall])
    |> command.user_contexts([interaction_context.Guild])

  use input <- command.user_execute(command)

  "Hello, \"" <> input <> "\"!"
}
