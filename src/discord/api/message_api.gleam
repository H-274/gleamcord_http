//// Helper functions to create HTTP requests to the Discord message API
//// TODO replace the generic types with proper entities when they exist

import discord/api/api
import gleam/http
import gleam/http/request.{type Request}
import gleam/int
import gleam/option.{type Option}
import gleam/string
import gleam/uri

/// TODO: Potentially extract to separate module
pub type RelativePosition {
  Around
  Before
  After
}

fn position_to_string(position: RelativePosition) {
  case position {
    Around -> "around"
    Before -> "before"
    After -> "after"
  }
}

pub type GetMessagesQuery {
  GetMessagesQuery(
    position: Option(#(RelativePosition, String)),
    limit: Option(Int),
  )
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#get-channel-messages
pub fn get_channel_messages(
  auth_string: String,
  channel_id: String,
  query query: Option(GetMessagesQuery),
) -> Request(BitArray) {
  let endpoint =
    string.join([api.base_url, "channels", channel_id, "messages"], "/")

  let query_params = case query {
    option.Some(query) -> {
      let params = case query.position {
        option.Some(#(pos, message)) -> [#(position_to_string(pos), message)]
        _ -> []
      }
      case query.limit {
        option.Some(limit) -> [#("limit", int.to_string(limit)), ..params]
        _ -> params
      }
    }
    _ -> []
  }

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Get)
  |> request.set_header("Authorization", auth_string)
  |> request.set_query(query_params)
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

pub type GetReactionsQuery {
  GetReactionsQuery(
    type_: Option(Int),
    after: Option(String),
    limit: Option(Int),
  )
}

/// Endpoint documentation: https://discord.com/developers/docs/resources/message#get-reactions
/// 
/// The `emoji` parameter is formated as follows: `name:id`
pub fn get_reactions(
  auth_string: String,
  channel_id: String,
  id message_id: String,
  emoji emoji: String,
  query query: Option(GetReactionsQuery),
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

  let query_params = case query {
    option.Some(query) -> {
      let query_params = case query.type_ {
        option.Some(type_) -> [#("type", int.to_string(type_))]
        _ -> []
      }
      let query_params = case query.after {
        option.Some(user) -> [#("after", user), ..query_params]
        _ -> query_params
      }
      case query.limit {
        option.Some(limit) -> [#("limit", int.to_string(limit)), ..query_params]
        _ -> query_params
      }
    }
    _ -> []
  }

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Get)
  |> request.set_header("Authorization", auth_string)
  |> request.set_query(query_params)
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
