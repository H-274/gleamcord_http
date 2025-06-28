import entities/integration
import entities/interaction_context
import entities/locale
import user_command.{user_command}

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

  "Hello, world!"
}
