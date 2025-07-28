import command/message_command.{message_command}
import entities/integration
import entities/interaction_context
import entities/locale
import entities/message as message_entity

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

  message_entity.Create(
    ..message_entity.create_default(),
    content: "Hello, world!",
  )
  |> message_command.MessageResponse()
}
