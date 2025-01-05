import command/handler
import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/list
import gleam/option.{type Option}
import gleam/result
import locale.{type Locale}

pub type Error {
  UnexpectedType
  NotFound
}

pub type Definition(ctx) {
  StringDefinition(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
    choices: List(String),
    min_length: Int,
    max_length: Int,
    autocomplete: Option(handler.ChatInputHandler(ctx, CommandOption)),
  )
  IntegerDefinition(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
    choices: List(Int),
    min_value: Option(Int),
    max_value: Option(Int),
    autocomplete: Option(handler.ChatInputHandler(ctx, CommandOption)),
  )
  BooleanDefinition(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
  )
  UserDefinition(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
  )
  ChannelDefinition(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
    channel_types: List(Int),
  )
  RoleDefinition(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
  )
  MentionableDefinition(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
  )
  NumberDefinition(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
    choices: List(Float),
    min_value: Option(Float),
    max_value: Option(Float),
    autocomplete: Option(handler.ChatInputHandler(ctx, CommandOption)),
  )
  AttachmentDefinition(
    name: String,
    name_locales: List(#(Locale, String)),
    description: String,
    description_locales: List(#(Locale, String)),
    required: Bool,
  )
}

pub fn new_string_def(
  name name: String,
  desc description: String,
  choices choices: List(String),
  autocomplete autocomplete: Option(
    handler.ChatInputHandler(ctx, CommandOption),
  ),
) {
  StringDefinition(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
    choices:,
    min_length: 0,
    max_length: 0,
    autocomplete:,
  )
}

pub fn string_min_len(def: Definition(ctx), len: Int) {
  case def {
    StringDefinition(..) -> StringDefinition(..def, min_length: len)
    _ -> def
  }
}

pub fn string_max_len(def: Definition(ctx), len: Int) {
  case def {
    StringDefinition(..) -> StringDefinition(..def, max_length: len)
    _ -> def
  }
}

pub fn new_integer_def(
  name name: String,
  desc description: String,
  choices choices: List(Int),
  autocomplete autocomplete: Option(
    handler.ChatInputHandler(ctx, CommandOption),
  ),
) {
  IntegerDefinition(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
    choices:,
    min_value: option.None,
    max_value: option.None,
    autocomplete:,
  )
}

pub fn integer_min_val(def: Definition(ctx), val: Int) {
  case def {
    IntegerDefinition(..) ->
      IntegerDefinition(..def, min_value: option.Some(val))
    _ -> def
  }
}

pub fn integer_max_val(def: Definition(ctx), val: Int) {
  case def {
    IntegerDefinition(..) ->
      IntegerDefinition(..def, max_value: option.Some(val))
    _ -> def
  }
}

pub fn new_boolean_def(name name: String, desc description: String) {
  BooleanDefinition(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
  )
}

pub fn new_user_def(name name: String, desc description: String) {
  UserDefinition(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
  )
}

pub fn new_channel_def(
  name name: String,
  desc description: String,
  types channel_types: List(Int),
) {
  ChannelDefinition(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
    channel_types:,
  )
}

pub fn new_role_def(name name: String, desc description: String) {
  RoleDefinition(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
  )
}

pub fn new_mentionable_def(name name: String, desc description: String) {
  MentionableDefinition(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
  )
}

pub fn new_number_def(
  name name: String,
  desc description: String,
  choices choices: List(Float),
  autocomplete autocomplete: Option(
    handler.ChatInputHandler(ctx, CommandOption),
  ),
) {
  NumberDefinition(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
    choices:,
    min_value: option.None,
    max_value: option.None,
    autocomplete:,
  )
}

pub fn number_min_val(def: Definition(ctx), val: Float) {
  case def {
    NumberDefinition(..) -> NumberDefinition(..def, min_value: option.Some(val))
    _ -> def
  }
}

pub fn number_max_val(def: Definition(ctx), val: Float) {
  case def {
    NumberDefinition(..) -> NumberDefinition(..def, max_value: option.Some(val))
    _ -> def
  }
}

pub fn new_attachment_def(name name: String, desc description: String) {
  AttachmentDefinition(
    name:,
    name_locales: [],
    description:,
    description_locales: [],
    required: False,
  )
}

pub fn locales(def: Definition(ctx), locales: List(#(Locale, String, String))) {
  let name_locales = list.map(locales, fn(e) { #(e.0, e.1) })
  let description_locales = list.map(locales, fn(e) { #(e.0, e.2) })

  case def {
    AttachmentDefinition(..) ->
      AttachmentDefinition(..def, name_locales:, description_locales:)
    BooleanDefinition(..) ->
      BooleanDefinition(..def, name_locales:, description_locales:)
    ChannelDefinition(..) ->
      ChannelDefinition(..def, name_locales:, description_locales:)
    IntegerDefinition(..) ->
      IntegerDefinition(..def, name_locales:, description_locales:)
    MentionableDefinition(..) ->
      MentionableDefinition(..def, name_locales:, description_locales:)
    NumberDefinition(..) ->
      NumberDefinition(..def, name_locales:, description_locales:)
    RoleDefinition(..) ->
      RoleDefinition(..def, name_locales:, description_locales:)
    StringDefinition(..) ->
      StringDefinition(..def, name_locales:, description_locales:)
    UserDefinition(..) ->
      UserDefinition(..def, name_locales:, description_locales:)
  }
}

pub fn required(def: Definition(ctx)) {
  case def {
    AttachmentDefinition(..) -> AttachmentDefinition(..def, required: True)
    BooleanDefinition(..) -> BooleanDefinition(..def, required: True)
    ChannelDefinition(..) -> ChannelDefinition(..def, required: True)
    IntegerDefinition(..) -> IntegerDefinition(..def, required: True)
    MentionableDefinition(..) -> MentionableDefinition(..def, required: True)
    NumberDefinition(..) -> NumberDefinition(..def, required: True)
    RoleDefinition(..) -> RoleDefinition(..def, required: True)
    StringDefinition(..) -> StringDefinition(..def, required: True)
    UserDefinition(..) -> UserDefinition(..def, required: True)
  }
}

/// TODO replace dynamics
pub opaque type CommandOption {
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
  from options: Dict(String, CommandOption),
) -> Result(CommandOption, Error) {
  list.find(dict.values(options), fn(o) {
    case o {
      String(focused: focused, ..)
      | Integer(focused: focused, ..)
      | Number(focused: focused, ..) -> focused
      _ -> False
    }
  })
  |> result.replace_error(NotFound)
}

/// #(String, Bool) == #(value, focused)
pub fn extract_string(
  from options: Dict(String, CommandOption),
  name name: String,
) -> Result(String, Error) {
  case dict.get(options, name) {
    Ok(String(value: value, ..)) -> Ok(value)
    Ok(_) -> Error(UnexpectedType)
    Error(Nil) -> Error(NotFound)
  }
}

/// #(Int, Bool) == #(value, focused)
pub fn extract_integer(
  from options: Dict(String, CommandOption),
  name name: String,
) -> Result(Int, Error) {
  case dict.get(options, name) {
    Ok(Integer(value: value, ..)) -> Ok(value)
    Ok(_) -> Error(UnexpectedType)
    Error(Nil) -> Error(NotFound)
  }
}

pub fn extract_boolean(
  from options: Dict(String, CommandOption),
  name name: String,
) -> Result(Bool, Error) {
  case dict.get(options, name) {
    Ok(Boolean(value: value, ..)) -> Ok(value)
    Ok(_) -> Error(UnexpectedType)
    Error(Nil) -> Error(NotFound)
  }
}

pub fn extract_user(
  from options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  case dict.get(options, name) {
    Ok(User(value: value, ..)) -> Ok(value)
    Ok(_) -> Error(UnexpectedType)
    Error(Nil) -> Error(NotFound)
  }
}

pub fn extract_channel(
  from options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  case dict.get(options, name) {
    Ok(Channel(value: value, ..)) -> Ok(value)
    Ok(_) -> Error(UnexpectedType)
    Error(Nil) -> Error(NotFound)
  }
}

pub fn extract_role(
  from options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  case dict.get(options, name) {
    Ok(Role(value: value, ..)) -> Ok(value)
    Ok(_) -> Error(UnexpectedType)
    Error(Nil) -> Error(NotFound)
  }
}

pub fn extract_mentionable(
  from options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  case dict.get(options, name) {
    Ok(Mentionable(value: value, ..)) -> Ok(value)
    Ok(_) -> Error(UnexpectedType)
    Error(Nil) -> Error(NotFound)
  }
}

/// #(Float, Bool) == #(value, focused)
pub fn extract_number(
  from options: Dict(String, CommandOption),
  name name: String,
) -> Result(Float, Error) {
  case dict.get(options, name) {
    Ok(Number(value: value, ..)) -> Ok(value)
    Ok(_) -> Error(UnexpectedType)
    Error(Nil) -> Error(NotFound)
  }
}

pub fn extract_attachment(
  from options: Dict(String, CommandOption),
  name name: String,
) -> Result(Dynamic, Error) {
  case dict.get(options, name) {
    Ok(Attachment(value: value, ..)) -> Ok(value)
    Ok(_) -> Error(UnexpectedType)
    Error(Nil) -> Error(NotFound)
  }
}
