pub type Interaction(data) {
  PingInteraction(Ping)
  AppCommandInteraction(AppCommand(data))
  AppCommandAutocompleteInteraction(AppCommandAutocomplete(data))
  MessageComponentInteraction(MessageComponent(data))
  ModalSubdmitInteraction(ModalSubdmit(data))
}

pub type Ping {
  Ping
}

pub type AppCommand(command_data) {
  AppCommand(data: command_data)
}

pub type AppCommandAutocomplete(command_data) {
  AppCommandAutocomplete(data: command_data)
}

pub type MessageComponent(component_data) {
  MessageComponent(data: component_data)
}

pub type ModalSubdmit(modal_data) {
  ModalSubdmit(data: modal_data)
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
