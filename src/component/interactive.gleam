//// TODO: add handlers for components that require them

import gleam/option.{type Option}

pub type Button {
  PrimaryButton(
    custom_id: String,
    label: String,
    emoji: Option(#(String, String, Bool)),
    disabled: Bool,
  )
  SecondaryButton(
    custom_id: String,
    label: String,
    emoji: Option(#(String, String, Bool)),
    disabled: Bool,
  )
  SuccessButton(
    custom_id: String,
    label: String,
    emoji: Option(#(String, String, Bool)),
    disabled: Bool,
  )
  DangerButton(
    custom_id: String,
    label: String,
    emoji: Option(#(String, String, Bool)),
    disabled: Bool,
  )
  LinkButton(url: String, label: String, disabled: Bool)
  PremiumButton(sku_id: String)
}

pub type SelectComponent {
  StringSelectVariant(StringSelect)
  UserSelectVariant(UserSelect)
  RoleSelectVariant(RoleSelect)
  MentionableSelectVariant(MentionableSelect)
  ChannelSelectVariant(ChannelSelect)
}

pub type StringSelect {
  StringSelect(
    custom_id: String,
    options: List(SelectOption),
    placeholder: String,
    min_values: Option(Int),
    max_values: Option(Int),
    required: Bool,
    disabled: Bool,
  )
}

pub type SelectOption {
  SelectOption(
    label: String,
    value: String,
    description: Option(String),
    emoji: Option(#(String, String, Bool)),
    default: Bool,
  )
}

pub type TextInput {
  ShortTextInput(
    custom_id: String,
    min_length: Option(Int),
    max_length: Option(Int),
    required: Bool,
    value: String,
    placeholder: String,
  )
  ParaTextInput(
    custom_id: String,
    min_length: Option(Int),
    max_length: Option(Int),
    required: Bool,
    value: String,
    placeholder: String,
  )
}

pub type UserSelect {
  UserSelect(
    custom_id: String,
    placeholder: String,
    default_values: List(DefaultValue),
    min_values: Option(Int),
    max_values: Option(Int),
    required: Bool,
    disabled: Bool,
  )
}

pub type RoleSelect {
  RoleSelect(
    custom_id: String,
    placeholder: String,
    default_values: List(DefaultValue),
    min_values: Option(Int),
    max_values: Option(Int),
    required: Bool,
    disabled: Bool,
  )
}

pub type MentionableSelect {
  MentionableSelect(
    custom_id: String,
    placeholder: String,
    default_values: List(DefaultValue),
    min_values: Option(Int),
    max_values: Option(Int),
    required: Bool,
    disabled: Bool,
  )
}

pub type ChannelSelect {
  ChannelSelect(
    custom_id: String,
    placeholder: String,
    // TODO: define channel types
    channel_types: List(Nil),
    default_values: List(DefaultValue),
    min_values: Option(Int),
    max_values: Option(Int),
    required: Bool,
    disabled: Bool,
  )
}

pub type DefaultValue {
  DefaultValue(snowflake: String)
}

pub type FileUpload {
  FileUpload(
    custom_id: String,
    min_values: Option(Int),
    max_values: Option(Int),
    required: Bool,
  )
}

pub type RadioGroup {
  RadioGroup(custom_id: String, options: List(RadioGroupOption), required: Bool)
}

pub type RadioGroupOption {
  RadioGroupOption(
    value: String,
    label: String,
    description: String,
    default: Bool,
  )
}

pub type CheckboxGroup {
  CheckboxGroup(
    custom_id: String,
    options: List(CheckboxGroupOption),
    min_values: Option(Int),
    max_values: Option(Int),
    required: Bool,
  )
}

pub type CheckboxGroupOption {
  CheckboxGroupOption(
    value: String,
    label: String,
    description: String,
    default: Bool,
  )
}

pub type Checkbox {
  Checkbox(custom_id: String, default: Bool)
}
