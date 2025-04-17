import gleam/option.{type Option}

pub type ActionRow(component, bot, success, failure) =
  List(MessageComponent(component, bot, success, failure))

pub opaque type MessageComponent(component, bot, success, failure) {
  Button(ButtonComponent(component, bot, success, failure))
  StringSelect
  TextInput
  UserSelect
  RoleSelect
  MentionableSelect
  ChannelSelect
}

pub opaque type ButtonComponent(component, bot, success, failure) {
  PrimaryButton(
    Definition,
    disabled: Bool,
    handler: ButtonHandler(component, bot, success, failure),
  )
  SecondaryButton(
    Definition,
    disabled: Bool,
    handler: ButtonHandler(component, bot, success, failure),
  )
  SuccessButton(
    Definition,
    disabled: Bool,
    handler: ButtonHandler(component, bot, success, failure),
  )
  DangerButton(
    Definition,
    disabled: Bool,
    handler: ButtonHandler(component, bot, success, failure),
  )
  LinkButton(label: String, url: String, disabled: Bool)
  PremiumButton(sku_id: String, disabled: Bool)
}

pub type Definition {
  Definition(label: String, emoji: Option(Nil), custom_id: String)
}

pub fn styled_button(label label: String, id custom_id: String) {
  Definition(label:, emoji: option.None, custom_id:)
}

pub fn styled_button_emoji(def def: Definition, emoji emoji: Nil) {
  Definition(..def, emoji: option.Some(emoji))
}

pub fn primary_button(
  def def: Definition,
  disabled disabled: Bool,
  handler handler: ButtonHandler(_, _, _, _),
) {
  Button(PrimaryButton(def, disabled:, handler:))
}

pub fn secondary_button(
  def def: Definition,
  disabled disabled: Bool,
  handler handler: ButtonHandler(_, _, _, _),
) {
  Button(SecondaryButton(def, disabled:, handler:))
}

pub fn success_button(
  def def: Definition,
  disabled disabled: Bool,
  handler handler: ButtonHandler(_, _, _, _),
) {
  Button(SuccessButton(def, disabled:, handler:))
}

pub fn danger_button(
  def def: Definition,
  disabled disabled: Bool,
  handler handler: ButtonHandler(_, _, _, _),
) {
  Button(DangerButton(def, disabled:, handler:))
}

pub fn link_button(
  label label: String,
  url url: String,
  disabled disabled: Bool,
) {
  Button(LinkButton(label:, url:, disabled:))
}

pub fn premium_button(sku sku_id: String, disabled disabled: Bool) {
  Button(PremiumButton(sku_id:, disabled:))
}

pub type ButtonHandler(interaction, bot, success, failure) =
  fn(interaction, bot) -> Result(success, failure)

pub type StringSelectComponent

pub type TextInputComponent

pub type UserSelectComponent

pub type RoleSelectComponent

pub type MentionableSelectComponent

pub type ChannelSelectComponent
