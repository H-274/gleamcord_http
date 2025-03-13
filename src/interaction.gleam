pub type Interaction {
  PingInteraction(PingInteraction)
  ApplicationCommandInteraction(ApplicationCommandInteraction)
  ApplicationCommandAutocomplete
  MessageComponent
  ModalSubmit
}

pub type PingInteraction {
  Ping
}

pub type ApplicationCommandInteraction {
  ApplicationCommand
}
