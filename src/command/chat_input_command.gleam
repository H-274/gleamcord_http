//// TODO

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

pub opaque type ChatInputCommand(ctx) {
  ChatInputCommand(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    default_member_permissions: String,
    integration_types: List(interaction.InstallationContext),
    contexts: List(interaction.Context),
    nsfw: Bool,
    handler: Handler(ctx),
  )
}

pub fn new(
  name name: String,
  desc description: String,
  integration_types integration_types: List(interaction.InstallationContext),
  contexts contexts: List(interaction.Context),
) {
  ChatInputCommand(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    default_member_permissions: "",
    integration_types:,
    contexts:,
    nsfw: False,
    handler: default_handler,
  )
}

pub fn name_locales(
  command: ChatInputCommand(ctx),
  locales name_locales: List(#(Locale, String)),
) {
  ChatInputCommand(..command, name_locales:)
}

pub fn default_member_permissions(
  command: ChatInputCommand(ctx),
  perms default_member_permissions: String,
) {
  ChatInputCommand(..command, default_member_permissions:)
}

pub fn nsfw(command: ChatInputCommand(ctx)) {
  ChatInputCommand(..command, nsfw: True)
}

pub fn handler(command: ChatInputCommand(ctx), handler handler: Handler(ctx)) {
  ChatInputCommand(..command, handler:)
}

pub type Handler(ctx) =
  fn(interaction.AppCommand(Data), Bot, ctx) -> Result(Response, Error)

fn default_handler(_, _, _) {
  Error(NotImplemented)
}
