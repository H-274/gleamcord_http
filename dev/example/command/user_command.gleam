import command/user_command.{user_command}
import entities/integration
import entities/interaction_context
import entities/locale
import entities/message

pub fn example() {
  let handle = fn(handler) {
    user_command(
      name: "hello_world",
      integs: [integration.GuildInstall],
      ctxs: [interaction_context.Guild],
      handler:,
    )
    |> user_command.name_localizations([#(locale.French, "bonjour_monde")])
  }

  use <- handle()

  message.Create(..message.create_default(), content: "Hello, world!")
  |> user_command.MessageResponse()
}
