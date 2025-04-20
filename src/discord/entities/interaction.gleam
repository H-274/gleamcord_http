pub type Interaction {
  Ping(Ping)
  ApplicationCommand(ApplicationCommand)
  MessageComponent(MessageComponent)
  Autocomplete(Autocomplete)
  ModalSubmit(ModalSubmit)
}

pub type Ping {
  PingInteraction
}

pub type ApplicationCommand {
  ApplicationCommandInteraction
}

pub type MessageComponent {
  MessageComponentInteraction
}

pub type Autocomplete {
  AutocompleteInteraction
}

pub type ModalSubmit {
  ModalSubmitInteraction
}
