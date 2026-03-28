import application_command/response.{type Response}
import application_command/signature.{type Signature}
import interaction/interaction.{type Interaction}

pub type User(state) {
  User(signature: Signature, handler: Handler(state))
}

pub fn new(
  signature signature: Signature,
  handler handler: Handler(state),
) -> User(state) {
  User(signature:, handler:)
}

pub fn run(user: User(state), i, state: state) -> Result(Response, Nil) {
  user.handler(i, state) |> Ok
}

pub type Handler(state) =
  fn(Interaction, state) -> Response
