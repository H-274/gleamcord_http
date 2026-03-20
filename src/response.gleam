import response/application_command

pub type Response {
  Pong
  Command(application_command.Command)
  Autocomplete(application_command.Autocomplete)
}
