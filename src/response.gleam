import application_command/response.{
  type AutocompleteResponse, type Response as CommandResponse,
} as _
import modal/response.{type Response as ModalResponse} as _

pub type Response {
  Pong
  Command(CommandResponse)
  Autocomplete(AutocompleteResponse)
  Modal(ModalResponse)
}
