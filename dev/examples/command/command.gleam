import command/command
import command/interaction.{MessageData, UserData}
import message

pub fn greet() {
  let sig = command.Signature

  use i, _s <- command.user(sig:)
  let assert interaction.User(UserData(target_id: target, ..)) = i.data

  { "Hello <@" <> target <> ">!" }
  |> message.NewText(flags: [])
  |> command.MessageResponse
}

pub fn report() {
  let sig = command.Signature

  use i, _s <- command.message(sig:)
  let assert interaction.Message(MessageData(target_id: target, ..)) = i.data

  { "Successfully reported <#" <> target <> ">" }
  |> message.NewText(flags: [message.Ephemeral])
  |> command.MessageResponse
}

pub fn hex() {
  let sig = command.Signature
  let opts = []

  use _i, _o, _s <- command.chat_input(sig:, opts:)

  { "" }
  |> message.NewText(flags: [])
  |> command.MessageResponse
}
