import command/response
import command/text
import entities/integration
import entities/interaction_context
import entities/locale
import entities/message

pub fn example() {
  let handle = fn(handler) {
    text.command(
      name: "hello",
      description: "world",
      options: [],
      integ_types: [integration.GuildInstall],
      contexts: [interaction_context.Guild],
      handler:,
    )
    |> text.name_locales([#(locale.French, "bonjour")])
    |> text.description_locales([#(locale.French, "monde")])
  }

  use <- handle()

  message.Create(..message.create_default(), content: "Hello, world")
  |> response.Message()
}
