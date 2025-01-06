import bot.{type Bot}
import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import interaction.{type Interaction}

/// TODO
pub type Response {
  JsonString(String)
}

/// TODO
pub type Error {
  NotImplemented
}

/// TODO
pub type Data {
  Data
}

pub opaque type ButtonComponent(ctx) {
  Primary(PrimaryButton(ctx))
  Secondary(SecondaryButton(ctx))
  Success(SuccessButton(ctx))
  Danger(DangerButton(ctx))
  Link(LinkButton)
  Premium(PremiumButton)
}

pub opaque type PrimaryButton(ctx) {
  PrimaryButton(
    custom_id: String,
    label: Option(String),
    emoji: Option(Dynamic),
    disabled: Bool,
    handler: Handler(ctx),
  )
}

pub fn new_primary(custom_id: String) {
  PrimaryButton(
    custom_id:,
    label: option.None,
    emoji: option.None,
    disabled: False,
    handler: default_handler,
  )
}

pub fn primary_label(button: PrimaryButton(ctx), label: String) {
  PrimaryButton(..button, label: option.Some(label))
}

pub fn primary_emoji(button: PrimaryButton(ctx), emoji: Dynamic) {
  PrimaryButton(..button, emoji: option.Some(emoji))
}

pub fn primary_disabled(button: PrimaryButton(ctx)) {
  PrimaryButton(..button, disabled: True)
}

pub fn primary_handler(button: PrimaryButton(ctx), handler: Handler(ctx)) {
  Primary(PrimaryButton(..button, handler:))
}

pub opaque type SecondaryButton(ctx) {
  SecondaryButton(
    custom_id: String,
    label: Option(String),
    emoji: Option(Dynamic),
    disabled: Bool,
    handler: Handler(ctx),
  )
}

pub fn new_secondary(custom_id: String) {
  PrimaryButton(
    custom_id:,
    label: option.None,
    emoji: option.None,
    disabled: False,
    handler: default_handler,
  )
}

pub fn secondary_label(button: SecondaryButton(ctx), label: String) {
  SecondaryButton(..button, label: option.Some(label))
}

pub fn secondary_emoji(button: SecondaryButton(ctx), emoji: Dynamic) {
  SecondaryButton(..button, emoji: option.Some(emoji))
}

pub fn secondary_disabled(button: SecondaryButton(ctx)) {
  SecondaryButton(..button, disabled: True)
}

pub fn secondary_handler(button: SecondaryButton(ctx), handler: Handler(ctx)) {
  Secondary(SecondaryButton(..button, handler:))
}

pub opaque type SuccessButton(ctx) {
  SuccessButton(
    custom_id: String,
    label: Option(String),
    emoji: Option(Dynamic),
    disabled: Bool,
    handler: Handler(ctx),
  )
}

pub fn new_success(custom_id: String) {
  SuccessButton(
    custom_id:,
    label: option.None,
    emoji: option.None,
    disabled: False,
    handler: default_handler,
  )
}

pub fn success_label(button: SuccessButton(ctx), label: String) {
  SuccessButton(..button, label: option.Some(label))
}

pub fn success_emoji(button: SuccessButton(ctx), emoji: Dynamic) {
  SuccessButton(..button, emoji: option.Some(emoji))
}

pub fn success_disabled(button: SuccessButton(ctx)) {
  SuccessButton(..button, disabled: True)
}

pub fn success_handler(button: SuccessButton(ctx), handler: Handler(ctx)) {
  Success(SuccessButton(..button, handler:))
}

pub opaque type DangerButton(ctx) {
  DangerButton(
    custom_id: String,
    label: Option(String),
    emoji: Option(Dynamic),
    disabled: Bool,
    handler: Handler(ctx),
  )
}

pub fn new_danger(custom_id: String) {
  DangerButton(
    custom_id:,
    label: option.None,
    emoji: option.None,
    disabled: False,
    handler: default_handler,
  )
}

pub fn danger_label(button: DangerButton(ctx), label: String) {
  DangerButton(..button, label: option.Some(label))
}

pub fn danger_emoji(button: DangerButton(ctx), emoji: Dynamic) {
  DangerButton(..button, emoji: option.Some(emoji))
}

pub fn danger_disabled(button: DangerButton(ctx)) {
  DangerButton(..button, disabled: True)
}

pub fn danger_handler(button: DangerButton(ctx), handler: Handler(ctx)) {
  Danger(DangerButton(..button, handler:))
}

pub opaque type LinkButton {
  LinkButton(
    url: String,
    label: Option(String),
    emoji: Option(Dynamic),
    disabled: Bool,
  )
}

pub fn new_link(url: String) {
  LinkButton(url:, label: option.None, emoji: option.None, disabled: False)
}

pub fn link_label(button: LinkButton, label: String) {
  LinkButton(..button, label: option.Some(label))
}

pub fn link_emoji(button: LinkButton, emoji: Dynamic) {
  LinkButton(..button, emoji: option.Some(emoji))
}

pub fn link_disabled(button: LinkButton) {
  LinkButton(..button, disabled: True)
}

pub fn link_component(button: LinkButton) {
  Link(button)
}

pub opaque type PremiumButton {
  PremiumButton(sku_id: String, disabled: Bool)
}

pub fn new_premium(sku_id: String) {
  PremiumButton(sku_id:, disabled: False)
}

pub fn premium_disabled(button: PremiumButton) {
  PremiumButton(..button, disabled: True)
}

pub fn premium_component(button: PremiumButton) {
  Premium(button)
}

pub type Handler(ctx) =
  fn(Interaction(Data), Bot, ctx) -> Result(Response, Error)

pub fn default_handler(_, _, _) {
  Error(NotImplemented)
}
