import bot.{type Bot}
import discord/api
import gleam/http/request.{type Request}
import gleam/string

pub fn create_response(
  bot: Bot(ctx),
  id interaction_id: String,
  token interaction_token: String,
  response response: _,
) -> Request(_) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "interactions",
        interaction_id,
        interaction_token,
        "callback",
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> api.authorization_header(bot)
  |> request.set_body(response)
}
