import gleam/http/request.{type Request}
import gleam/json.{type Json}
import gleam/list
import gleam/string

const url_base = "https://discord.com/api/v10"

pub type Auth {
  BotAuth(token: String)
  BearerAuth(token: String)
}

pub fn set_auth_header(request: Request(_), auth: Auth) {
  request.set_header(request, "Authorization", case auth {
    BotAuth(token:) -> "Bot " <> token
    BearerAuth(token:) -> "Bearer " <> token
  })
}

pub type QueryParams =
  List(#(String, String))

fn query_params_string(query_params: QueryParams) {
  "?"
  <> {
    list.map(query_params, fn(param) { param.0 <> "=" <> param.1 })
    |> string.join("&")
  }
}

/// body parameter is a multipart/form bit array
pub fn edit_original_interaction_response(
  auth: Auth,
  app_id: String,
  interaction_token: String,
  query_params: List(#(String, String)),
  response: Json,
) -> Request(String) {
  let assert Ok(request) =
    request.to(
      string.join([url_base, app_id, interaction_token], "/")
      <> query_params_string(query_params),
    )

  set_auth_header(request, auth)
  |> request.set_header("Content-Type", "application/json")
  |> request.set_body(json.to_string(response))
}
