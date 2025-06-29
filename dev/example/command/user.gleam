import command/user
import entities/integration
import entities/interaction_context
import entities/locale

pub fn example() {
  let handle = fn(handler) {
    user.command(
      name: "hello_world",
      integs: [integration.GuildInstall],
      ctxs: [interaction_context.Guild],
      handler:,
    )
    |> user.name_localizations([#(locale.French, "bonjour_monde")])
  }

  use <- handle()

  "Hello, world!"
}
