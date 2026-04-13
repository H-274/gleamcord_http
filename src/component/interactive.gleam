//// TODO update definitions

import gleam/option.{type Option}

/// Button interactive component
/// 
/// The `emoji` field represents the JSON string for the partial emoji object
pub type Button {
  CustomButton(CustomButton)
  LinkButton(label: String, url: String, emoji: Option(String))
  PremiumButton(sku: String)
}

/// Custom button
/// 
/// The `emoji` field represents the JSON string for the partial emoji object
pub type CustomButton {
  PrimaryButton(
    custom_id: String,
    label: String,
    disabled: Bool,
    emoji: Option(String),
  )
  SecondaryButton(
    custom_id: String,
    label: String,
    disabled: Bool,
    emoji: Option(String),
  )
  SuccessButton(
    custom_id: String,
    label: String,
    disabled: Bool,
    emoji: Option(String),
  )
  DangerButton(
    custom_id: String,
    label: String,
    disabled: Bool,
    emoji: Option(String),
  )
}

pub type StringSelect {
  StringSelect
}

/// Text input interactive component
/// 
/// To have a valid text input, ensure the following:
/// - required == True => min_len > 0
/// - 0 <= min_len < 4000
/// - 0 < max_len <= 4000
/// - min_len < max_len
pub type TextInput {
  ShortTextInput(
    custom_id: String,
    required: Bool,
    value: String,
    placeholder: String,
    min_len: Int,
    max_len: Int,
  )
  LongTextInput(
    custom_id: String,
    required: Bool,
    value: String,
    placeholder: String,
    min_len: Int,
    max_len: Int,
  )
}

pub type UserSelect {
  UserSelect
}

pub type RoleSelect {
  RoleSelect
}

pub type MentionableSelect {
  MentionableSelect
}

pub type ChannelSelect {
  ChannelSelect
}

pub type FileUpload {
  FileUpload
}

pub type RadioGroup {
  RadioGroup
}

pub type CheckboxGroup {
  CheckboxGroup
}

pub type Checkbox {
  Checkbox
}
