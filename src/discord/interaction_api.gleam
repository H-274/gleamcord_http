import bot.{type Bot}
import discord/api
import gleam/bool
import gleam/http
import gleam/http/request.{type Request}
import gleam/string

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

pub fn get_original_response(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
) {
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

pub fn edit_original_response(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
) {
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
}

pub fn delete_original_response(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
) {
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

pub fn create_followup_message(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
  response response: String,
) {
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

pub fn get_followup_message(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
  message message_id: String,
) {
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

pub fn edit_followup_message(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
  message message_id: String,
  response response: String,
) {
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

pub fn delete_followup_message(
  bot: Bot(_),
  id interaction_id: String,
  token interaction_token: String,
  message message_id: String,
) {
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
