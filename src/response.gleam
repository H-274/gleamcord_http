import message_component/response.{type Response as MessageComponentResponse} as _
import modal/response.{type Response as ModalResponse} as _

pub type Response(state) {
  Pong
  Command(Nil)
  Autocomplete(Nil)
  MessageComponent(MessageComponentResponse(state))
  Modal(ModalResponse)
}
