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

/// TODO replace with proper channel_types list
/// TODO replace dynamic types with proper types
pub type ChannelSelectMenu(ctx) {
  ChannelSelectMenu(
    custom_id: String,
    channel_types: List(Int),
    placeholder: String,
    default_values: List(Dynamic),
    min_values: Int,
    max_values: Int,
    disabled: Bool,
    handler: Handler(ctx),
  )
}

pub fn new(custom_id: String) {
  ChannelSelectMenu(
    custom_id:,
    channel_types: [],
    placeholder: "",
    default_values: [],
    min_values: default_min_values,
    max_values: default_max_values,
    disabled: False,
    handler: default_handler,
  )
}

pub fn channel_types(
  select_menu: ChannelSelectMenu(ctx),
  channel_types: List(Int),
) {
  ChannelSelectMenu(..select_menu, channel_types:)
}

pub fn placeholder(select_menu: ChannelSelectMenu(ctx), placeholder: String) {
  ChannelSelectMenu(..select_menu, placeholder:)
}

pub fn default_values(
  select_menu: ChannelSelectMenu(ctx),
  default_values: List(Dynamic),
) {
  ChannelSelectMenu(..select_menu, default_values:)
}

pub fn min_values(select_menu: ChannelSelectMenu(ctx), min_values: Int) {
  let min_values =
    int.clamp(min_values, min: absolute_min_values, max: absolute_max_values)

  ChannelSelectMenu(..select_menu, min_values:)
}

pub fn max_values(select_menu: ChannelSelectMenu(ctx), max_values: Int) {
  let max_values =
    int.clamp(max_values, min: absolute_min_values, max: absolute_max_values)

  ChannelSelectMenu(..select_menu, max_values:)
}

pub fn disabled(select_menu: ChannelSelectMenu(ctx)) {
  ChannelSelectMenu(..select_menu, disabled: True)
}

pub fn handler(select_menu: ChannelSelectMenu(ctx), handler: Handler(ctx)) {
  ChannelSelectMenu(..select_menu, handler:)
}

pub type Handler(ctx) =
  fn(interaction.MessageComponent(Data), Credentials, ctx, List(Dynamic)) ->
    Result(Response, Error)

pub fn default_handler(_, _, _, _) {
  Error(NotImplemented)
}

pub fn run(
  select_menu: ChannelSelectMenu(ctx),
  interaction: interaction.MessageComponent(Data),
  creds: Credentials,
  ctx: ctx,
  values: List(Dynamic),
) {
  select_menu.handler(interaction, creds, ctx, values)
}
