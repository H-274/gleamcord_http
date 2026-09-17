import gleam/http/request.{type Request}
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

pub fn edit_original_interaction_response(
  auth: Auth,
  app_id: String,
  interaction_token: String,
  query_params: String,
  content_type: String,
  body: BitArray,
) {
  let assert Ok(request) =
    request.to(
      string.join([url_base, app_id, interaction_token], "/")
      <> "?"
      <> query_params,
    )

  set_auth_header(request, auth)
  |> request.set_header("Content-Type", content_type)
  |> request.set_body(body)
  |> Ok
}
