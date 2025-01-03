import command/command_option
import command/handler.{type Handler}
import gleam/list
import locale.{type Locale}

pub opaque type Definition(ctx) {
  Definition(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    sub_or_options: SubsOrOptionsDefinition(ctx),
    default_member_permissions: String,
    integration_types: List(Int),
    contexts: List(Int),
    nsfw: Bool,
  )
}

pub fn new_definition(name name: String, desc description: String) {
  Definition(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    sub_or_options: OptionsDefinition([], handler.undefined),
    default_member_permissions: "",
    integration_types: [],
    contexts: [],
    nsfw: False,
  )
}

pub fn definition_locales(
  definition: Definition(ctx),
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(item) { #(item.0, item.1) })
  let description_locales = list.map(locales, fn(item) { #(item.0, item.2) })

  Definition(..definition, name_locales:, description_locales:)
}

pub fn definition_integration_types(
  definition: Definition(ctx),
  integration_types: List(Int),
) {
  Definition(..definition, integration_types:)
}

pub fn definition_contexts(definition: Definition(ctx), contexts: List(Int)) {
  Definition(..definition, contexts:)
}

pub fn definition_nsfw(definition: Definition(ctx)) {
  Definition(..definition, nsfw: True)
}

pub fn definition_options_handler(
  definition: Definition(ctx),
  options: List(command_option.Definition),
  handler: Handler(ctx),
) {
  Definition(..definition, sub_or_options: OptionsDefinition(options, handler))
}

pub fn definition_sub_commands(
  definition: Definition(ctx),
  subs: List(SubCommandTreeDefinition(ctx)),
) {
  Definition(..definition, sub_or_options: SubCommandDefinitions(subs))
}

pub opaque type SubsOrOptionsDefinition(ctx) {
  SubCommandDefinitions(List(SubCommandTreeDefinition(ctx)))
  OptionsDefinition(List(command_option.Definition), handler: Handler(ctx))
}

pub opaque type SubCommandTreeDefinition(ctx) {
  SubCommandGroupDefinition(SubCommandGroup(ctx))
  SubCommandDefinition(SubCommand(ctx))
}

pub opaque type SubCommandGroup(ctx) {
  SubCommandGroup(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    sub_commands: List(SubCommandTreeDefinition(ctx)),
  )
}

pub fn new_sub_command_group(name name: String, desc description: String) {
  SubCommandGroup(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    sub_commands: [],
  )
}

pub fn append_sub_command_definition(
  sub_group: SubCommandGroup(ctx),
  sub: SubCommandTreeDefinition(ctx),
) {
  SubCommandGroup(..sub_group, sub_commands: [sub, ..sub_group.sub_commands])
}

pub fn sub_command_group_locales(
  sub_group: SubCommandGroup(ctx),
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(item) { #(item.0, item.1) })
  let description_locales = list.map(locales, fn(item) { #(item.0, item.2) })

  SubCommandGroup(..sub_group, name_locales:, description_locales:)
}

/// TODO find better name?
pub fn sub_command_group_definition(
  sub_group: SubCommandGroup(ctx),
  sub_commands: List(SubCommandTreeDefinition(ctx)),
) {
  SubCommandGroupDefinition(SubCommandGroup(..sub_group, sub_commands:))
}

pub opaque type SubCommand(ctx) {
  SubCommand(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    options: List(command_option.Definition),
    handler: Handler(ctx),
  )
}

pub fn new_sub_command(name name: String, desc description: String) {
  SubCommand(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    options: [],
    handler: handler.undefined,
  )
}

pub fn sub_command_locales(
  sub: SubCommand(ctx),
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(item) { #(item.0, item.1) })
  let description_locales = list.map(locales, fn(item) { #(item.0, item.2) })

  SubCommand(..sub, name_locales:, description_locales:)
}

pub fn sub_command_handler_definition(
  sub: SubCommand(ctx),
  options: List(command_option.Definition),
  handler: Handler(ctx),
) {
  SubCommandDefinition(SubCommand(..sub, options:, handler:))
}
