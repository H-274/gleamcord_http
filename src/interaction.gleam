import command/interaction.{type Interaction as ApplicationCommandInteraction} as command_interaction
import gleam/dynamic/decode
import message_component/interaction.{
  type Interaction as MessageComponentInteraction,
} as _
import modal/interaction.{type Interaction as ModalInteraction} as modal_interaction

pub type Interaction {
  Ping(id: String, application_id: String, token: String, version: Int)
  ApplicationCommand(ApplicationCommandInteraction)
  MessageComponent(MessageComponentInteraction)
  ApplicationCommandAutocomplete(ApplicationCommandInteraction)
  ModalSubmit(ModalInteraction)
}

/// TODO add other interaction decoders
pub fn decoder() {
  use t <- decode.field("type", decode.int)
  case t {
    1 -> ping_decoder()
    2 -> command_interaction.decoder() |> decode.map(ApplicationCommand)
    5 -> modal_interaction.decoder() |> decode.map(ModalSubmit)
    _ -> todo
  }
}

fn ping_decoder() {
  use id <- decode.field("id", decode.string)
  use application_id <- decode.field("application_id", decode.string)
  use token <- decode.field("token", decode.string)
  use version <- decode.field("version", decode.int)

  decode.success(Ping(id:, application_id:, token:, version:))
}
