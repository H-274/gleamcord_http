import command/text
import entities/locale.{type Locale}
import internal/type_utils

pub opaque type Group {
  Group(
    name: String,
    name_locales: List(#(Locale, String)),
    options: List(type_utils.Or(Subgroup, text.Command)),
  )
}

pub fn group(
  name name: String,
  options options: List(type_utils.Or(Subgroup, text.Command)),
) {
  Group(name:, name_locales: [], options:)
}

pub fn group_name_locales(group: Group, name_locales: List(#(Locale, String))) {
  Group(..group, name_locales:)
}

pub fn group_subgroup(subgroup: Subgroup) {
  type_utils.A(subgroup)
}

pub fn group_command(command: text.Command) {
  type_utils.B(command)
}

pub opaque type Subgroup {
  Subgroup(
    name: String,
    name_locales: List(#(Locale, String)),
    commands: List(text.Command),
  )
}

pub fn subgroup(name name: String, commands commands: List(text.Command)) {
  Subgroup(name:, name_locales: [], commands:)
}

pub fn subgroup_name_locales(
  sub_group: Subgroup,
  name_locales: List(#(Locale, String)),
) {
  Subgroup(..sub_group, name_locales:)
}
