//// Helper functions to create HTTP requests to the Discord interactions API
//// 
//// TODO: Use a proper "Response" object as a param when one exists

import bot.{type Bot}
import discord/api/api
import gleam/bool
import gleam/http
import gleam/http/request.{type Request}
import gleam/string

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#create-interaction-response
pub fn create_response(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
  response response: String,
  with_callback with_callback: Bool,
) -> Request(String) {
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
  |> request.set_method(http.Post)
  |> request.set_query([#("with_response", bool.to_string(with_callback))])
  |> api.authorization_header(bot)
  |> request.set_body(response)
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#get-original-interaction-response
pub fn get_original_response(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "interactions",
        interaction_id,
        interaction_token,
        "messages",
        "@original",
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Get)
  |> api.authorization_header(bot)
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#edit-original-interaction-response
pub fn edit_original_response(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
  response response: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "interactions",
        interaction_id,
        interaction_token,
        "messages",
        "@original",
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Patch)
  |> api.authorization_header(bot)
  |> request.set_body(response)
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#delete-original-interaction-response
pub fn delete_original_response(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "interactions",
        interaction_id,
        interaction_token,
        "messages",
        "@original",
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Delete)
  |> api.authorization_header(bot)
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#create-followup-message
pub fn create_followup_message(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
  response response: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [api.base_url, "interactions", interaction_id, interaction_token],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Post)
  |> api.authorization_header(bot)
  |> request.set_body(response)
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#get-followup-message
pub fn get_followup_message(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
  message message_id: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "interactions",
        interaction_id,
        interaction_token,
        "messages",
        message_id,
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Get)
  |> api.authorization_header(bot)
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#edit-followup-message
pub fn edit_followup_message(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
  message message_id: String,
  response response: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "interactions",
        interaction_id,
        interaction_token,
        "messages",
        message_id,
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Patch)
  |> api.authorization_header(bot)
  |> request.set_body(response)
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#delete-followup-message
pub fn delete_followup_message(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
  message message_id: String,
) -> Request(String) {
  let endpoint =
    string.join(
      [
        api.base_url,
        "interactions",
        interaction_id,
        interaction_token,
        "messages",
        message_id,
      ],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Delete)
  |> api.authorization_header(bot)
}
