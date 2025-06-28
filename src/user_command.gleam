import entities/integration.{type Integration}
import entities/interaction_context.{type InteractionContext}
import entities/locale.{type Locale}

pub opaque type UserCommand {
  UserCommand(
    name: String,
    name_localizations: List(#(Locale, String)),
    default_member_permissions: String,
    integrations: List(Integration),
    contexts: List(InteractionContext),
    nsfw: Bool,
    handler: Handler,
  )
}

pub fn user_command(
  name name: String,
  integs integrations: List(Integration),
  ctxs contexts: List(InteractionContext),
  handler handler: Handler,
) {
  UserCommand(
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
  command: UserCommand,
  name_localizations: List(#(Locale, String)),
) {
  UserCommand(..command, name_localizations:)
}

pub fn nsfw(command: UserCommand, nsfw: Bool) {
  UserCommand(..command, nsfw:)
}

pub fn default_member_permissions(
  command: UserCommand,
  perms default_member_permissions: String,
) {
  UserCommand(..command, default_member_permissions:)
}

/// TODO
pub type Handler =
  fn() -> String
