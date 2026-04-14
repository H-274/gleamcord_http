import application_command/response as command_response
import application_command/signature
import application_command/user_command
import gleam/int
import message

pub fn promote() {
  let signature = signature.new(name: "promote", desc: "promote user")

  use _i, _s <- user_command.new(signature:)
  let eligible = int.random(10) > 4

  case eligible {
    True ->
      { "Successfully promoted " <> todo as "get username from interaction" }
      |> message.NewText([])
    False -> "Failed to promote user" |> message.NewText([message.Ephemeral])
  }
  |> command_response.MessageWithSource
}
