import application_command/option_data
import application_commands.{type ApplicationCommand} as command
import gleam/dict
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

/// TODO: Use a dict of strings for to map handlers, then build string from options and lookup in dict
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
          -> handle_chat_input_group(options, subcommands, i, state)
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

fn handle_chat_input_group(
  options: type_utils.Or(
    List(option_data.Value),
    type_utils.Or(option_data.SubcommandGroup, option_data.Subcommand),
  ),
  subcommands: List(
    type_utils.Or(
      command.ChatInputSubcommandGroup(state),
      command.ChatInputSubcommand(state),
    ),
  ),
  i: Interaction,
  state: state,
) -> Result(response.Response, Nil) {
  let assert type_utils.B(invoked) = options
  case invoked {
    type_utils.A(option_data.SubcommandGroup(
      name: invoked_name,
      subcommand: invoked_subcommand,
    )) ->
      list.find_map(subcommands, fn(s) {
        case s {
          type_utils.A(command.ChatInputSubcommandGroup(name:, subcommands:, ..))
            if name == invoked_name
          ->
            list.find_map(subcommands, fn(s) {
              case s {
                command.ChatInputSubcommand(signature:, handler:, ..)
                  if signature.name == invoked_subcommand.name
                -> {
                  list.map(invoked_subcommand.options, fn(o) { #(o.name, o) })
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
          type_utils.B(command.ChatInputSubcommand(signature:, handler:, ..))
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

fn handle_component(components, state, i, data) {
  todo
}

fn handle_autocomplete(commands, state, i, data) {
  todo
}

fn handle_modal(modals, state, i, data) {
  todo
}
