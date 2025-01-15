import decode/zero as decode

pub type Interaction(data) {
  PingInteraction(Ping)
  AppCommandInteraction(AppCommand(data))
  AppCommandAutocompleteInteraction(AppCommandAutocomplete(data))
  MessageComponentInteraction(MessageComponent(data))
  ModalSubdmitInteraction(ModalSubmit(data))
}

pub fn decoder() -> decode.Decoder(Interaction(data)) {
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

fn ping_decoder() -> decode.Decoder(Interaction(data)) {
  decode.success(PingInteraction(Ping))
}

pub type AppCommand(data) {
  AppCommand(data: data)
}

fn app_command_decoder() -> decode.Decoder(Interaction(data)) {
  todo
}

pub type AppCommandAutocomplete(data) {
  AppCommandAutocomplete(data: data)
}

fn app_command_autocomplete_decoder() -> decode.Decoder(Interaction(data)) {
  todo
}

pub type MessageComponent(data) {
  MessageComponent(data: data)
}

fn message_component_decoder() -> decode.Decoder(Interaction(data)) {
  todo
}

pub type ModalSubmit(data) {
  ModalSubmit(data: data)
}

fn modal_submit_decoder() -> decode.Decoder(Interaction(data)) {
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
