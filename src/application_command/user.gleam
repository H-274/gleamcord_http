//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object

import application_command/interaction.{type Interaction}
import application_command/response.{type Response}
import application_command/signature.{type Signature}

pub opaque type User(state) {
  User(signature: Signature, handler: Handler(state))
}

pub fn new(
  signature signature: Signature,
  handler handler: Handler(state),
) -> User(state) {
  User(signature:, handler:)
}

pub fn get_name(user: User(_)) -> String {
  user.signature.name
}

pub fn run(user: User(state), i, state: state) -> Result(Response(state), Nil) {
  user.handler(i, state) |> Ok
}

pub type Handler(state) =
  fn(Interaction, state) -> Response(state)
