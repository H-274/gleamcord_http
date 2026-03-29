import application_command/response as command_response

pub type Response {
  Pong
  Command(command_response.Response)
  Autocomplete(command_response.AutocompleteResponse)
}
