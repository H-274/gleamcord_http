import discord/entities/choice.{type Choice}
import discord/entities/interaction
import discord/entities/resolved.{type Resolved}
import gleam/dict.{type Dict}
import gleam/dynamic/decode
import gleam/float
import gleam/int
import gleam/option.{type Option}
import gleam/result

pub const min_len: Int = 0

pub const max_len: Int = 6000

pub const min_int: Int = -9_007_199_254_740_991

pub const max_int: Int = 9_007_199_254_740_991

pub const min_number: Float = -1.7976931348623157e308

pub const max_number: Float = 1.7976931348623157e308

pub type Base {
  Base(
    name: String,
    name_localizations: List(#(String, String)),
    description: String,
    description_localizations: List(#(String, String)),
    required: Bool,
  )
}

pub fn base(name name: String, desc description: String) -> Base {
  Base(
    name:,
    name_localizations: [],
    description:,
    description_localizations: [],
    required: True,
  )
}

pub fn name_locales(
  base: Base,
  name_locales name_localizations: List(#(String, String)),
) {
  Base(..base, name_localizations:)
}

pub fn desc_locales(
  base: Base,
  desc_locales description_localizations: List(#(String, String)),
) {
  Base(..base, description_localizations:)
}

pub fn required(base: Base, req required: Bool) {
  Base(..base, required:)
}

pub opaque type ParamDefinition(bot) {
  StringDefinition(
    Base,
    choices: List(Choice(String)),
    min_length: Option(Int),
    max_length: Option(Int),
    autocomplete: Option(AutocompleteHandler(bot)),
  )
  IntegerDefinition(
    Base,
    choices: List(Choice(Int)),
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: Option(AutocompleteHandler(bot)),
  )
  BooleanDefinition(Base)
  UserDefinition(Base)
  ChannelDefinition(Base)
  RoleDefinition(Base)
  MentionableDefinition(Base)
  NumberDefinition(
    Base,
    choices: List(Choice(Float)),
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: Option(AutocompleteHandler(bot)),
  )
  AttachmentDefinition(Base)
}

pub opaque type StringBuilder(bot) {
  StringBuilder(
    Base,
    choices: List(Choice(String)),
    min_length: Option(Int),
    max_length: Option(Int),
    autocomplete: Option(AutocompleteHandler(bot)),
  )
}

pub fn string_builder(base: Base) {
  StringBuilder(base, [], option.None, option.None, option.None)
}

pub fn string_choices(builder: StringBuilder(_), choices: List(Choice(String))) {
  StringBuilder(..builder, choices:)
}

/// The value will be clamped between the allowed min and max
pub fn string_min_length(builder: StringBuilder(_), min_length: Int) {
  let min_length = int.clamp(min_length, min_len, max_len)
  StringBuilder(..builder, min_length: option.Some(min_length))
}

/// The value will be clamped between the allowed min and max
pub fn string_max_length(builder: StringBuilder(_), max_length: Int) {
  let max_length = int.clamp(max_length, min_len, max_len)
  StringBuilder(..builder, max_length: option.Some(max_length))
}

pub fn string_def(builder: StringBuilder(_)) {
  let StringBuilder(base, choices, min_length, max_length, autocomplete) =
    builder
  StringDefinition(base, choices:, min_length:, max_length:, autocomplete:)
}

pub fn string_with_autocomplete(
  builder: StringBuilder(bot),
  handler: AutocompleteHandler(bot),
) {
  StringBuilder(..builder, autocomplete: option.Some(handler))
  |> string_def()
}

pub opaque type IntegerBuilder(bot) {
  IntegerBuilder(
    Base,
    choices: List(Choice(Int)),
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: Option(AutocompleteHandler(bot)),
  )
}

pub fn integer_builder(base: Base) {
  IntegerBuilder(base, [], option.None, option.None, option.None)
}

pub fn integer_choices(builder: IntegerBuilder(_), choices: List(Choice(Int))) {
  IntegerBuilder(..builder, choices:)
}

/// The value will be clamped between the allowed min and max
pub fn integer_min_value(builder: IntegerBuilder(_), min_value: Int) {
  let min_value = int.clamp(min_value, min_int, max_int)
  IntegerBuilder(..builder, min_value: option.Some(min_value))
}

/// The value will be clamped between the allowed min and max
pub fn integer_max_value(builder: IntegerBuilder(_), max_value: Int) {
  let max_value = int.clamp(max_value, min_int, max_int)
  IntegerBuilder(..builder, max_value: option.Some(max_value))
}

pub fn integer_def(builder: IntegerBuilder(_)) {
  let IntegerBuilder(base, choices, min_value, max_value, autocomplete) =
    builder
  IntegerDefinition(base, choices:, min_value:, max_value:, autocomplete:)
}

pub fn integer_with_autocomplete(
  builder: IntegerBuilder(bot),
  handler: AutocompleteHandler(bot),
) {
  IntegerBuilder(..builder, autocomplete: option.Some(handler))
  |> integer_def()
}

pub fn boolean_def(base: Base) {
  BooleanDefinition(base)
}

pub fn user_def(base: Base) {
  UserDefinition(base)
}

pub fn channel_def(base: Base) {
  ChannelDefinition(base)
}

pub fn role_def(base: Base) {
  RoleDefinition(base)
}

pub fn mentionable_def(base: Base) {
  MentionableDefinition(base)
}

pub opaque type NumberBuilder(bot, response) {
  NumberBuilder(
    Base,
    choices: List(Choice(Float)),
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: Option(AutocompleteHandler(bot)),
  )
}

pub fn number_builder(base: Base) {
  NumberBuilder(base, [], option.None, option.None, option.None)
}

pub fn number_choices(
  builder: NumberBuilder(_, _),
  choices: List(Choice(Float)),
) {
  NumberBuilder(..builder, choices:)
}

/// The value will be clamped between the allowed min and max
pub fn number_min_value(builder: NumberBuilder(_, _), min_value: Float) {
  let min_value = float.clamp(min_value, min_number, max_number)
  NumberBuilder(..builder, min_value: option.Some(min_value))
}

/// The value will be clamped between the allowed min and max
pub fn number_max_value(builder: NumberBuilder(_, _), max_value: Float) {
  let max_value = float.clamp(max_value, min_number, max_number)
  NumberBuilder(..builder, max_value: option.Some(max_value))
}

pub fn number_def(builder: NumberBuilder(_, _)) {
  let NumberBuilder(base, choices, min_value, max_value, autocomplete) = builder
  NumberDefinition(base, choices:, min_value:, max_value:, autocomplete:)
}

pub fn number_with_autocomplete(
  builder: NumberBuilder(bot, response),
  handler: AutocompleteHandler(bot),
) {
  NumberBuilder(..builder, autocomplete: option.Some(handler))
  |> number_def()
}

pub fn attachment_def(base: Base) {
  AttachmentDefinition(base)
}

pub type AutocompleteHandler(bot) =
  fn(interaction.Autocomplete, Dict(String, Param), bot) -> AutocompleteResponse

pub type AutocompleteResponse {
  StringChoices(List(Choice(String)))
  IntegerChoices(List(Choice(Int)))
  NumberChoices(List(Choice(Float)))
}

const string_variant = 3

const integer_variant = 4

const boolean_variant = 5

const user_variant = 6

const channel_variant = 7

const role_variant = 8

const mentionable_variant = 9

const number_variant = 10

const attachment_variant = 11

pub type Param {
  String(name: String, value: String, focused: Bool)
  Integer(name: String, value: Int, focused: Bool)
  Boolean(name: String, value: Bool)
  User(name: String, value: String)
  Channel(name: String, value: String)
  Role(name: String, value: String)
  Mentionable(name: String, value: String)
  Number(name: String, value: Float, focused: Bool)
  Attachment(name: String, value: String)
}

pub fn param_decoder() -> decode.Decoder(Param) {
  use variant <- decode.field("type", decode.int)
  case variant {
    variant if variant == string_variant -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      use focused <- decode.field("focused", decode.bool)
      decode.success(String(name:, value:, focused:))
    }
    variant if variant == integer_variant -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.int)
      use focused <- decode.field("focused", decode.bool)
      decode.success(Integer(name:, value:, focused:))
    }
    variant if variant == boolean_variant -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.bool)
      decode.success(Boolean(name:, value:))
    }
    variant if variant == user_variant -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      decode.success(User(name:, value:))
    }
    variant if variant == channel_variant -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      decode.success(Channel(name:, value:))
    }
    variant if variant == role_variant -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      decode.success(Role(name:, value:))
    }
    variant if variant == mentionable_variant -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      decode.success(Mentionable(name:, value:))
    }
    variant if variant == number_variant -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.float)
      use focused <- decode.field("focused", decode.bool)
      decode.success(Number(name:, value:, focused:))
    }
    variant if variant == attachment_variant -> {
      use name <- decode.field("name", decode.string)
      use value <- decode.field("value", decode.string)
      decode.success(Attachment(name:, value:))
    }
    _ -> decode.failure(String("", "", False), "Param")
  }
}

