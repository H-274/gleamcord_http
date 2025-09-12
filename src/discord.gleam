import bot.{type Bot}
import entities/interaction.{type Interaction}
import gleam/dynamic/decode
import gleam/list
import internal/ed25519
import wisp

pub fn handle_request(req: wisp.Request, bot: Bot, context: context) {
  use interaction: Interaction <- middleware(req, bot)

  case interaction.type_ {
    interaction.Ping -> wisp.no_content()
    interaction.ApplicationCommand -> handle_command(bot, context)
    interaction.ApplicationCommandAutocomplete ->
      handle_autocomplete(bot, context)
    interaction.MessageComponent -> handle_component(bot, context)
    interaction.ModalSubmit -> handle_modal(bot, context)
  }
}

pub fn middleware(
  req: wisp.Request,
  bot: Bot,
  handle_interaction,
) -> wisp.Response {
  let req_copy = req
  use <- require_signed_message(req_copy, bot.auth.public_key)

  let req_copy = req
  use body <- wisp.require_json(req_copy)

  case decode.run(body, interaction.decoder()) {
    Error(errs) -> {
      wisp.log_error("Failed to decode interaction")
      echo #("Interaction decoding errors", errs)

      wisp.internal_server_error()
    }

    Ok(interaction) -> handle_interaction(interaction)
  }
}

fn require_signed_message(req: wisp.Request, key: String, continue) {
  case
    list.key_find(req.headers, "X-Signature-Ed25519"),
    list.key_find(req.headers, "X-Signature-Timestamp")
  {
    Error(Nil), _ -> wisp.bad_request("Missing `X-Signature-Ed25519` header")
    _, Error(Nil) -> wisp.bad_request("Missing `X-Signature-Timestamp` header")

    Ok(sig), Ok(timestamp) -> {
      use body <- wisp.require_string_body(req)
      let msg = timestamp <> body

      case ed25519.verify(msg:, sig:, key:) {
        Ok(False) -> wisp.bad_request("Message and signature do not match")
        Error(ed25519.BadSignature) -> wisp.bad_request("Invalid signature")
        Error(ed25519.BadPublicKey) -> {
          wisp.log_critical("Invalid public key")
          wisp.internal_server_error()
        }

        Ok(True) -> continue()
      }
    }
  }
}

fn handle_command(bot, context) {
  todo
}

fn handle_autocomplete(bot, context) {
  todo
}

fn handle_component(bot, context) {
  todo
}

fn handle_modal(bot, context) {
  todo
}
