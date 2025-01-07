import bot.{type Bot}
import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}
import interaction

/// TODO
pub type Response {
  JsonString(String)
}

/// TODO
pub type Error {
  NotImplemented
}

pub type Data {
  Data(custom_id: String)
}

pub opaque type StyledButton(ctx) {
  StyledButton(
    custom_id: String,
    style: Style,
    label: Option(String),
    emoji: Option(Dynamic),
    disabled: Bool,
    handler: Handler(ctx),
  )
}

pub type Style {
  Primary
  Secondary
  Success
  Danger
}

pub fn new_with_label(
  custom_id custom_id: String,
  style style: Style,
  label label: String,
) {
  StyledButton(
    custom_id:,
    style:,
    label: option.Some(label),
    emoji: option.None,
    disabled: False,
    handler: default_handler,
  )
}

pub fn new_with_emoji(
  custom_id custom_id: String,
  style style: Style,
  emoji emoji: Dynamic,
) {
  StyledButton(
    custom_id:,
    style:,
    label: option.None,
    emoji: option.Some(emoji),
    disabled: False,
    handler: default_handler,
  )
}

pub fn label(button: StyledButton(ctx), label: String) {
  StyledButton(..button, label: option.Some(label))
}

pub fn emoji(button: StyledButton(ctx), emoji: Dynamic) {
  StyledButton(..button, emoji: option.Some(emoji))
}

pub fn disabled(button: StyledButton(ctx)) {
  StyledButton(..button, disabled: True)
}

pub fn handler(button: StyledButton(ctx), handler: Handler(ctx)) {
  StyledButton(..button, handler:)
}

pub type Handler(ctx) =
  fn(interaction.MessageComponent(Data), Bot, ctx) -> Result(Response, Error)

pub fn default_handler(_, _, _) {
  Error(NotImplemented)
}

pub fn run(
  button: StyledButton(ctx),
  interaction: interaction.MessageComponent(Data),
  bot: Bot,
  ctx: ctx,
) {
  button.handler(interaction, bot, ctx)
}
