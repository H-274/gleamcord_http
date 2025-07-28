import command/text_command.{text_command}
import entities/integration
import entities/interaction_context
import entities/locale
import entities/message

pub fn standalone() {
  let handle = fn(handler) {
    text_command(
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

  message.Create(..message.create_default(), content: "Hello, world")
  |> text_command.MessageResponse()
}

pub fn group() {
  text_command.group(name: "primary", options: [
    // Resulting command: /primary hello
    text_command.group_command(standalone()),
    text_command.group_subgroup(
      text_command.subgroup(name: "secondary", commands: [
        // Resulting command: /primary secondary hello
        standalone(),
      ]),
    ),
  ])
}
