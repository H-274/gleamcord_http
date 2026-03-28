import application_command/response as command

pub type Response {
  Pong
  Command(command.Response)
  Autocomplete(command.AutocompleteResponse)
}
