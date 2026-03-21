import application_commands.{type ApplicationCommand} as command
import gleam/dict.{type Dict}
import gleam/list
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
    commands: Dict(String, ApplicationCommand(state)),
    // TODO implement message component definitions
    components: Dict(String, Nil),
    // TODO implement modals definitions
    modals: Dict(String, Nil),
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
      case dict.get(commands, invoked_name), options {
        Ok(command.ChatInput(handler:, ..)), type_utils.A(options) -> {
          list.map(options, fn(o) { #(o.name, o) })
          |> dict.from_list
          |> handler(i, state, _)
          |> response.Command
          |> Ok
        }
        Ok(command.ChatInputGroup(subcommands:, ..)), type_utils.B(option) ->
          case option {
            type_utils.A(invoked) ->
              case dict.get(subcommands, invoked.name) {
                Ok(type_utils.A(group)) ->
                  case dict.get(group.subcommands, invoked.subcommand.name) {
                    Ok(subcommand) ->
                      invoked.subcommand.options
                      |> list.map(fn(o) { #(o.name, o) })
                      |> dict.from_list
                      |> subcommand.handler(i, state, _)
                      |> response.Command
                      |> Ok
                    _ -> Error(Nil)
                  }
                _ -> Error(Nil)
              }
            type_utils.B(invoked) ->
              case dict.get(subcommands, invoked.name) {
                Ok(type_utils.B(subcommand)) ->
                  list.map(invoked.options, fn(o) { #(o.name, o) })
                  |> dict.from_list
                  |> subcommand.handler(i, state, _)
                  |> response.Command
                  |> Ok
                _ -> Error(Nil)
              }
          }
        _, _ -> Error(Nil)
      }
    data.UserApplicationCommand(name: invoked, ..) ->
      case dict.get(commands, invoked) {
        Ok(command.User(handler:, ..)) ->
          handler(i, state) |> response.Command |> Ok
        _ -> Error(Nil)
      }
    data.MessageApplicationCommand(name: invoked, ..) ->
      case dict.get(commands, invoked) {
        Ok(command.Message(handler:, ..)) ->
          handler(i, state) |> response.Command |> Ok
        _ -> Error(Nil)
      }
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
