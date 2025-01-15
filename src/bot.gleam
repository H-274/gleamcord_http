import command/command.{type Command}
import credentials.{type Credentials}
import decode/zero as decode
import gleam/erlang/process
import gleam/string_tree
import interaction
import internal/given
import internal/pretty_string
import internal/web
import message_component/message_component.{type MessageComponent}
import mist
import wisp.{type Request}
import wisp/wisp_mist

pub type Configuration(ctx) {
  Configuration(
    credentials: Credentials,
    context: ctx,
    commands: List(Command(ctx)),
    components: List(MessageComponent(ctx)),
  )
}

pub fn start(config: Configuration(ctx), port: Int) {
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)

  let handler = handle_request(config, _)

  let assert Ok(_) =
    wisp_mist.handler(handler, secret_key_base)
    |> mist.new()
    |> mist.port(port)
    |> mist.start_http()

  process.sleep_forever()
}

fn handle_request(config: Configuration(ctx), req: Request) {
  use req, json_body <- web.middleware(req, config.credentials)
  use <- given.is_not(
    expected: ["interactions"],
    from: wisp.path_segments(req),
    then: fn(_) { wisp.not_found() },
  )

  use interaction <- given.error(
    in: decode.run(json_body, interaction.decoder()),
    then: fn(e) {
      wisp.log_critical("Unable to decode interaction")
      wisp.log_critical(pretty_string.decode_errors(e))
      wisp.internal_server_error()
    },
  )

  case interaction {
    interaction.PingInteraction(_) ->
      wisp.no_content() |> wisp.json_body(string_tree.from_string("type: 1"))

    interaction.AppCommandInteraction(interaction.AppCommand(..) as i) -> todo
    interaction.AppCommandAutocompleteInteraction(
      interaction.AppCommandAutocomplete(..) as i,
    ) -> todo
    interaction.MessageComponentInteraction(
      interaction.MessageComponent(..) as i,
    ) -> todo
    interaction.ModalSubdmitInteraction(interaction.ModalSubmit(..)) -> todo
  }
}
