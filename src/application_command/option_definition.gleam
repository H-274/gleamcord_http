//// Based on:
//// - https://docs.discord.com/developers/interactions/application-commands#application-command-object-application-command-option-structure

import application_command/interaction.{type Interaction}
import application_command/option_value

/// According to https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-option-structure
const min_string_length = 0

/// According to https://discord.com/developers/docs/interactions/application-commands#application-command-object-application-command-option-structure
const max_string_length = 6000

/// According to https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MIN_SAFE_INTEGER
const min_integer_value = -9_007_199_254_740_991

/// According to https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER
const max_integer_value = 9_007_199_254_740_991

/// According to https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_VALUE
const min_number_value = -1.7976931348623157e308

/// According to https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_VALUE
const max_number_value = 1.7976931348623157e308

/// According to https://docs.discord.com/developers/interactions/application-commands#application-command-object-application-command-option-structure
pub const max_choice_count = 25

pub type Definition(state) {
  StringDefinition(
    name: String,
    description: String,
    required: Bool,
    details: List(LengthDetail),
  )
  StringChoicesDefinition(
    name: String,
    description: String,
    required: Bool,
    choices: Choices(String),
  )
  StringAutocompleteDefinition(
    name: String,
    description: String,
    required: Bool,
    details: List(LengthDetail),
    autocomplete: Autocomplete(state, String),
  )
  IntegerDefinition(
    name: String,
    description: String,
    required: Bool,
    details: List(ValueDetail(Int)),
  )
  IntegerChoicesDefinition(
    name: String,
    description: String,
    required: Bool,
    choices: Choices(Int),
  )
  IntegerAutocompleteDefinition(
    name: String,
    description: String,
    required: Bool,
    details: List(ValueDetail(Int)),
    autocomplete: Autocomplete(state, Int),
  )
  BooleanDefinition(name: String, description: String, required: Bool)
  UserDefinition(name: String, description: String, required: Bool)
  ChannelDefinition(
    name: String,
    description: String,
    required: Bool,
    types: List(Nil),
  )
  RoleDefinition(name: String, description: String, required: Bool)
  MentionableDefinition(name: String, description: String, required: Bool)
  NumberDefinition(
    name: String,
    description: String,
    required: Bool,
    details: List(ValueDetail(Float)),
  )
  NumberChoicesDefinition(
    name: String,
    description: String,
    required: Bool,
    choices: Choices(Float),
  )
  NumberAutocompleteDefinition(
    name: String,
    description: String,
    required: Bool,
    details: List(ValueDetail(Float)),
    autocomplete: Autocomplete(state, Float),
  )
  AttachmentDefinition(name: String, description: String, required: Bool)
}

pub type Choices(val) =
  List(#(String, val))

pub type Autocomplete(state, val) =
  fn(Interaction, state, val, option_value.Values) -> Choices(val)

pub opaque type LengthDetail {
  MinLength(Int)
  MaxLength(Int)
}

pub fn min_length(length: Int) {
  assert length > min_string_length
  assert length < max_string_length
  MinLength(length)
}

pub fn max_length(length: Int) {
  assert length > min_string_length
  assert length < max_string_length
  MaxLength(length)
}

pub opaque type ValueDetail(val) {
  MinValue(val)
  MaxValue(val)
}

pub fn min_int(value: Int) {
  assert value > min_integer_value
  assert value < max_integer_value
  MinValue(value)
}

pub fn max_int(value: Int) {
  assert value > min_integer_value
  assert value < max_integer_value
  MaxValue(value)
}

pub fn min_num(value: Float) {
  assert value >. min_number_value
  assert value <. max_number_value
  MinValue(value)
}

pub fn max_num(value: Float) {
  assert value >. min_number_value
  assert value <. max_number_value
  MaxValue(value)
}
