import gleam/dynamic/decode

pub type Interaction {
  Ping(Ping)
  ApplicationCommand(ApplicationCommand)
  MessageComponent(MessageComponent)
  Autocomplete(Autocomplete)
  ModalSubmit(ModalSubmit)
}

pub fn decode_interaction() {
  use type_ <- decode.field("type", decode.int)

  case type_ {
    1 -> decode_ping() |> decode.map(Ping)
    2 -> decode_command() |> decode.map(ApplicationCommand)
    3 -> decode_component() |> decode.map(MessageComponent)
    4 -> decode_autocomplete() |> decode.map(Autocomplete)
    5 -> decode_modal() |> decode.map(ModalSubmit)
    _ -> decode.failure(Ping(PingInteraction), "Interaction")
  }
}

pub type Ping {
  PingInteraction
}

fn decode_ping() {
  todo
}

pub type ApplicationCommand {
  ApplicationCommandInteraction
}

fn decode_command() {
  todo
}

pub type MessageComponent {
  MessageComponentInteraction
}

fn decode_component() {
  todo
}

pub type Autocomplete {
  AutocompleteInteraction
}

fn decode_autocomplete() {
  todo
}

pub type ModalSubmit {
  ModalSubmitInteraction
}

fn decode_modal() {
  todo
}
