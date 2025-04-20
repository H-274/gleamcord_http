import application_command_autocomplete.{type AutocompleteHandler}
import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/option.{type Option}

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

pub opaque type ParamDefinition(autocomplete, bot, success, failure) {
  StringDefinition(
    Base,
    choices: List(ParamChoice(String)),
    min_length: Option(Int),
    max_length: Option(Int),
    autocomplete: Option(
      AutocompleteHandler(autocomplete, Param, bot, success, failure),
    ),
  )
  IntegerDefinition(
    Base,
    choices: List(ParamChoice(Int)),
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: Option(
      AutocompleteHandler(autocomplete, Param, bot, success, failure),
    ),
  )
  BooleanDefinition(Base)
  UserDefinition(Base)
  ChannelDefinition(Base)
  RoleDefinition(Base)
  MentionableDefinition(Base)
  NumberDefinition(
    Base,
    choices: List(ParamChoice(Float)),
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: Option(
      AutocompleteHandler(autocomplete, Param, bot, success, failure),
    ),
  )
  AttachmentDefinition(Base)
}

pub opaque type StringBuilder(autocomplete, bot, success, failure) {
  StringBuilder(
    Base,
    choices: List(ParamChoice(String)),
    min_length: Option(Int),
    max_length: Option(Int),
    autocomplete: Option(
      AutocompleteHandler(autocomplete, Param, bot, success, failure),
    ),
  )
}

pub fn string_builder(base: Base) {
  StringBuilder(base, [], option.None, option.None, option.None)
}

pub fn string_choices(
  builder: StringBuilder(_, _, _, _),
  choices: List(ParamChoice(String)),
) {
  StringBuilder(..builder, choices:)
}

/// The value will be clamped between the allowed min and max
pub fn string_min_length(builder: StringBuilder(_, _, _, _), min_length: Int) {
  let min_length = int.clamp(min_length, min_len, max_len)
  StringBuilder(..builder, min_length: option.Some(min_length))
}

/// The value will be clamped between the allowed min and max
pub fn string_max_length(builder: StringBuilder(_, _, _, _), max_length: Int) {
  let max_length = int.clamp(max_length, min_len, max_len)
  StringBuilder(..builder, max_length: option.Some(max_length))
}

pub fn string_def(builder: StringBuilder(_, _, _, _)) {
  let StringBuilder(base, choices, min_length, max_length, autocomplete) =
    builder
  StringDefinition(base, choices:, min_length:, max_length:, autocomplete:)
}

pub fn string_with_autocomplete(
  builder: StringBuilder(autocomplete, bot, _, _),
  handler: AutocompleteHandler(autocomplete, Param, bot, _, _),
) {
  StringBuilder(..builder, autocomplete: option.Some(handler))
  |> string_def()
}

pub opaque type IntegerBuilder(autocomplete, bot, success, failure) {
  IntegerBuilder(
    Base,
    choices: List(ParamChoice(Int)),
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: Option(
      AutocompleteHandler(autocomplete, Param, bot, success, failure),
    ),
  )
}

pub fn integer_builder(base: Base) {
  IntegerBuilder(base, [], option.None, option.None, option.None)
}

pub fn integer_choices(
  builder: IntegerBuilder(_, _, _, _),
  choices: List(ParamChoice(Int)),
) {
  IntegerBuilder(..builder, choices:)
}

/// The value will be clamped between the allowed min and max
pub fn integer_min_value(builder: IntegerBuilder(_, _, _, _), min_value: Int) {
  let min_value = int.clamp(min_value, min_int, max_int)
  IntegerBuilder(..builder, min_value: option.Some(min_value))
}

/// The value will be clamped between the allowed min and max
pub fn integer_max_value(builder: IntegerBuilder(_, _, _, _), max_value: Int) {
  let max_value = int.clamp(max_value, min_int, max_int)
  IntegerBuilder(..builder, max_value: option.Some(max_value))
}

pub fn integer_def(builder: IntegerBuilder(_, _, _, _)) {
  let IntegerBuilder(base, choices, min_value, max_value, autocomplete) =
    builder
  IntegerDefinition(base, choices:, min_value:, max_value:, autocomplete:)
}

pub fn integer_with_autocomplete(
  builder: IntegerBuilder(autocomplete, bot, success, failure),
  handler: AutocompleteHandler(autocomplete, Param, bot, success, failure),
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

pub opaque type NumberBuilder(autocomplete, bot, success, failure) {
  NumberBuilder(
    Base,
    choices: List(ParamChoice(Float)),
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: Option(
      AutocompleteHandler(autocomplete, Param, bot, success, failure),
    ),
  )
}

pub fn number_builder(base: Base) {
  NumberBuilder(base, [], option.None, option.None, option.None)
}

pub fn number_choices(
  builder: NumberBuilder(_, _, _, _),
  choices: List(ParamChoice(Float)),
) {
  NumberBuilder(..builder, choices:)
}

/// The value will be clamped between the allowed min and max
pub fn number_min_value(builder: NumberBuilder(_, _, _, _), min_value: Float) {
  let min_value = float.clamp(min_value, min_number, max_number)
  NumberBuilder(..builder, min_value: option.Some(min_value))
}

/// The value will be clamped between the allowed min and max
pub fn number_max_value(builder: NumberBuilder(_, _, _, _), max_value: Float) {
  let max_value = float.clamp(max_value, min_number, max_number)
  NumberBuilder(..builder, max_value: option.Some(max_value))
}

pub fn number_def(builder: NumberBuilder(_, _, _, _)) {
  let NumberBuilder(base, choices, min_value, max_value, autocomplete) = builder
  NumberDefinition(base, choices:, min_value:, max_value:, autocomplete:)
}

pub fn number_with_autocomplete(
  builder: NumberBuilder(autocomplete, bot, success, failure),
  handler: AutocompleteHandler(autocomplete, Param, bot, success, failure),
) {
  NumberBuilder(..builder, autocomplete: option.Some(handler))
  |> number_def()
}

pub fn attachment_def(base: Base) {
  AttachmentDefinition(base)
}

pub type ParamChoice(t) {
  ParamChoice(
    name: String,
    name_localizations: List(#(String, String)),
    value: t,
  )
}

pub fn new_choice(name: String, value: t) -> ParamChoice(t) {
  ParamChoice(name:, name_localizations: [], value:)
}

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

pub fn get_channel(
  params params: Dict(String, Param),
  name name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(Channel(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
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

pub fn get_mentionable(
  params params: Dict(String, Param),
  name name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(Mentionable(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
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
