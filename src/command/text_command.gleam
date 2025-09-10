import command/command_option.{type CommandOption}
import entities/component_message
import entities/integration.{type Integration}
import entities/interaction.{type Interaction}
import entities/interaction_context.{type InteractionContext}
import entities/message
import internal/type_utils

pub opaque type Command(bot) {
  Command(
    name: String,
    name_locales: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    options: List(CommandOption),
    default_member_permissions: String,
    integration_types: List(Integration),
    contexts: List(InteractionContext),
    nsfw: Bool,
    handler: Handler(bot),
  )
}

pub fn text_command(
  name name: String,
  description description: String,
  options options: List(CommandOption),
  integ_types integration_types: List(Integration),
  contexts contexts: List(InteractionContext),
  handler handler: Handler(_),
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

pub fn name_locales(command: Command(_), name_locales: List(#(String, String))) {
  Command(..command, name_locales:)
}

pub fn description_locales(
  command: Command(_),
  description_locales: List(#(String, String)),
) {
  Command(..command, description_locales:)
}

pub fn default_member_permissions(
  command: Command(_),
  default_member_permissions: String,
) {
  Command(..command, default_member_permissions:)
}

pub fn nsfw(command: Command(_), nsfw: Bool) {
  Command(..command, nsfw:)
}

/// TODO
pub type Handler(bot) =
  fn(Interaction, bot) -> Response

pub type Response {
  MessageResponse(message.Create)
  ComponentMessageResponse(component_message.Create)
}

pub opaque type Group(bot) {
  Group(
    name: String,
    name_locales: List(#(String, String)),
    options: List(type_utils.Or(Subgroup(bot), Command(bot))),
  )
}

pub fn group(
  name name: String,
  options options: List(type_utils.Or(Subgroup(bot), Command(bot))),
) {
  Group(name:, name_locales: [], options:)
}

pub fn group_name_locales(
  group: Group(_),
  name_locales: List(#(String, String)),
) {
  Group(..group, name_locales:)
}

pub fn group_subgroup(subgroup: Subgroup(_)) {
  type_utils.A(subgroup)
}

pub fn group_command(command: Command(_)) {
  type_utils.B(command)
}

pub opaque type Subgroup(bot) {
  Subgroup(
    name: String,
    name_locales: List(#(String, String)),
    commands: List(Command(bot)),
  )
}

pub fn subgroup(name name: String, commands commands: List(Command(_))) {
  Subgroup(name:, name_locales: [], commands:)
}

pub fn subgroup_name_locales(
  sub_group: Subgroup(_),
  name_locales: List(#(String, String)),
) {
  Subgroup(..sub_group, name_locales:)
}
