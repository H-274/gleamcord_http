import command/command.{type Command}
import credentials.{type Credentials}
import decode/zero as decode
import gleam/bool
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
    modals: Nil,
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
}

fn handle_request(config: Configuration(ctx), req: Request) {
  use req, json_body <- web.middleware(req, config.credentials)
  use <- bool.guard(
    when: ["interactions"] != wisp.path_segments(req),
    return: wisp.not_found(),
  )

  use interaction <- given.lazy_error(
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

    interaction.AppCommandInteraction(interaction.AppCommand(..) as i) ->
      app_command_routing(
        i,
        config.commands,
        config.context,
        config.credentials,
      )
    interaction.AppCommandAutocompleteInteraction(
      interaction.AppCommandAutocomplete(..) as i,
    ) ->
      app_command_autocomplete_routing(
        i,
        config.commands,
        config.context,
        config.credentials,
      )
    interaction.MessageComponentInteraction(
      interaction.MessageComponent(..) as i,
    ) ->
      message_component_routing(
        i,
        config.components,
        config.context,
        config.credentials,
      )
    interaction.ModalSubdmitInteraction(interaction.ModalSubmit(..) as i) ->
      modal_submit_routing(i, config.modals, config.context, config.credentials)
  }
}

fn app_command_routing(
  app_command: interaction.AppCommand(data),
  commands: List(Command(ctx)),
  context: ctx,
  credentials: Credentials,
) {
  todo
}

fn app_command_autocomplete_routing(
  app_command: interaction.AppCommandAutocomplete(data),
  commands: List(Command(ctx)),
  context: ctx,
  credentials: Credentials,
) {
  todo
}

fn message_component_routing(
  message_component: interaction.MessageComponent(data),
  components: List(MessageComponent(ctx)),
  context: ctx,
  credentials: Credentials,
) {
  todo
}

fn modal_submit_routing(
  modal_submit: interaction.ModalSubmit(data),
  modals: Nil,
  context: ctx,
  credentials: Credentials,
) {
  todo
}
