import command/handler
import gleam/list
import locale.{type Locale}

pub opaque type Command(ctx) {
  Command(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    handler: handler.UserHandler(ctx),
    default_member_permissions: String,
    integration_types: List(Int),
    contexts: List(Int),
    nsfw: Bool,
  )
}

pub fn new_command(name name: String) {
  Command(
    name:,
    name_locales: [],
    description: "",
    handler: handler.user_undefined,
    default_member_permissions: "",
    integration_types: [],
    contexts: [],
    nsfw: False,
  )
}

pub fn command_locales(
  definition: Command(ctx),
  locales: List(#(Locale, String)),
) {
  let name_locales = list.map(locales, fn(item) { #(item.0, item.1) })

  Command(..definition, name_locales:)
}

pub fn command_integration_types(
  definition: Command(ctx),
  integration_types: List(Int),
) {
  Command(..definition, integration_types:)
}

pub fn command_contexts(definition: Command(ctx), contexts: List(Int)) {
  Command(..definition, contexts:)
}

pub fn command_nsfw(definition: Command(ctx)) {
  Command(..definition, nsfw: True)
}

pub fn command_handler(
  definition: Command(ctx),
  handler: handler.UserHandler(ctx),
) {
  Command(..definition, handler:)
}
