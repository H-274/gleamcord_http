import application_command/response.{
  type AutocompleteResponse, type Response as CommandResponse,
} as _
import modal/response.{type Response as ModalResponse} as _

pub type Response(state) {
  Pong
  Command(CommandResponse(state))
  Autocomplete(AutocompleteResponse)
  Modal(ModalResponse)
}
