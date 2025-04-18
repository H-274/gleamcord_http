//// Helper functions to create HTTP requests to the Discord message API

import discord/api/api
import gleam/http
import gleam/http/request.{type Request}
import gleam/string
import gleam/uri

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#get-channel-messages
pub fn get_channel_messages(
  auth_string: String,
  channel_id: String,
  set_query set_query: fn(Request(_)) -> Request(_),
) -> Request(BitArray) {
  let endpoint =
    string.join([api.base_url, "channels", channel_id, "messages"], "/")

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Get)
  |> request.set_header("Authorization", auth_string)
  |> set_query()
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#get-channel-message
pub fn get_channel_message(
  auth_string: String,
  channel_id: String,
  message message_id: String,
) -> Request(BitArray) {
  let endpoint =
    string.join(
      [api.base_url, "channels", channel_id, "messages", message_id],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Get)
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#create-message
pub fn create_message(
  auth_string: String,
  channel_id: String,
  message message: message,
  set_body set_body: fn(Request(_), message) -> Request(BitArray),
) -> Request(BitArray) {
  let endpoint =
    string.join([api.base_url, "channels", channel_id, "messages"], "/")

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Post)
  |> request.set_header("Authorization", auth_string)
  |> set_body(message)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#crosspost-message
pub fn crosspost_message(
  auth_string: String,
  channel_id: String,
  message message_id: String,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#create-reaction
/// 
/// The `emoji` parameter is formated as follows: `name:id`
pub fn create_reaction(
  auth_string: String,
  channel_id: String,
  id message_id: String,
  emoji emoji: String,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#delete-own-reaction
/// 
/// The `emoji` parameter is formated as follows: `name:id`
pub fn delete_own_reaction(
  auth_string: String,
  channel_id: String,
  id message_id: String,
  emoji emoji: String,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#delete-own-reaction
/// 
/// The `emoji` parameter is formated as follows: `name:id`
pub fn delete_user_reaction(
  auth_string: String,
  channel_id: String,
  id message_id: String,
  emoji emoji: String,
  user user_id: String,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#get-reactions
/// 
/// The `emoji` parameter is formated as follows: `name:id`
pub fn get_reactions(
  auth_string: String,
  channel_id: String,
  id message_id: String,
  emoji emoji: String,
  set_query set_query: fn(Request(_)) -> Request(_),
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> set_query()
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#delete-all-reactions
pub fn delete_all_reactions(
  auth_string: String,
  channel_id: String,
  id message_id: String,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#delete-all-reactions-for-emoji
/// 
/// The `emoji` parameter is formated as follows: `name:id`
pub fn delete_all_reactions_for_emoji(
  auth_string: String,
  channel_id: String,
  id message_id: String,
  emoji emoji: String,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#edit-message
/// 
/// TODO: Also in need of support for file attachments
pub fn edit_message(
  auth_string: String,
  channel_id: String,
  id message_id: String,
  message message: message,
  set_body set_body: fn(Request(_), message) -> Request(BitArray),
) -> Request(BitArray) {
  let endpoint =
    string.join(
      [api.base_url, "channels", channel_id, "messages", message_id],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Patch)
  |> request.set_header("Authorization", auth_string)
  |> set_body(message)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#delete-message
pub fn delete_message(
  auth_string: String,
  channel_id: String,
  id message_id: String,
) -> Request(BitArray) {
  let endpoint =
    string.join(
      [api.base_url, "channels", channel_id, "messages", message_id],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Delete)
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#bulk-delete-messages
pub fn bulk_delete_messages(
  auth_string: String,
  channel_id: String,
  ids message_id_list: List(String),
  set_body set_body: fn(Request(_), List(String)) -> Request(BitArray),
) -> Request(BitArray) {
  let endpoint =
    string.join(
      [api.base_url, "channels", channel_id, "messages", "bulk-delete"],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Post)
  |> request.set_header("Authorization", auth_string)
  |> set_body(message_id_list)
}
