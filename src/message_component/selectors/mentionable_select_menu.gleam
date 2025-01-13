import bot.{type Bot}
import gleam/dynamic.{type Dynamic}
import gleam/int
import interaction

const absolute_min_values = 0

const default_min_values = 1

const absolute_max_values = 25

const default_max_values = 25

/// TODO
pub type Response {
  JsonString(String)
}

/// TODO
pub type Error {
  NotImplemented
}

pub type Data {
  Data
}

pub type MentionableSelectMenu(ctx) {
  MentionableSelectMenu(
    custom_id: String,
    placeholder: String,
    default_values: List(Dynamic),
    min_values: Int,
    max_values: Int,
    disabled: Bool,
    handler: Handler(ctx),
  )
}

pub fn new(custom_id: String) {
  MentionableSelectMenu(
    custom_id:,
    placeholder: "",
    default_values: [],
    min_values: default_min_values,
    max_values: default_max_values,
    disabled: False,
    handler: default_handler,
  )
}

pub fn placeholder(select_menu: MentionableSelectMenu(ctx), placeholder: String) {
  MentionableSelectMenu(..select_menu, placeholder:)
}

pub fn default_values(
  select_menu: MentionableSelectMenu(ctx),
  default_values: List(Dynamic),
) {
  MentionableSelectMenu(..select_menu, default_values:)
}

pub fn min_values(select_menu: MentionableSelectMenu(ctx), min_values: Int) {
  let min_values =
    int.clamp(min_values, min: absolute_min_values, max: absolute_max_values)

  MentionableSelectMenu(..select_menu, min_values:)
}

pub fn max_values(select_menu: MentionableSelectMenu(ctx), max_values: Int) {
  let max_values =
    int.clamp(max_values, min: absolute_min_values, max: absolute_max_values)

  MentionableSelectMenu(..select_menu, max_values:)
}

pub fn disabled(select_menu: MentionableSelectMenu(ctx)) {
  MentionableSelectMenu(..select_menu, disabled: True)
}

pub fn handler(select_menu: MentionableSelectMenu(ctx), handler: Handler(ctx)) {
  MentionableSelectMenu(..select_menu, handler:)
}

pub type Handler(ctx) =
  fn(interaction.MessageComponent(Data), Bot, ctx, List(Dynamic)) ->
    Result(Response, Error)

pub fn default_handler(_, _, _, _) {
  Error(NotImplemented)
}

pub fn run(
  select_menu: MentionableSelectMenu(ctx),
  interaction: interaction.MessageComponent(Data),
  bot: Bot,
  ctx: ctx,
  values: List(Dynamic),
) {
  select_menu.handler(interaction, bot, ctx, values)
}
