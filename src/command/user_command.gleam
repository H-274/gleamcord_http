import bot.{type Bot}
import interaction
import locale.{type Locale}

pub type Response {
  JsonString(String)
}

pub type Error {
  NotImplemented
}

pub type Data {
  Data
}

pub opaque type UserCommand(ctx) {
  UserCommand(
    name: String,
    name_locales: List(#(Locale, String)),
    default_member_permissions: String,
    integration_types: List(interaction.InstallationContext),
    contexts: List(interaction.Context),
    nsfw: Bool,
    handler: Handler(ctx),
  )
}

pub fn new(
  name name: String,
  integration_types integration_types: List(interaction.InstallationContext),
  contexts contexts: List(interaction.Context),
) {
  UserCommand(
    name:,
    name_locales: [],
    default_member_permissions: "",
    integration_types:,
    contexts:,
    nsfw: False,
    handler: default_handler,
  )
}

pub fn name_locales(
  command: UserCommand(ctx),
  locales name_locales: List(#(Locale, String)),
) {
  UserCommand(..command, name_locales:)
}

pub fn default_member_permissions(
  command: UserCommand(ctx),
  perms default_member_permissions: String,
) {
  UserCommand(..command, default_member_permissions:)
}

pub fn nsfw(command: UserCommand(ctx)) {
  UserCommand(..command, nsfw: True)
}

pub fn handler(command: UserCommand(ctx), handler handler: Handler(ctx)) {
  UserCommand(..command, handler:)
}

pub type Handler(ctx) =
  fn(interaction.AppCommand(Data), Bot, ctx) -> Result(Response, Error)

fn default_handler(_, _, _) {
  Error(NotImplemented)
}
