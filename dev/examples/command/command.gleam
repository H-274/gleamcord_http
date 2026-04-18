import command/command
import command/response
import message

pub fn ping() {
  let signature = command.simple_signature(name: "ping", desc: "Pongs!")

  use _i, _s, _o <- command.ChatInputCommand(signature:, options: [])

  { "Pong!" }
  |> message.NewText([])
  |> response.MessageWithSource
}

pub fn high_five() {
  let signature =
    command.simple_signature(name: "high_five", desc: "High five this user")

  use _i, _s <- command.User(signature:)

  { todo as "mention user" }
  |> message.NewText([])
  |> response.MessageWithSource
}
