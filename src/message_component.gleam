import discord/entities/interaction
import gleam/option.{type Option}
import modal
import response

pub type ActionRow(bot) =
  List(MessageComponent(bot))

pub opaque type MessageComponent(bot) {
  Button(ButtonComponent(bot))
  StringSelect
  TextInput
  UserSelect
  RoleSelect
  MentionableSelect
  ChannelSelect
}

pub opaque type ButtonComponent(bot) {
  PrimaryButton(Definition, disabled: Bool, handler: ButtonHandler(bot))
  SecondaryButton(Definition, disabled: Bool, handler: ButtonHandler(bot))
  SuccessButton(Definition, disabled: Bool, handler: ButtonHandler(bot))
  DangerButton(Definition, disabled: Bool, handler: ButtonHandler(bot))
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
  handler handler: ButtonHandler(_),
) {
  Button(PrimaryButton(def, disabled:, handler:))
}

pub fn secondary_button(
  def def: Definition,
  disabled disabled: Bool,
  handler handler: ButtonHandler(_),
) {
  Button(SecondaryButton(def, disabled:, handler:))
}

pub fn success_button(
  def def: Definition,
  disabled disabled: Bool,
  handler handler: ButtonHandler(_),
) {
  Button(SuccessButton(def, disabled:, handler:))
}

pub fn danger_button(
  def def: Definition,
  disabled disabled: Bool,
  handler handler: ButtonHandler(_),
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

pub type ButtonHandler(bot) =
  fn(interaction.MessageComponent, bot) -> ComponentResponse

pub opaque type ComponentResponse {
  UpdateMessage(response.UpdateMessage)
  DeferredUpdateMessage(response.DeferredUpdateMessage)
  Modal(response.Modal)
}

pub fn update_message(message) {
  UpdateMessage(response.UpdateMessage(message))
}

pub fn show_modal(modal: modal.Modal) {
  Modal(response.Modal(modal))
}

/// TODO
pub fn deferred_message_update(
  _i: interaction.MessageComponent,
  _bot,
  deferred,
) -> ComponentResponse {
  DeferredUpdateMessage(response.DeferredUpdateMessage(deferred))
}

pub type StringSelectComponent

pub type TextInputComponent

pub type UserSelectComponent

pub type RoleSelectComponent

pub type MentionableSelectComponent

pub type ChannelSelectComponent
