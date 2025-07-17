import command/message
import command/response
import entities/integration
import entities/interaction_context
import entities/locale
import entities/message as message_entity

pub fn example() {
  let handle = fn(handler) {
    message.command(
      name: "hello_world",
      integs: [integration.GuildInstall],
      ctxs: [interaction_context.Guild],
      handler:,
    )
    |> message.name_localizations([#(locale.French, "bonjour_monde")])
  }

  use <- handle()
  let response = fn(content: String) {
    message_entity.Create(..message_entity.create_default(), content:)
    |> response.Message()
  }

  "Hello, world!"
  |> response()
}
