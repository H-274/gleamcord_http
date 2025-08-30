import entities/integration.{type Integration}
import entities/interaction.{type Interaction}
import entities/interaction_context.{type InteractionContext}
import entities/locale.{type Locale}
import entities/message

pub opaque type Command(bot) {
  Command(
    name: String,
    name_localizations: List(#(Locale, String)),
    default_member_permissions: String,
    integrations: List(Integration),
    contexts: List(InteractionContext),
    nsfw: Bool,
    handler: Handler(bot),
  )
}

pub fn user_command(
  name name: String,
  integs integrations: List(Integration),
  ctxs contexts: List(InteractionContext),
  handler handler: Handler(bot),
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
  command: Command(bot),
  name_localizations: List(#(Locale, String)),
) {
  Command(..command, name_localizations:)
}

pub fn nsfw(command: Command(bot), nsfw: Bool) {
  Command(..command, nsfw:)
}

pub fn default_member_permissions(
  command: Command(bot),
  perms default_member_permissions: String,
) {
  Command(..command, default_member_permissions:)
}

/// TODO
pub type Handler(bot) =
  fn(Interaction, bot) -> Response

pub type Response {
  MessageResponse(message.Create)
}
