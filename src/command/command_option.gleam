import command/autocomplete/autocomplete
import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/list
import gleam/option.{type Option}
import gleam/result
import locale.{type Locale}

pub type Error {
  NotFound
  WrongType(expected: String)
}

/// TODO replace dynamic when resolved types exist
pub type CommandOption {
  String(name: String, value: String, focused: Bool)
  Integer(name: String, value: Int, focused: Bool)
  Boolean(name: String, value: Bool)
  User(name: String, value: Dynamic)
  Channel(name: String, value: Dynamic)
  Role(name: String, value: Dynamic)
  Mentionable(name: String, value: Dynamic)
  Number(name: String, value: Float, focused: Bool)
  Attachment(name: String, value: Dynamic)
}

pub fn extract_focused(
  options: Dict(String, CommandOption),
) -> Result(CommandOption, Nil) {
  use option <- list.find(dict.values(options))
  case option {
    String(focused: focused, ..)
    | Integer(focused: focused, ..)
    | Number(focused: focused, ..) -> focused
    _ -> False
  }
}

pub fn extract_string(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(String, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    String(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("String"))
  }
}

pub fn extract_integer(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Int, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Integer(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Integer"))
  }
}

pub fn extract_boolean(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Bool, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Boolean(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Boolean"))
  }
}

pub fn extract_user(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    User(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("User"))
  }
}

pub fn extract_channel(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Channel(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Channel"))
  }
}

pub fn extract_role(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Role(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Role"))
  }
}

pub fn extract_mentionable(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Mentionable(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Mentionable"))
  }
}

pub fn extract_number(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Float, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Number(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Number"))
  }
}

pub fn extract_attachment(
  options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  use option <- result.try(
    dict.get(options, name) |> result.replace_error(NotFound),
  )

  case option {
    Attachment(value: v, ..) -> Ok(v)
    _ -> Error(WrongType("Attachment"))
  }
}

pub opaque type Definition(ctx) {
  StringDefinition(StringDefinition(ctx))
  IntegerDefinition(IntegerDefinition(ctx))
  BooleanDefinition(BooleanDefinition)
  UserDefinition(UserDefinition)
  ChannelDefinition(ChannelDefinition)
  RoleDefinition(RoleDefinition)
  MentionableDefinition(MentionableDefinition)
  NumberDefinition(NumberDefinition(ctx))
  AttachmentDefinition(AttachmentDefinition)
}

pub opaque type StringDefinition(ctx) {
  StringDef(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
    choices: List(OptionChoice(String)),
    /// Between 0 and 6000
    min_length: Option(Int),
    /// Between 0 and 6000
    max_length: Option(Int),
    autocomplete: autocomplete.Handler(String, ctx),
  )
}

pub fn new_string_def(name name: String, desc description: String) {
  StringDef(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
    choices: [],
    min_length: option.None,
    max_length: option.None,
    autocomplete: autocomplete.default_handler,
  )
}

