import gleam/option.{type Option}

pub type ActionRow {
  ActionRow(id: Int, components: List(Component))
}

pub fn action_row(components: List(Component)) {
  ActionRow(id: 0, components:)
}

pub type Component {
  ActionRowComponent(ActionRow)
  PrimaryButtonComponent(PrimaryButton)
  SecondaryButtonComponent(SecondaryButton)
  SuccessButtonComponent(SuccessButton)
  DangerButtonComponent(DangerButton)
  LinkButtonComponent(LinkButton)
  PremiumButtonComponent(PremiumButton)
  StringSelectComponent(StringSelect)
  ShortTextInputComponent(ShortTextInput)
  ParagraphTextInputParam(ParagraphTextInput)
  UserSelectComponent(UserSelect)
  RoleSelectComponent(RoleSelect)
  MentionableSelectComponent(MentionableSelect)
  ChannelSelectComponent(ChannelSelect)
}

pub type PrimaryButton {
  PrimaryButton(
    id: Int,
    label: String,
    // TODO
    emoji: Option(Nil),
    custom_id: String,
    disabled: Bool,
  )
}

pub fn primary_button(label: String, custom_id: String) {
  PrimaryButton(id: 0, label:, emoji: option.None, custom_id:, disabled: False)
}

pub type SecondaryButton {
  SecondaryButton(
    id: Int,
    label: String,
    // TODO
    emoji: Option(Nil),
    custom_id: String,
    disabled: Bool,
  )
}

pub fn secondary_button(label: String, custom_id: String) {
  SecondaryButton(
    id: 0,
    label:,
    emoji: option.None,
    custom_id:,
    disabled: False,
  )
}

pub type SuccessButton {
  SuccessButton(
    id: Int,
    label: String,
    // TODO
    emoji: Option(Nil),
    custom_id: String,
    disabled: Bool,
  )
}

pub fn success_button(label: String, custom_id: String) {
  SuccessButton(id: 0, label:, emoji: option.None, custom_id:, disabled: False)
}

pub type DangerButton {
  DangerButton(
    id: Int,
    label: String,
    // TODO
    emoji: Option(Nil),
    custom_id: String,
    disabled: Bool,
  )
}

pub fn danger_button(label: String, custom_id: String) {
  DangerButton(id: 0, label:, emoji: option.None, custom_id:, disabled: False)
}

pub type LinkButton {
  LinkButton(url: String)
}

pub type PremiumButton {
  PremiumButton(sku_id: Int, label: String)
}

pub type StringSelect {
  StringSelect(
    id: Int,
    custom_id: String,
    // TODO
    options: List(Nil),
    placeholder: String,
    min_values: Int,
    max_values: Int,
    disabled: Bool,
  )
}

pub fn string_select(custom_id: String, options: List(Nil)) {
  StringSelect(
    id: 0,
    custom_id:,
    options:,
    placeholder: "",
    min_values: 1,
    max_values: 1,
    disabled: False,
  )
}

pub type ShortTextInput {
  ShortTextInput(
    id: Int,
    custom_id: String,
    label: String,
    min_length: Int,
    max_len: Int,
    required: Bool,
    value: String,
    placeholder: String,
  )
}

pub fn short_text_input(custom_id: String, label: String) {
  ShortTextInput(
    id: 0,
    custom_id:,
    label:,
    min_length: 1,
    max_len: 4000,
    required: True,
    value: "",
    placeholder: "",
  )
}

pub type ParagraphTextInput {
  ParagraphTextInput(
    id: Int,
    custom_id: String,
    label: String,
    min_length: Int,
    max_len: Int,
    required: Bool,
    value: String,
    placeholder: String,
  )
}

pub fn paragraph_text_input(custom_id: String, label: String) {
  ParagraphTextInput(
    id: 0,
    custom_id:,
    label:,
    min_length: 1,
    max_len: 4000,
    required: True,
    value: "",
    placeholder: "",
  )
}

pub type UserSelect {
  UserSelect(
    id: Int,
    custom_id: String,
    placeholder: String,
    // TODO
    default_values: List(Nil),
    min_values: Int,
    max_values: Int,
    disabled: Bool,
  )
}

pub fn user_select(custom_id: String) {
  UserSelect(
    id: 0,
    custom_id:,
    placeholder: "",
    default_values: [],
    min_values: 1,
    max_values: 1,
    disabled: False,
  )
}

pub type RoleSelect {
  RoleSelect(
    id: Int,
    custom_id: String,
    placeholder: String,
    // TODO
    default_values: List(Nil),
    min_values: Int,
    max_values: Int,
    disabled: Bool,
  )
}

pub fn role_select(custom_id: String) {
  RoleSelect(
    id: 0,
    custom_id:,
    placeholder: "",
    default_values: [],
    min_values: 1,
    max_values: 1,
    disabled: False,
  )
}

pub type MentionableSelect {
  MentionableSelect(
    id: Int,
    custom_id: String,
    placeholder: String,
    // TODO
    default_values: List(Nil),
    min_values: Int,
    max_values: Int,
    disabled: Bool,
  )
}

pub fn mentionable_select(custom_id: String) {
  MentionableSelect(
    id: 0,
    custom_id:,
    placeholder: "",
    default_values: [],
    min_values: 1,
    max_values: 1,
    disabled: False,
  )
}

pub type ChannelSelect {
  ChannelSelect(
    id: Int,
    custom_id: String,
    // TODO
    channel_types: List(Nil),
    placeholder: String,
    // TODO
    default_values: List(Nil),
    min_values: Int,
    max_values: Int,
    disabled: Bool,
  )
}

pub fn channel_select(custom_id: String) {
  ChannelSelect(
    id: 0,
    custom_id:,
    channel_types: [],
    placeholder: "",
    default_values: [],
    min_values: 1,
    max_values: 1,
    disabled: False,
  )
}
