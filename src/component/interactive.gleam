//// TODO update definitions

import gleam/json.{type Json}
import gleam/option.{type Option}

/// Button interactive component
/// 
/// The `emoji` field represents the JSON string for the partial emoji object
pub type Button {
  CustomButton(CustomButton)
  LinkButton(label: String, url: String, emoji: Option(String))
  PremiumButton(sku: String)
}

pub fn button_json(btn: Button) -> Json {
  case btn {
    CustomButton(b) -> custom_button_json(b)
    LinkButton(label:, url:, emoji:) ->
      [
        #("type", json.int(2)),
        #("style", json.int(5)),
        #("label", json.string(label)),
        #("url", json.string(url)),
        #("emoji", json.nullable(emoji, json.string)),
      ]
      |> json.object
    PremiumButton(sku:) ->
      [
        #("type", json.int(2)),
        #("style", json.int(6)),
        #("sku_id", json.string(sku)),
      ]
      |> json.object
  }
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

fn custom_button_json(c_btn: CustomButton) -> Json {
  let style = case c_btn {
    PrimaryButton(..) -> #("style", json.int(1))
    SecondaryButton(..) -> #("style", json.int(2))
    SuccessButton(..) -> #("style", json.int(3))
    DangerButton(..) -> #("style", json.int(4))
  }

  [
    #("type", json.int(2)),
    style,
    #("label", json.string(c_btn.label)),
    #("emoji", json.nullable(c_btn.emoji, json.string)),
    #("custom_id", json.string(c_btn.custom_id)),
    #("disabled", json.bool(c_btn.disabled)),
  ]
  |> json.object
}

pub type StringSelect {
  StringSelect
}

pub fn string_select_json(string_select: StringSelect) -> Json {
  todo
}

/// Text input interactive component
/// 
/// To have a valid text input, ensure the following:
/// - required == True => min_len > 0
/// - required == False => min_len == 0
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

pub fn text_input_json(text_input: TextInput) -> Json {
  let style = case text_input {
    ShortTextInput(..) -> #("style", json.int(1))
    LongTextInput(..) -> #("style", json.int(2))
  }

  [
    #("type", json.int(4)),
    #("custom_id", json.string(text_input.custom_id)),
    style,
    #("min_length", json.int(text_input.min_len)),
    #("max_length", json.int(text_input.max_len)),
    #("required", json.bool(text_input.required)),
    #("value", json.string(text_input.value)),
    #("placeholder", json.string(text_input.placeholder)),
  ]
  |> json.object
}

pub type UserSelect {
  UserSelect
}

pub fn user_select_json(user_select: UserSelect) -> Json {
  todo
}

pub type RoleSelect {
  RoleSelect
}

pub fn role_select_json(role_select: RoleSelect) -> Json {
  todo
}

pub type MentionableSelect {
  MentionableSelect
}

pub fn mentionable_select_json(mentionable_select: MentionableSelect) -> Json {
  todo
}

pub type ChannelSelect {
  ChannelSelect
}

pub fn channel_select_json(channel_select: ChannelSelect) -> Json {
  todo
}

pub type FileUpload {
  FileUpload
}

pub fn file_upload_json(file_upload: FileUpload) -> Json {
  todo
}

pub type RadioGroup {
  RadioGroup
}

pub fn radio_group_json(radio_group: RadioGroup) -> Json {
  todo
}

pub type CheckboxGroup {
  CheckboxGroup
}

pub fn checkbox_group_json(checkbox_group: CheckboxGroup) -> Json {
  todo
}

pub type Checkbox {
  Checkbox
}

pub fn checkbox_json(checkbox: Checkbox) -> Json {
  todo
}
