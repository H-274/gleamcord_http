import command/command_option.{type CommandOption}
import entities/component_message
import entities/integration.{type Integration}
import entities/interaction_context.{type InteractionContext}
import entities/locale.{type Locale}
import entities/message
import internal/type_utils

pub opaque type Command {
  Command(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    options: List(CommandOption),
    default_member_permissions: String,
    integration_types: List(Integration),
    contexts: List(InteractionContext),
    nsfw: Bool,
    handler: Handler,
  )
}

pub fn text_command(
  name name: String,
  description description: String,
  options options: List(CommandOption),
  integ_types integration_types: List(Integration),
  contexts contexts: List(InteractionContext),
  handler handler: Handler,
) {
  Command(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    options:,
    default_member_permissions: "",
    integration_types:,
    contexts:,
    nsfw: False,
    handler:,
  )
}

pub fn name_locales(command: Command, name_locales: List(#(Locale, String))) {
  Command(..command, name_locales:)
}

pub fn description_locales(
  command: Command,
  description_locales: List(#(Locale, String)),
) {
  Command(..command, description_locales:)
}

pub fn default_member_permissions(
  command: Command,
  default_member_permissions: String,
) {
  Command(..command, default_member_permissions:)
}

pub fn nsfw(command: Command, nsfw: Bool) {
  Command(..command, nsfw:)
}

/// TODO
pub type Handler =
  fn() -> Response

pub type Response {
  MessageResponse(message.Create)
  ComponentMessageResponse(component_message.Create)
}

pub opaque type Group {
  Group(
    name: String,
    name_locales: List(#(Locale, String)),
    options: List(type_utils.Or(Subgroup, Command)),
  )
}

pub fn group(
  name name: String,
  options options: List(type_utils.Or(Subgroup, Command)),
) {
  Group(name:, name_locales: [], options:)
}

pub fn group_name_locales(group: Group, name_locales: List(#(Locale, String))) {
  Group(..group, name_locales:)
}

pub fn group_subgroup(subgroup: Subgroup) {
  type_utils.A(subgroup)
}

pub fn group_command(command: Command) {
  type_utils.B(command)
}

pub opaque type Subgroup {
  Subgroup(
    name: String,
    name_locales: List(#(Locale, String)),
    commands: List(Command),
  )
}

pub fn subgroup(name name: String, commands commands: List(Command)) {
  Subgroup(name:, name_locales: [], commands:)
}

pub fn subgroup_name_locales(
  sub_group: Subgroup,
  name_locales: List(#(Locale, String)),
) {
  Subgroup(..sub_group, name_locales:)
}
