import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import message_component/button/button
import message_component/button/interactive_button.{type InteractiveButton}
import message_component/interaction.{type Interaction}
import message_component/response.{type Response}

pub type Interactive(state) {
  InteractionButton(InteractiveButton(state))
  SelectComponent(SelectComponent(state))
}

pub type Button(state) =
  button.Button(state)

pub type SelectComponent(state) {
  StringSelectVariant(StringSelect(state))
  UserSelectVariant(UserSelect(state))
  RoleSelectVariant(RoleSelect(state))
  MentionableSelectVariant(MentionableSelect(state))
  ChannelSelectVariant(ChannelSelect(state))
}

pub type StringSelect(state) {
  StringSelect(
    custom_id: String,
    options: List(SelectOption),
    placeholder: String,
    min_values: Int,
    max_values: Int,
    required: Bool,
    disabled: Bool,
    handler: SelectHandler(state, List(String)),
  )
}

pub type SelectOption {
  SelectOption(
    label: String,
    value: String,
    description: String,
    emoji: Option(#(String, String, Bool)),
    default: Bool,
  )
}

pub type UserSelect(state) {
  UserSelect(
    custom_id: String,
    placeholder: String,
    default_values: List(DefaultValue),
    min_values: Int,
    max_values: Int,
    required: Bool,
    disabled: Bool,
    handler: SelectHandler(state, #(List(Dynamic), List(Dynamic))),
  )
}

pub type RoleSelect(state) {
  RoleSelect(
    custom_id: String,
    placeholder: String,
    default_values: List(DefaultValue),
    min_values: Int,
    max_values: Int,
    required: Bool,
    disabled: Bool,
    handler: SelectHandler(state, List(Dynamic)),
  )
}

pub type MentionableSelect(state) {
  MentionableSelect(
    custom_id: String,
    placeholder: String,
    default_values: List(DefaultValue),
    min_values: Int,
    max_values: Int,
    required: Bool,
    disabled: Bool,
    handler: SelectHandler(
      state,
      #(List(Dynamic), List(Dynamic), List(Dynamic)),
    ),
  )
}

pub type ChannelSelect(state) {
  ChannelSelect(
    custom_id: String,
    placeholder: String,
    // TODO: define channel types
    channel_types: List(Nil),
    default_values: List(DefaultValue),
    min_values: Int,
    max_values: Int,
    required: Bool,
    disabled: Bool,
    handler: SelectHandler(state, List(Dynamic)),
  )
}

pub type DefaultValue {
  DefaultValue(snowflake: String)
}

pub type SelectHandler(state, values) =
  fn(Interaction, state, values) -> Response(state)
