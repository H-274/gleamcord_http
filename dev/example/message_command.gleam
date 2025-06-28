import entities/integration
import entities/interaction_context
import entities/locale
import message_command.{message_command}

pub fn example() {
  let handle = fn(handler) {
    message_command(
      name: "hello_world",
      integs: [integration.GuildInstall],
      ctxs: [interaction_context.Guild],
      handler:,
    )
    |> message_command.name_localizations([#(locale.French, "bonjour_monde")])
  }

  use <- handle()

  "Hello, world!"
}