pub fn get_string(
  params params: Dict(String, Param),
  name name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(String(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_integer(
  params params: Dict(String, Param),
  name name: String,
) -> Result(Int, Nil) {
  case dict.get(params, name) {
    Ok(Integer(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_bool(
  params params: Dict(String, Param),
  name name: String,
) -> Result(Bool, Nil) {
  case dict.get(params, name) {
    Ok(Boolean(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_user(
  params params: Dict(String, Param),
  name name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(User(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_resolved_user(
  params params: Dict(String, Param),
  name name: String,
  resolved resolved: Resolved,
) -> Result(_, Nil) {
  use users <- result.try(option.to_result(resolved.users, Nil))
  use user_id <- result.try(get_user(params:, name:))

  dict.get(users, user_id)
}

pub fn get_resolved_member(
  params params: Dict(String, Param),
  name name: String,
  resolved resolved: Resolved,
) -> Result(_, Nil) {
  use members <- result.try(option.to_result(resolved.members, Nil))
  use user_id <- result.try(get_user(params:, name:))

  dict.get(members, user_id)
}

pub fn get_channel(
  params params: Dict(String, Param),
  name name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(Channel(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_resolved_channel(
  params params: Dict(String, Param),
  name name: String,
  resolved resolved: Resolved,
) -> Result(_, Nil) {
  use channels <- result.try(option.to_result(resolved.channels, Nil))
  use channel_id <- result.try(get_channel(params:, name:))

  dict.get(channels, channel_id)
}

pub fn get_role(
  params params: Dict(String, Param),
  name name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(Role(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_resolved_role(
  params params: Dict(String, Param),
  name name: String,
  resolved resolved: Resolved,
) -> Result(_, Nil) {
  use roles <- result.try(option.to_result(resolved.roles, Nil))
  use role_id <- result.try(get_role(params:, name:))

  dict.get(roles, role_id)
}

pub fn get_mentionable(
  params params: Dict(String, Param),
  name name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(Mentionable(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_resolved_mentionable(
  params params: Dict(String, Param),
  name name: String,
  resolved resolved: Resolved,
) -> Result(_, Nil) {
  use mentionable_id <- result.try(get_mentionable(params:, name:))

  let user = {
    use users <- result.try(option.to_result(resolved.users, Nil))
    dict.get(users, mentionable_id)
  }
  let role = {
    use roles <- result.try(option.to_result(resolved.roles, Nil))
    dict.get(roles, mentionable_id)
  }

  Ok(#(user, role))
}

pub fn get_number(
  params params: Dict(String, Param),
  name name: String,
) -> Result(Float, Nil) {
  case dict.get(params, name) {
    Ok(Number(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_attachment(
  params params: Dict(String, Param),
  name name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(Attachment(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_resolved_attachment(
  params params: Dict(String, Param),
  name name: String,
  resolved resolved: Resolved,
) -> Result(_, Nil) {
  use attachments <- result.try(option.to_result(resolved.attachments, Nil))
  use attachment_id <- result.try(get_attachment(params:, name:))

  dict.get(attachments, attachment_id)
}
