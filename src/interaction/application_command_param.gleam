//// TODO: Better param creation syntax

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

pub type BaseDefinition {
  BaseDefinition(
    name: String,
    name_localizations: List(#(String, String)),
    description: String,
    description_localizations: List(#(String, String)),
    required: Bool,
  )
}

pub fn new_base(name name: String, desc description: String) -> BaseDefinition {
  BaseDefinition(
    name:,
    name_localizations: [],
    description:,
    description_localizations: [],
    required: True,
  )
}

pub opaque type ParamDefinition(bot) {
  StringDefinition(
    BaseDefinition,
    choices: List(ParamChoice(String)),
    min_length: Option(Int),
    max_length: Option(Int),
    autocomplete: Option(AutocompleteHandler(Param, bot)),
  )
  IntegerDefinition(
    BaseDefinition,
    choices: List(ParamChoice(Int)),
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: Option(AutocompleteHandler(Param, bot)),
  )
  BooleanDefinition(BaseDefinition)
  UserDefinition(BaseDefinition)
  ChannelDefinition(BaseDefinition)
  RoleDefinition(BaseDefinition)
  MentionableDefinition(BaseDefinition)
  NumberDefinition(
    BaseDefinition,
    choices: List(ParamChoice(Float)),
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: Option(AutocompleteHandler(Param, bot)),
  )
  AttachmentDefinition(BaseDefinition)
}

pub type StringDefBuilder(bot) {
  StringDefBuilder(
    BaseDefinition,
    choices: List(ParamChoice(String)),
    min_length: Option(Int),
    max_length: Option(Int),
    autocomplete: Option(AutocompleteHandler(Param, bot)),
  )
}

pub fn string_builder(base: BaseDefinition) {
  StringDefBuilder(base, [], option.None, option.None, option.None)
}

pub fn string_def(builder: StringDefBuilder(_)) {
  let StringDefBuilder(base, choices, min_length, max_length, autocomplete) =
    builder
  StringDefinition(base, choices:, min_length:, max_length:, autocomplete:)
}

pub fn string_with_autocomplete(
  builder: StringDefBuilder(bot),
  handler: AutocompleteHandler(Param, bot),
) {
  StringDefBuilder(..builder, autocomplete: option.Some(handler))
  |> string_def()
}

pub type IntegerDefBuilder(bot) {
  IntegerDefBuilder(
    BaseDefinition,
    choices: List(ParamChoice(Int)),
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: Option(AutocompleteHandler(Param, bot)),
  )
}

pub fn integer_builder(base: BaseDefinition) {
  IntegerDefBuilder(base, [], option.None, option.None, option.None)
}

pub fn integer_def(builder: IntegerDefBuilder(_)) {
  let IntegerDefBuilder(base, choices, min_value, max_value, autocomplete) =
    builder
  IntegerDefinition(base, choices:, min_value:, max_value:, autocomplete:)
}

pub fn integer_with_autocomplete(
  builder: IntegerDefBuilder(bot),
  handler: AutocompleteHandler(Param, bot),
) {
  IntegerDefBuilder(..builder, autocomplete: option.Some(handler))
  |> integer_def()
}

pub fn boolean_def(base: BaseDefinition) {
  BooleanDefinition(base)
}

pub fn user_def(base: BaseDefinition) {
  UserDefinition(base)
}

pub fn channel_def(base: BaseDefinition) {
  ChannelDefinition(base)
}

pub fn role_def(base: BaseDefinition) {
  RoleDefinition(base)
}

pub fn mentionable_def(base: BaseDefinition) {
  MentionableDefinition(base)
}

pub type NumberDefBuilder(bot) {
  NumberDefBuilder(
    BaseDefinition,
    choices: List(ParamChoice(Float)),
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: Option(AutocompleteHandler(Param, bot)),
  )
}

pub fn number_builder(base: BaseDefinition) {
  NumberDefBuilder(base, [], option.None, option.None, option.None)
}

pub fn number_def(builder: NumberDefBuilder(_)) {
  let NumberDefBuilder(base, choices, min_value, max_value, autocomplete) =
    builder
  NumberDefinition(base, choices:, min_value:, max_value:, autocomplete:)
}

pub fn number_with_autocomplete(
  builder: NumberDefBuilder(bot),
  handler: AutocompleteHandler(Param, bot),
) {
  NumberDefBuilder(..builder, autocomplete: option.Some(handler))
  |> number_def()
}

pub fn attachment_def(base: BaseDefinition) {
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
