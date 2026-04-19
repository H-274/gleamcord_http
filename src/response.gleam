import command/response.{
  type AutocompleteResponse, type Response as CommandResponse,
}
import message_component/response.{type Response as MessageComponentResponse} as _
import modal/response.{type Response as ModalResponse} as _

pub type Response(state) {
  Pong
  Command(CommandResponse(state))
  Autocomplete(AutocompleteResponse)
  MessageComponent(MessageComponentResponse(state))
  Modal(ModalResponse)
}
