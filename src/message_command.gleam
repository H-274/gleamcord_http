import entities/integration.{type Integration}
import entities/interaction_context.{type InteractionContext}
import entities/locale.{type Locale}

pub opaque type MessageCommand {
  MessageCommand(
    name: String,
    name_localizations: List(#(Locale, String)),
    default_member_permissions: String,
    integrations: List(Integration),
    contexts: List(InteractionContext),
    nsfw: Bool,
    handler: UserCommandHandler,
  )
}

pub fn message_command(
  name name: String,
  integs integrations: List(Integration),
  ctxs contexts: List(InteractionContext),
  handler handler: UserCommandHandler,
) {
  MessageCommand(
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
  command: MessageCommand,
  name_localizations: List(#(Locale, String)),
) {
  MessageCommand(..command, name_localizations:)
}

pub fn nsfw(command: MessageCommand, nsfw: Bool) {
  MessageCommand(..command, nsfw:)
}

pub fn default_member_permissions(
  command: MessageCommand,
  perms default_member_permissions: String,
) {
  MessageCommand(..command, default_member_permissions:)
}

/// TODO
pub type UserCommandHandler =
  fn() -> String
