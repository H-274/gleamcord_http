import credentials.{type Credentials}
import gleam/dict
import gleam/dynamic
import gleam/http
import internal/crypto/ed25519
import internal/given
import wisp.{type Request, type Response}

pub fn middleware(
  req: Request,
  credentials: Credentials,
  handle_request: fn(Request, dynamic.Dynamic) -> Response,
) -> Response {
  let req_copy = req
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use <- wisp.require_method(req, http.Post)
  use <- verify_request(req_copy, credentials)
  use json_body <- wisp.require_json(req)

  handle_request(req, json_body)
}

fn verify_request(
  req: Request,
  credentials: Credentials,
  handle_request: fn() -> Response,
) {
  let key = credentials.pub_key
  let headers = req.headers |> dict.from_list()
  use str_body <- wisp.require_string_body(req)

  use sig <- given.error(
    in: dict.get(headers, "X-Signature-Ed25519"),
    then: fn(_) {
      wisp.bad_request()
      |> wisp.string_body("Missing header: \"X-Signature-Ed25519\"")
    },
  )
  use timestamp <- given.error(
    in: dict.get(headers, "X-Signature-Timestamp"),
    then: fn(_) {
      wisp.bad_request()
      |> wisp.string_body("Missing header: \"X-Signature-Timestamp\"")
    },
  )

  case ed25519.verify(msg: timestamp <> str_body, sig:, key:) {
    Ok(True) -> {
      wisp.log_debug("Valid request: \n" <> timestamp <> str_body)
      handle_request()
    }
    Ok(False) -> {
      wisp.log_debug("Invalid request: \n" <> timestamp <> str_body)
      wisp.response(401)
    }
    Error(ed25519.BadSignature) -> {
      wisp.log_error("Bad signature: " <> sig)
      wisp.response(401)
    }
    Error(ed25519.BadPublicKey) -> {
      wisp.log_critical("Bad public key")
      wisp.internal_server_error()
    }
  }
}
