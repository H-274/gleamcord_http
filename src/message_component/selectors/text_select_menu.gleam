import credentials.{type Credentials}
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

/// TODO text select menu options
pub type Option

pub type TextSelectMenu(ctx) {
  TextSelectMenu(
    custom_id: String,
    placeholder: String,
    options: List(Option),
    default_values: List(Dynamic),
    min_values: Int,
    max_values: Int,
    disabled: Bool,
    handler: Handler(ctx),
  )
}

pub fn new(custom_id: String) {
  TextSelectMenu(
    custom_id:,
    placeholder: "",
    options: [],
    default_values: [],
    min_values: default_min_values,
    max_values: default_max_values,
    disabled: False,
    handler: default_handler,
  )
}

pub fn placeholder(select_menu: TextSelectMenu(ctx), placeholder: String) {
  TextSelectMenu(..select_menu, placeholder:)
}

pub fn options(select_menu: TextSelectMenu(ctx), options: List(Option)) {
  TextSelectMenu(..select_menu, options:)
}

pub fn default_values(
  select_menu: TextSelectMenu(ctx),
  default_values: List(Dynamic),
) {
  TextSelectMenu(..select_menu, default_values:)
}

pub fn min_values(select_menu: TextSelectMenu(ctx), min_values: Int) {
  let min_values =
    int.clamp(min_values, min: absolute_min_values, max: absolute_max_values)

  TextSelectMenu(..select_menu, min_values:)
}

pub fn max_values(select_menu: TextSelectMenu(ctx), max_values: Int) {
  let max_values =
    int.clamp(max_values, min: absolute_min_values, max: absolute_max_values)

  TextSelectMenu(..select_menu, max_values:)
}

pub fn disabled(select_menu: TextSelectMenu(ctx)) {
  TextSelectMenu(..select_menu, disabled: True)
}

pub fn handler(select_menu: TextSelectMenu(ctx), handler: Handler(ctx)) {
  TextSelectMenu(..select_menu, handler:)
}

pub type Handler(ctx) =
  fn(interaction.MessageComponent, Credentials, ctx, List(Dynamic)) ->
    Result(Response, Error)

pub fn default_handler(_, _, _, _) {
  Error(NotImplemented)
}

pub fn run(
  select_menu: TextSelectMenu(ctx),
  interaction: interaction.MessageComponent,
  creds: Credentials,
  ctx: ctx,
  values: List(Dynamic),
) {
  select_menu.handler(interaction, creds, ctx, values)
}
