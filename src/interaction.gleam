import decode/zero as decode

pub type Interaction {
  PingInteraction(Ping)
  AppCommandInteraction(AppCommand)
  AppCommandAutocompleteInteraction(AppCommandAutocomplete)
  MessageComponentInteraction(MessageComponent)
  ModalSubdmitInteraction(ModalSubmit)
}

pub fn decoder() -> decode.Decoder(Interaction) {
  use type_ <- decode.field("type", decode.int)

  case type_ {
    1 -> ping_decoder()
    2 -> app_command_decoder()
    3 -> app_command_autocomplete_decoder()
    4 -> message_component_decoder()
    5 -> modal_submit_decoder()

    _ -> decode.failure(PingInteraction(Ping), "Interaction")
  }
}

pub type Ping {
  Ping
}

fn ping_decoder() -> decode.Decoder(Interaction) {
  decode.success(PingInteraction(Ping))
}

pub type AppCommand {
  AppCommand
}

fn app_command_decoder() -> decode.Decoder(Interaction) {
  todo
}

pub type AppCommandAutocomplete {
  AppCommandAutocomplete
}

fn app_command_autocomplete_decoder() -> decode.Decoder(Interaction) {
  todo
}

pub type MessageComponent {
  MessageComponent
}

fn message_component_decoder() -> decode.Decoder(Interaction) {
  todo
}

pub type ModalSubmit {
  ModalSubmit
}

fn modal_submit_decoder() -> decode.Decoder(Interaction) {
  todo
}

pub type Context {
  Guild
  BotDm
  PrivateChannel
}

pub type InstallationContext {
  GuildInstall
  UserInstall
}
