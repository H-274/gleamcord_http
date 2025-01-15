import credentials.{type Credentials}
import interaction
import locale.{type Locale}

pub type Response {
  JsonString(String)
}

pub type Error {
  NotImplemented
}

/// TODO
pub type Data {
  Data
}

pub opaque type MessageCommand(ctx) {
  MessageCommand(
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
  MessageCommand(
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
  command: MessageCommand(ctx),
  locales name_locales: List(#(Locale, String)),
) {
  MessageCommand(..command, name_locales:)
}

pub fn default_member_permissions(
  command: MessageCommand(ctx),
  perms default_member_permissions: String,
) {
  MessageCommand(..command, default_member_permissions:)
}

pub fn nsfw(command: MessageCommand(ctx)) {
  MessageCommand(..command, nsfw: True)
}

pub fn handler(command: MessageCommand(ctx), handler handler: Handler(ctx)) {
  MessageCommand(..command, handler:)
}

pub type Handler(ctx) =
  fn(interaction.AppCommand(Data), Credentials, ctx) -> Result(Response, Error)

fn default_handler(_, _, _) {
  Error(NotImplemented)
}

pub fn run(
  command: MessageCommand(ctx),
  interaction: interaction.AppCommand(Data),
  creds: Credentials,
  ctx: ctx,
) {
  command.handler(interaction, creds, ctx)
}
