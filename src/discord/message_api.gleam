//// Helper functions to create HTTP requests to the Discord message API
//// 
//// TODO: Use a proper "Message" object as a param when one exists
//// TODO: Use a proper "Emoji" object as a param when one exists

import bot.{type Bot}
import discord/api
import gleam/http
import gleam/http/request.{type Request}
import gleam/int
import gleam/string
import gleam/uri

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
/// 
/// TODO: Add support for sending message attachments
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

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#crosspost-message
pub fn crosspost_message(
  bot: Bot(_),
  channel channel_id: String,
  message message_id: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "channels",
        channel_id,
        "messages",
        message_id,
        "crosspost",
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Post)
  |> api.authorization_header(bot)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#create-reaction
pub fn create_reaction(
  bot: Bot(_),
  channel channel_id: String,
  message message_id: String,
  emoji emoji: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "channels",
        channel_id,
        "messages",
        message_id,
        "reactions",
        uri.percent_encode(emoji),
        "@me",
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Put)
  |> api.authorization_header(bot)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#delete-own-reaction
pub fn delete_own_reaction(
  bot: Bot(_),
  channel channel_id: String,
  message message_id: String,
  emoji emoji: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "channels",
        channel_id,
        "messages",
        message_id,
        "reactions",
        uri.percent_encode(emoji),
        "@me",
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Delete)
  |> api.authorization_header(bot)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#delete-own-reaction
pub fn delete_user_reaction(
  bot: Bot(_),
  channel channel_id: String,
  message message_id: String,
  emoji emoji: String,
  user user_id: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "channels",
        channel_id,
        "messages",
        message_id,
        "reactions",
        uri.percent_encode(emoji),
        user_id,
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Delete)
  |> api.authorization_header(bot)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#get-reactions
/// 
/// TODO: Add support for `type`/`after` query params
pub fn get_reactions(
  bot: Bot(_),
  channel channel_id: String,
  message message_id: String,
  emoji emoji: String,
  limit limit: Int,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "channels",
        channel_id,
        "messages",
        message_id,
        "reactions",
        uri.percent_encode(emoji),
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Get)
  |> api.authorization_header(bot)
  |> request.set_query([#("limit", int.to_string(limit))])
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#delete-all-reactions
pub fn delete_all_reactions(
  bot: Bot(_),
  channel channel_id: String,
  message message_id: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "channels",
        channel_id,
        "messages",
        message_id,
        "reactions",
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Delete)
  |> api.authorization_header(bot)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#delete-all-reactions-for-emoji
pub fn delete_all_reactions_for_emoji(
  bot: Bot(_),
  channel channel_id: String,
  message message_id: String,
  emoji emoji: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "channels",
        channel_id,
        "messages",
        message_id,
        "reactions",
        uri.percent_encode(emoji),
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Delete)
  |> api.authorization_header(bot)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#edit-message
/// 
/// TODO: Also in need of support for file attachments
pub fn edit_message(
  bot: Bot(_),
  channel channel_id: String,
  message message_id: String,
  updated message: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [api.base_url, "channels", channel_id, "messages", message_id],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Patch)
  |> api.authorization_header(bot)
  |> request.set_body(message)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#delete-message
pub fn delete_message(
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
  |> request.set_method(http.Delete)
  |> api.authorization_header(bot)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#bulk-delete-messages
pub fn bulk_delete_messages(
  bot: Bot(_),
  channel channel_id: String,
  messages message_id_list: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [api.base_url, "channels", channel_id, "messages", "bulk-delete"],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Post)
  |> api.authorization_header(bot)
  |> request.set_body(message_id_list)
}
