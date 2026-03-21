import application_command/option_data
import application_commands.{type ApplicationCommand} as command
import gleam/dict
import gleam/erlang/process
import gleam/list
import gleam/option.{type Option}
import interaction.{type Interaction}
import interaction/data
import internal/type_utils
import response

pub type Bot(state) {
  Bot(
    app_id: String,
    pub_key: String,
    token: String,
    state: state,
    deferred_actor: Option(process.Name(fn() -> String)),
    commands: List(ApplicationCommand(state)),
    // TODO implement message component definitions
    components: List(Nil),
    // TODO implement modals definitions
    modals: List(Nil),
  )
}

pub fn handle_interaction(
  bot: Bot(_),
  i i: Interaction,
) -> Result(response.Response, Nil) {
  case i {
    interaction.Ping(..) -> Ok(response.Pong)
    interaction.ApplicationCommand(data:, ..) ->
      handle_application_command(bot.commands, bot.state, i, data)
    interaction.MessageComponent(data:, ..) ->
      handle_component(bot.components, bot.state, i, data)
    interaction.ApplicationCommandAutocomplete(data:, ..) ->
      handle_autocomplete(bot.commands, bot.state, i, data)
    interaction.ModalSubmit(data:, ..) ->
      handle_modal(bot.commands, bot.state, i, data)
  }
}

fn handle_application_command(commands, state, i, data) {
  case data {
    data.ChatInputApplicationCommand(name: invoked_name, options:, ..) ->
      list.find_map(commands, fn(c) {
        case c {
          command.ChatInput(signature:, handler:, ..)
            if signature.name == invoked_name
          -> {
            let assert type_utils.A(options) = options
            list.map(options, fn(o) { #(o.name, o) })
            |> dict.from_list
            |> handler(i, state, _)
            |> response.Command
            |> Ok
          }
          command.ChatInputGroup(name:, subcommands:, ..)
            if name == invoked_name
          -> {
            let assert type_utils.B(invoked_subcommand) = options
            case invoked_subcommand {
              type_utils.A(option_data.SubcommandGroup(
                name: invoked_name,
                subcommand: invoked_subcommand,
              )) ->
                list.find_map(subcommands, fn(s) {
                  case s {
                    type_utils.A(command.ChatInputSubcommandGroup(
                      name:,
                      subcommands:,
                      ..,
                    ))
                      if name == invoked_name
                    ->
                      list.find_map(subcommands, fn(s) {
                        case s {
                          command.ChatInputSubcommand(signature:, handler:, ..)
                            if signature.name == invoked_subcommand.name
                          -> {
                            list.map(invoked_subcommand.options, fn(o) {
                              #(o.name, o)
                            })
                            |> dict.from_list
                            |> handler(i, state, _)
                            |> response.Command
                            |> Ok
                          }
                          _ -> Error(Nil)
                        }
                      })
                    _ -> Error(Nil)
                  }
                })
              type_utils.B(option_data.Subcommand(name: invoked_name, options:)) ->
                list.find_map(subcommands, fn(s) {
                  case s {
                    type_utils.B(command.ChatInputSubcommand(
                      signature:,
                      handler:,
                      ..,
                    ))
                      if signature.name == invoked_name
                    -> {
                      list.map(options, fn(o) { #(o.name, o) })
                      |> dict.from_list
                      |> handler(i, state, _)
                      |> response.Command
                      |> Ok
                    }
                    _ -> Error(Nil)
                  }
                })
            }
          }
          _ -> Error(Nil)
        }
      })
    data.UserApplicationCommand(name: invoked_name, ..) ->
      list.find_map(commands, fn(c) {
        case c {
          command.User(signature:, handler:) if signature.name == invoked_name ->
            handler(i, state) |> response.Command |> Ok
          _ -> Error(Nil)
        }
      })
    data.MessageApplicationCommand(name: invoked_name, ..) ->
      list.find_map(commands, fn(c) {
        case c {
          command.Message(signature:, handler:)
            if signature.name == invoked_name
          -> handler(i, state) |> response.Command |> Ok
          _ -> Error(Nil)
        }
      })
  }
}

fn handle_component(components, state, i, data) {
  todo
}

fn handle_autocomplete(commands, state, i, data) {
  todo
}

fn handle_modal(modals, state, i, data) {
  todo
}
