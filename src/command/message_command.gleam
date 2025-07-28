import entities/integration.{type Integration}
import entities/interaction_context.{type InteractionContext}
import entities/locale.{type Locale}
import entities/message

pub opaque type Command {
  Command(
    name: String,
    name_localizations: List(#(Locale, String)),
    default_member_permissions: String,
    integrations: List(Integration),
    contexts: List(InteractionContext),
    nsfw: Bool,
    handler: Handler,
  )
}

pub fn message_command(
  name name: String,
  integs integrations: List(Integration),
  ctxs contexts: List(InteractionContext),
  handler handler: Handler,
) {
  Command(
    name:,
    name_localizations: [],
    default_member_permissions: "",
    integrations:,
    contexts:,
    nsfw: False,
    handler:,
  )
}

pub fn name_localizations(
  command: Command,
  name_localizations: List(#(Locale, String)),
) {
  Command(..command, name_localizations:)
}

pub fn nsfw(command: Command, nsfw: Bool) {
  Command(..command, nsfw:)
}

pub fn default_member_permissions(
  command: Command,
  perms default_member_permissions: String,
) {
  Command(..command, default_member_permissions:)
}

/// TODO
pub type Handler =
  fn() -> Response

pub type Response {
  MessageResponse(message.Create)
}
