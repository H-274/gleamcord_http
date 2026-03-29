import application_command/interaction.{type Interaction}
import application_command/response.{type Response}
import application_command/signature.{type Signature}

pub type Message(state) {
  Message(signature: Signature, handler: Handler(state))
}

pub fn new(
  signature signature: Signature,
  handler handler: Handler(state),
) -> Message(state) {
  Message(signature:, handler:)
}

pub fn get_name(message: Message(_)) -> String {
  message.signature.name
}

pub fn run(message: Message(state), i, state: state) -> Result(Response, Nil) {
  message.handler(i, state) |> Ok
}

pub type Handler(state) =
  fn(Interaction, state) -> Response
