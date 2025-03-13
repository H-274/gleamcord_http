pub type Interaction {
  Ping
  ApplicationCommandInteraction(ApplicationCommandInteraction)
  ApplicationCommandAutocomplete
  MessageComponent
  ModalSubmit
}

pub type ApplicationCommandInteraction {
  ApplicationCommand
}
