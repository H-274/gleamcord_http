import application_command/message_command
import application_command/response as command_response
import application_command/signature
import message

pub fn report() {
  let signature = signature.new(name: "report", desc: "report message")

  use _i, _s <- message_command.new(signature:)

  { "Message successfully reported" }
  |> message.NewText([message.Ephemeral])
  |> command_response.MessageWithSource
}
