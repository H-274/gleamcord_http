import bot.{type Bot}
import gleam/dynamic.{type Dynamic}
import interaction

pub type RoleSelectMenu(ctx, data, res, err) {
  RoleSelectMenu(
    custom_id: String,
    placeholder: String,
    default_values: List(Dynamic),
    min_values: Int,
    max_values: Int,
    disabled: Bool,
    handler: Handler(ctx, data, res, err),
  )
}

pub type Handler(ctx, data, res, err) =
  fn(interaction.MessageComponent(data), Bot, ctx, List(Dynamic)) ->
    Result(res, err)
