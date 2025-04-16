//// Helper functions to create HTTP requests to the Discord message API
//// 
//// TODO: Use a proper "Message" object as a param when one exists

import bot.{type Bot}
import discord/api
import gleam/http
import gleam/http/request.{type Request}
import gleam/int
import gleam/string

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#get-channel-messages
/// 
/// TODO: Add support for `around`/`before`/`after` query params
pub fn get_channel_messages(
  bot: Bot(_),
  channel channel_id: String,
  limit limit: Int,
) -> Request(String) {
  let endpoint =
    string.join([api.base_url, "channels", channel_id, "messages"], "/")

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Get)
  |> api.authorization_header(bot)
  |> request.set_query([#("limit", int.to_string(limit))])
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#get-channel-message
pub fn get_channel_message(
  bot: Bot(_),
  channel channel_id: String,
  message message_id: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [api.base_url, "channels", channel_id, "messages", message_id],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Get)
  |> api.authorization_header(bot)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#create-message
pub fn create_message(
  bot: Bot(_),
  channel channel_id: String,
  message message: String,
) -> Request(String) {
  let endpoint =
    string.join([api.base_url, "channels", channel_id, "messages"], "/")

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Post)
  |> api.authorization_header(bot)
  |> request.set_body(message)
}
