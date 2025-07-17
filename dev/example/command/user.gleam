import command/response
import command/user
import entities/integration
import entities/interaction_context
import entities/locale
import entities/message

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
  let response = fn(content: String) {
    message.Create(..message.create_default(), content:)
    |> response.Message()
  }

  "Hello, world!"
  |> response()
}
