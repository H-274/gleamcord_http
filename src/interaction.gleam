pub type Interaction {
  PingInteraction(PingInteraction)
  ApplicationCommandInteraction(ApplicationCommandInteraction)
  AutocompleteInteraction(AutocompleteInteraction)
  MessageComponentInteractiion(MessageComponentInteraction)
  ModalSubmitInteraction(ModalSubmitInteraction)
}

pub type PingInteraction {
  Ping
}

pub type ApplicationCommandInteraction {
  ApplicationCommand
}

pub type AutocompleteInteraction {
  Autocomplete
}

pub type MessageComponentInteraction {
  MessageComponent
}

pub type ModalSubmitInteraction {
  ModalSubmit
}
