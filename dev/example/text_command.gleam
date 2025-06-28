import entities/integration
import entities/interaction_context
import entities/locale
import text_command

pub fn example() {
  let handle = fn(handler) {
    text_command.command(
      name: "hello",
      description: "world",
      options: [],
      integ_types: [integration.GuildInstall],
      contexts: [interaction_context.Guild],
      handler:,
    )
    |> text_command.name_locales([#(locale.French, "bonjour")])
    |> text_command.description_locales([#(locale.French, "monde")])
  }

  use <- handle()

  "Hello, world"
}
