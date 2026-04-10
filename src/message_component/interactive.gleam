import gleam/option.{type Option}
import message_component/interaction.{type Interaction}
import message_component/response.{type Response}

pub type Interactive(state) {
  InteractiveButton(Button(state))
  InteractiveSelectComponent(SelectComponent(state))
}

pub fn get_cusom_id(interactive: Interactive(_)) -> String {
  case interactive {
    InteractiveButton(button) ->
      case button {
        PrimaryButton(custom_id:, ..)
        | SecondaryButton(custom_id:, ..)
        | SuccessButton(custom_id:, ..)
        | DangerButton(custom_id:, ..) -> todo
        _ -> panic as "does not have a custom_id"
      }
    InteractiveSelectComponent(select) -> todo
  }
}

pub type Button(state) {
  PrimaryButton(
    custom_id: String,
    label: String,
    emoji: Option(#(String, String, Bool)),
    disabled: Bool,
    handler: ButtonHandler(state),
  )
  SecondaryButton(
    custom_id: String,
    label: String,
    emoji: Option(#(String, String, Bool)),
    disabled: Bool,
    handler: ButtonHandler(state),
  )
  SuccessButton(
    custom_id: String,
    label: String,
    emoji: Option(#(String, String, Bool)),
    disabled: Bool,
    handler: ButtonHandler(state),
  )
  DangerButton(
    custom_id: String,
    label: String,
    emoji: Option(#(String, String, Bool)),
    disabled: Bool,
    handler: ButtonHandler(state),
  )
  LinkButton(url: String, label: String, disabled: Bool)
  PremiumButton(sku_id: String)
}

pub type ButtonHandler(state) =
  fn(Interaction, state) -> Response(state)

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
    handler: SelectHandler(state, String),
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
    handler: SelectHandler(state, String),
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
    handler: SelectHandler(state, String),
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
    handler: SelectHandler(state, String),
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
    handler: SelectHandler(state, String),
  )
}

pub type DefaultValue {
  DefaultValue(snowflake: String)
}

pub type SelectHandler(state, value) =
  fn(Interaction, state, List(value)) -> Response(state)
