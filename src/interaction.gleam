import application_command/interaction.{type Interaction as CommandInteraction} as _
import message_component/interaction.{
  type Interaction as MessageComponentInteraction,
} as _
import modal/interaction.{type Interaction as ModalInteraction} as _

pub type Interaction {
  Ping(id: String, application_id: String, token: String, version: Int)
  ApplicationCommand(CommandInteraction)
  MessageComponent(MessageComponentInteraction)
  ApplicationCommandAutocomplete(CommandInteraction)
  ModalSubmit(ModalInteraction)
}