pub fn string_def_locales(
  def: StringDefinition(ctx),
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(l) { #(l.0, l.1) })
  let description_locales = list.map(locales, fn(l) { #(l.0, l.2) })

  StringDef(..def, name_locales:, description_locales:)
}

pub fn string_def_required(def: StringDefinition(ctx)) {
  StringDef(..def, required: True)
}

pub fn string_def_choices(
  def: StringDefinition(ctx),
  choices: List(OptionChoice(String)),
) {
  StringDef(..def, choices:)
}

pub fn string_def_min_length(def: StringDefinition(ctx), min_length: Int) {
  StringDef(..def, min_length: option.Some(min_length))
}

pub fn string_def_max_length(def: StringDefinition(ctx), max_length: Int) {
  StringDef(..def, max_length: option.Some(max_length))
}

pub fn string_def_autocomplete(
  def: StringDefinition(ctx),
  autocomplete: autocomplete.Handler(String, ctx),
) {
  StringDef(..def, autocomplete:)
}

pub fn string_def(def: StringDefinition(ctx)) {
  StringDefinition(def)
}

pub opaque type IntegerDefinition(ctx) {
  IntegerDef(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
    choices: List(OptionChoice(Int)),
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: autocomplete.Handler(Int, ctx),
  )
}

pub fn new_integer_def(name name: String, desc description: String) {
  IntegerDef(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
    choices: [],
    min_value: option.None,
    max_value: option.None,
    autocomplete: autocomplete.default_handler,
  )
}

pub fn integer_def_locales(
  def: IntegerDefinition(ctx),
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(l) { #(l.0, l.1) })
  let description_locales = list.map(locales, fn(l) { #(l.0, l.2) })

  IntegerDef(..def, name_locales:, description_locales:)
}

pub fn integer_def_required(def: IntegerDefinition(ctx)) {
  IntegerDef(..def, required: True)
}

pub fn integer_def_choices(
  def: IntegerDefinition(ctx),
  choices: List(OptionChoice(Int)),
) {
  IntegerDef(..def, choices:)
}

pub fn integer_def_min_length(def: IntegerDefinition(ctx), min_value: Int) {
  IntegerDef(..def, min_value: option.Some(min_value))
}

pub fn integer_def_max_length(def: IntegerDefinition(ctx), max_value: Int) {
  IntegerDef(..def, max_value: option.Some(max_value))
}

pub fn integer_def_autocomplete(
  def: IntegerDefinition(ctx),
  autocomplete: autocomplete.Handler(Int, ctx),
) {
  IntegerDef(..def, autocomplete:)
}

pub fn integer_def(def: IntegerDefinition(ctx)) {
  IntegerDefinition(def)
}

pub opaque type BooleanDefinition {
  BooleanDef(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
  )
}

pub fn new_boolean_def(name name: String, desc description: String) {
  BooleanDef(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
  )
}

pub fn boolean_def_locales(
  def: BooleanDefinition,
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(l) { #(l.0, l.1) })
  let description_locales = list.map(locales, fn(l) { #(l.0, l.2) })

  BooleanDef(..def, name_locales:, description_locales:)
}

pub fn boolean_def_required(def: BooleanDefinition) {
  BooleanDef(..def, required: True)
}

pub fn boolean_def(def: BooleanDefinition) {
  BooleanDefinition(def)
}

pub opaque type UserDefinition {
  UserDef(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
  )
}

pub fn new_user_def(name name: String, desc description: String) {
  UserDef(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
  )
}

pub fn user_def_locales(
  def: UserDefinition,
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(l) { #(l.0, l.1) })
  let description_locales = list.map(locales, fn(l) { #(l.0, l.2) })

  UserDef(..def, name_locales:, description_locales:)
}

pub fn user_def_required(def: UserDefinition) {
  UserDef(..def, required: True)
}

pub fn user_def(def: UserDefinition) {
  UserDefinition(def)
}

pub opaque type ChannelDefinition {
  ChannelDef(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
    // TODO (replace)
    channel_types: List(Int),
  )
}

pub fn new_channel_def(name name: String, desc description: String) {
  ChannelDef(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
    channel_types: [],
  )
}

pub fn channel_def_locales(
  def: ChannelDefinition,
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(l) { #(l.0, l.1) })
  let description_locales = list.map(locales, fn(l) { #(l.0, l.2) })

  ChannelDef(..def, name_locales:, description_locales:)
}

pub fn channel_def_required(def: ChannelDefinition) {
  ChannelDef(..def, required: True)
}

pub fn channel_def_typre(def: ChannelDefinition, channel_types: List(Int)) {
  ChannelDef(..def, channel_types:)
}

pub fn channel_def(def: ChannelDefinition) {
  ChannelDefinition(def)
}

pub opaque type RoleDefinition {
  RoleDef(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
  )
}

pub fn new_role_def(name name: String, desc description: String) {
  RoleDef(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
  )
}

pub fn role_def_locales(
  def: RoleDefinition,
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(l) { #(l.0, l.1) })
  let description_locales = list.map(locales, fn(l) { #(l.0, l.2) })

  RoleDef(..def, name_locales:, description_locales:)
}

pub fn role_def_required(def: RoleDefinition) {
  RoleDef(..def, required: True)
}

pub fn role_def(def: RoleDefinition) {
  RoleDefinition(def)
}

pub opaque type MentionableDefinition {
  MentionableDef(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
  )
}

pub fn new_mentionable_def(name name: String, desc description: String) {
  RoleDef(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
  )
}

pub fn mentionable_def_locales(
  def: MentionableDefinition,
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(l) { #(l.0, l.1) })
  let description_locales = list.map(locales, fn(l) { #(l.0, l.2) })

  MentionableDef(..def, name_locales:, description_locales:)
}

pub fn mentionable_def_required(def: MentionableDefinition) {
  MentionableDef(..def, required: True)
}

pub fn mentionable_def(def: MentionableDefinition) {
  MentionableDefinition(def)
}

pub opaque type NumberDefinition(ctx) {
  NumberDef(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
    choices: List(OptionChoice(Float)),
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: autocomplete.Handler(Float, ctx),
  )
}

pub fn new_number_def(name name: String, desc description: String) {
  NumberDef(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
    choices: [],
    min_value: option.None,
    max_value: option.None,
    autocomplete: autocomplete.default_handler,
  )
}

pub fn number_def_locales(
  def: NumberDefinition(ctx),
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(l) { #(l.0, l.1) })
  let description_locales = list.map(locales, fn(l) { #(l.0, l.2) })

  NumberDef(..def, name_locales:, description_locales:)
}

pub fn number_def_required(def: NumberDefinition(ctx)) {
  NumberDef(..def, required: True)
}

pub fn number_def_choices(
  def: NumberDefinition(ctx),
  choices: List(OptionChoice(Float)),
) {
  NumberDef(..def, choices:)
}

pub fn number_def_min_length(def: NumberDefinition(ctx), min_value: Float) {
  NumberDef(..def, min_value: option.Some(min_value))
}

pub fn number_def_max_length(def: NumberDefinition(ctx), max_value: Float) {
  NumberDef(..def, max_value: option.Some(max_value))
}

pub fn number_def_autocomplete(
  def: NumberDefinition(ctx),
  autocomplete: autocomplete.Handler(Float, ctx),
) {
  NumberDef(..def, autocomplete:)
}

pub fn number_def(def: NumberDefinition(ctx)) {
  NumberDefinition(def)
}

pub opaque type AttachmentDefinition {
  AttachmentDef(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
  )
}

pub fn new_attachment_def(name name: String, desc description: String) {
  AttachmentDef(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
  )
}

pub fn attachment_def_locales(
  def: AttachmentDefinition,
  locales: List(#(Locale, String, String)),
) {
  let name_locales = list.map(locales, fn(l) { #(l.0, l.1) })
  let description_locales = list.map(locales, fn(l) { #(l.0, l.2) })

  AttachmentDef(..def, name_locales:, description_locales:)
}

pub fn attachment_def_required(def: AttachmentDefinition) {
  AttachmentDef(..def, required: True)
}

pub fn attachment_def(def: AttachmentDefinition) {
  AttachmentDefinition(def)
}

pub type OptionChoice(value) {
  OptionChoice(
    name: String,
    name_locales: List(#(Locale, String)),
    value: value,
  )
}
