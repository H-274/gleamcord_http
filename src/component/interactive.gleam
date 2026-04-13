//// TODO update definitions

import gleam/option.{type Option}

pub type Button {
  CustomButton(CustomButton)
  LinkButton(label: String, url: String, emoji: Option(String))
  PremiumButton(sku: String)
}

pub type CustomButton {
  PrimaryButton(custom_id: String, label: String, emoji: Option(String))
  SecondaryButton(custom_id: String, label: String, emoji: Option(String))
  SuccessButton(custom_id: String, label: String, emoji: Option(String))
  DangerButton(custom_id: String, label: String, emoji: Option(String))
}

pub type StringSelect {
  StringSelect
}

pub type TextInput {
  TextInput
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
