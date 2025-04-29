//// Helper functions to create HTTP requests to the Discord interactions API

import discord/api/api
import discord/entities/message.{type Message}
import gleam/bit_array
import gleam/bool
import gleam/http
import gleam/http/request.{type Request}
import gleam/json
import gleam/string
import response.{type Response}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#create-interaction-response
pub fn create_response(
  auth_string: String,
  interaction_id: String,
  interaction_token: String,
  response response: Response,
  with_callback with_callback: Bool,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(response.json(response) |> bit_array.from_string())
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#get-original-interaction-response
pub fn get_original_response(
  auth_string: String,
  interaction_id: String,
  interaction_token: String,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#edit-original-interaction-response
pub fn edit_original_response(
  auth_string: String,
  interaction_id: String,
  interaction_token: String,
  response response: Response,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(response.json(response) |> bit_array.from_string())
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#delete-original-interaction-response
pub fn delete_original_response(
  auth_string: String,
  interaction_id: String,
  interaction_token: String,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#create-followup-message
pub fn create_followup_message(
  auth_string: String,
  interaction_id: String,
  interaction_token: String,
  message message: Message,
) -> Request(BitArray) {
  let endpoint =
    string.join(
      [api.base_url, "interactions", interaction_id, interaction_token],
      "/",
    )

  let assert Ok(req) = request.to(endpoint)
  req
  |> request.set_method(http.Post)
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(
    message.json(message)
    |> json.to_string()
    |> bit_array.from_string(),
  )
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#get-followup-message
pub fn get_followup_message(
  auth_string: String,
  interaction_id: String,
  interaction_token: String,
  id message_id: String,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(<<>>)
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#edit-followup-message
pub fn edit_followup_message(
  auth_string: String,
  interaction_id: String,
  interaction_token: String,
  id message_id: String,
  message message: Message,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(
    message.json(message)
    |> json.to_string()
    |> bit_array.from_string(),
  )
}

/// Endpoint documentation: https://discord.com/developers/docs/interactions/receiving-and-responding#delete-followup-message
pub fn delete_followup_message(
  auth_string: String,
  interaction_id: String,
  interaction_token: String,
  id message_id: String,
) -> Request(BitArray) {
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
  |> request.set_header("Authorization", auth_string)
  |> request.set_body(<<>>)
}
