import gleam/option.{type Option}

pub const integer_min_value = -9_007_199_254_740_991

pub const integer_max_value = 9_007_199_254_740_991

pub const number_min_value = 5.0e-324

pub const number_max_value = 1.7976931348623157e308

pub type CommandOption {
  StringOption(StringOption)
  IntegerOption(IntegerOption)
  BooleanOption(BooleanOption)
  UserOption(UserOption)
  ChannelOption(ChannelOption)
  RoleOption(RoleOption)
  MentionableOption(MentionableOption)
  NumberOption(NumberOption)
  AttachmentOption(AttachmentOption)
}

pub type StringOption {
  StringCommandOption(
    name: String,
    name_localizations: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    required: Bool,
    choices: List(Nil),
    min_length: Int,
    max_length: Int,
    autocomplete: Option(AutocompleteHandler),
  )
}

pub fn default_string_option(
  name name: String,
  desc description: String,
) -> StringOption {
  StringCommandOption(
    name:,
    name_localizations: [],
    description:,
    description_locales: [],
    required: True,
    choices: [],
    min_length: 1,
    max_length: 6000,
    autocomplete: option.None,
  )
}

pub type IntegerOption {
  IntegerCommandOption(
    name: String,
    name_localizations: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    required: Bool,
    choices: List(Nil),
    min_value: Int,
    max_value: Int,
    autocomplete: Option(AutocompleteHandler),
  )
}

pub fn default_integer_option(
  name name: String,
  desc description: String,
) -> IntegerOption {
  IntegerCommandOption(
    name:,
    name_localizations: [],
    description:,
    description_locales: [],
    required: True,
    choices: [],
    min_value: integer_min_value,
    max_value: integer_max_value,
    autocomplete: option.None,
  )
}

pub type BooleanOption {
  BooleanCommandOption(
    name: String,
    name_localizations: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    required: Bool,
  )
}

pub fn default_boolean_option(
  name name: String,
  desc description: String,
) -> BooleanOption {
  BooleanCommandOption(
    name:,
    name_localizations: [],
    description:,
    description_locales: [],
    required: True,
  )
}

pub type UserOption {
  UserCommandOption(
    name: String,
    name_localizations: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    required: Bool,
  )
}

pub fn default_user_option(
  name name: String,
  desc description: String,
) -> UserOption {
  UserCommandOption(
    name:,
    name_localizations: [],
    description:,
    description_locales: [],
    required: True,
  )
}

pub type ChannelOption {
  ChannelCommandOption(
    name: String,
    name_localizations: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    required: Bool,
  )
}

pub fn default_channel_option(
  name name: String,
  desc description: String,
) -> ChannelOption {
  ChannelCommandOption(
    name:,
    name_localizations: [],
    description:,
    description_locales: [],
    required: True,
  )
}

pub type RoleOption {
  RoleCommandOption(
    name: String,
    name_localizations: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    required: Bool,
  )
}

pub fn default_role_option(name name: String, desc description: String) {
  RoleCommandOption(
    name:,
    name_localizations: [],
    description:,
    description_locales: [],
    required: True,
  )
}

pub type MentionableOption {
  MentionableCommandOption(
    name: String,
    name_localizations: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    required: Bool,
  )
}

pub fn default_mentionable_option(
  name name: String,
  desc description: String,
) -> MentionableOption {
  MentionableCommandOption(
    name:,
    name_localizations: [],
    description:,
    description_locales: [],
    required: True,
  )
}

pub type NumberOption {
  NumberCommandOption(
    name: String,
    name_localizations: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    required: Bool,
    choices: List(Nil),
    min_value: Float,
    max_value: Float,
    autocomplete: Option(AutocompleteHandler),
  )
}

pub fn default_number_option(name name: String, desc description: String) {
  NumberCommandOption(
    name:,
    name_localizations: [],
    description:,
    description_locales: [],
    required: True,
    choices: [],
    min_value: number_min_value,
    max_value: number_max_value,
    autocomplete: option.None,
  )
}

pub type AttachmentOption {
  AttachmentCommandOption(
    name: String,
    name_localizations: List(#(String, String)),
    description: String,
    description_locales: List(#(String, String)),
    required: Bool,
  )
}

pub fn default_attachment_option(name name: String, desc description: String) {
  AttachmentCommandOption(
    name:,
    name_localizations: [],
    description:,
    description_locales: [],
    required: True,
  )
}

/// TODO
pub type AutocompleteHandler =
  fn() -> Nil
