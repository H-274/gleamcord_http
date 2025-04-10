import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option}
import interaction/application_command_autocomplete.{type AutocompleteHandler}

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
    choices: List(ParamChoice(String)),
    min_length: Option(Int),
    max_length: Option(Int),
    autocomplete: Option(AutocompleteHandler(Param, bot)),
  )
  IntegerDefinition(
    Base,
    choices: List(ParamChoice(Int)),
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: Option(AutocompleteHandler(Param, bot)),
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
    autocomplete: Option(AutocompleteHandler(Param, bot)),
  )
  AttachmentDefinition(Base)
}

pub opaque type StringBuilder(bot) {
  StringBuilder(
    Base,
    choices: List(ParamChoice(String)),
    min_length: Option(Int),
    max_length: Option(Int),
    autocomplete: Option(AutocompleteHandler(Param, bot)),
  )
}

pub fn string_builder(base: Base) {
  StringBuilder(base, [], option.None, option.None, option.None)
}

pub fn string_choices(
  builder: StringBuilder(_),
  choices: List(ParamChoice(String)),
) {
  StringBuilder(..builder, choices:)
}

pub fn string_min_length(builder: StringBuilder(_), min_length: Int) {
  StringBuilder(..builder, min_length: option.Some(min_length))
}

pub fn string_max_length(builder: StringBuilder(_), max_length: Int) {
  StringBuilder(..builder, max_length: option.Some(max_length))
}

pub fn string_def(builder: StringBuilder(_)) {
  let StringBuilder(base, choices, min_length, max_length, autocomplete) =
    builder
  StringDefinition(base, choices:, min_length:, max_length:, autocomplete:)
}

pub fn string_with_autocomplete(
  builder: StringBuilder(bot),
  handler: AutocompleteHandler(Param, bot),
) {
  StringBuilder(..builder, autocomplete: option.Some(handler))
  |> string_def()
}

pub opaque type IntegerBuilder(bot) {
  IntegerBuilder(
    Base,
    choices: List(ParamChoice(Int)),
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: Option(AutocompleteHandler(Param, bot)),
  )
}

pub fn integer_builder(base: Base) {
  IntegerBuilder(base, [], option.None, option.None, option.None)
}

pub fn integer_choices(
  builder: IntegerBuilder(_),
  choices: List(ParamChoice(Int)),
) {
  IntegerBuilder(..builder, choices:)
}

pub fn integer_min_value(builder: IntegerBuilder(_), min_value: Int) {
  IntegerBuilder(..builder, min_value: option.Some(min_value))
}

pub fn integer_max_value(builder: IntegerBuilder(_), max_value: Int) {
  IntegerBuilder(..builder, max_value: option.Some(max_value))
}

pub fn integer_def(builder: IntegerBuilder(_)) {
  let IntegerBuilder(base, choices, min_value, max_value, autocomplete) =
    builder
  IntegerDefinition(base, choices:, min_value:, max_value:, autocomplete:)
}

pub fn integer_with_autocomplete(
  builder: IntegerBuilder(bot),
  handler: AutocompleteHandler(Param, bot),
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

pub opaque type NumberBuilder(bot) {
  NumberBuilder(
    Base,
    choices: List(ParamChoice(Float)),
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: Option(AutocompleteHandler(Param, bot)),
  )
}

pub fn number_builder(base: Base) {
  NumberBuilder(base, [], option.None, option.None, option.None)
}

pub fn number_choices(
  builder: NumberBuilder(_),
  choices: List(ParamChoice(Float)),
) {
  NumberBuilder(..builder, choices:)
}

pub fn number_min_value(builder: NumberBuilder(_), min_value: Float) {
  NumberBuilder(..builder, min_value: option.Some(min_value))
}

pub fn number_max_value(builder: NumberBuilder(_), max_value: Float) {
  NumberBuilder(..builder, max_value: option.Some(max_value))
}

pub fn number_def(builder: NumberBuilder(_)) {
  let NumberBuilder(base, choices, min_value, max_value, autocomplete) = builder
  NumberDefinition(base, choices:, min_value:, max_value:, autocomplete:)
}

pub fn number_with_autocomplete(
  builder: NumberBuilder(bot),
  handler: AutocompleteHandler(Param, bot),
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
  params: Dict(String, Param),
  name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(String(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_integer(
  params: Dict(String, Param),
  name: String,
) -> Result(Int, Nil) {
  case dict.get(params, name) {
    Ok(Integer(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_bool(params: Dict(String, Param), name: String) -> Result(Bool, Nil) {
  case dict.get(params, name) {
    Ok(Boolean(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_user(
  params: Dict(String, Param),
  name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(User(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_channel(
  params: Dict(String, Param),
  name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(Channel(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_role(
  params: Dict(String, Param),
  name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(Role(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_mentionable(
  params: Dict(String, Param),
  name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(Mentionable(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_number(
  params: Dict(String, Param),
  name: String,
) -> Result(Float, Nil) {
  case dict.get(params, name) {
    Ok(Number(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_attachment(
  params: Dict(String, Param),
  name: String,
) -> Result(String, Nil) {
  case dict.get(params, name) {
    Ok(Attachment(value: v, ..)) -> Ok(v)
    _ -> Error(Nil)
  }
}

pub fn get_focused(params: Dict(String, Param)) -> Result(Param, Nil) {
  use param <- list.find(dict.values(params))
  case param {
    String(focused: focused, ..)
    | Integer(focused: focused, ..)
    | Number(focused: focused, ..) -> focused

    _ -> False
  }
}
