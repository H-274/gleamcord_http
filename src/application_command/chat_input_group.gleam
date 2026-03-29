import application_command/chat_input.{type ChatInput}
import application_command/interaction.{type Interaction}
import application_command/option_value
import application_command/response.{type Response}
import gleam/dict.{type Dict}
import gleam/list

pub opaque type ChatInputGroup(state) {
  ChatInputGroup(
    name: String,
    description: String,
    subcommands: Dict(String, GroupSubcommand(state)),
  )
}

pub fn new(
  name name: String,
  desc description: String,
  subs subcommands: List(GroupSubcommand(state)),
) -> ChatInputGroup(state) {
  let subcommands =
    list.map(subcommands, fn(s) {
      case s {
        SubcommandGroup(name:, ..) -> #(name, s)
        Subcommand(c) -> #(chat_input.get_name(c), s)
      }
    })
    |> dict.from_list

  ChatInputGroup(name:, description:, subcommands:)
}

pub fn get_name(group: ChatInputGroup(_)) -> String {
  group.name
}

pub opaque type GroupSubcommand(state) {
  SubcommandGroup(
    name: String,
    description: String,
    subcommands: Dict(String, ChatInput(state)),
  )
  Subcommand(ChatInput(state))
}

pub fn subcommand_group(
  name name: String,
  desc description: String,
  subs subcommands: List(ChatInput(state)),
) -> GroupSubcommand(state) {
  let subcommands =
    list.map(subcommands, fn(s) { #(chat_input.get_name(s), s) })
    |> dict.from_list

  SubcommandGroup(name:, description:, subcommands:)
}

pub fn subcommand(chat_input: ChatInput(state)) -> GroupSubcommand(state) {
  Subcommand(chat_input)
}

pub fn run(
  chat_input_group: ChatInputGroup(state),
  i: Interaction,
  state: state,
  group: option_value.Group,
) -> Result(Response, Nil) {
  case group {
    option_value.Subcommand(invoked) ->
      case dict.get(chat_input_group.subcommands, invoked.name) {
        Ok(Subcommand(chat_input)) ->
          chat_input.run(chat_input, i, state, invoked.options)
        _ -> Error(Nil)
      }
    option_value.SubcommandGroup(invoked) ->
      case dict.get(chat_input_group.subcommands, invoked.name) {
        Ok(SubcommandGroup(subcommands:, ..)) ->
          run_subcommand_group(subcommands, i, state, invoked.sub)
        _ -> Error(Nil)
      }
  }
}

fn run_subcommand_group(
  group_subcommands: Dict(String, ChatInput(state)),
  i: Interaction,
  state: state,
  invoked: option_value.Subcommand,
) -> Result(Response, Nil) {
  case dict.get(group_subcommands, invoked.name) {
    Ok(chat_input) -> chat_input.run(chat_input, i, state, invoked.options)
    _ -> Error(Nil)
  }
}

pub fn run_autocomplete(
  chat_input_group: ChatInputGroup(state),
  i: Interaction,
  state: state,
  group: option_value.Group,
) -> Result(response.AutocompleteResponse, Nil) {
  case group {
    option_value.Subcommand(invoked) ->
      case dict.get(chat_input_group.subcommands, invoked.name) {
        Ok(Subcommand(chat_input)) ->
          chat_input.run_autocomplete(chat_input, i, state, invoked.options)
        _ -> Error(Nil)
      }
    option_value.SubcommandGroup(invoked) ->
      case dict.get(chat_input_group.subcommands, invoked.name) {
        Ok(SubcommandGroup(subcommands:, ..)) ->
          run_subcommand_group_autocomplete(subcommands, i, state, invoked.sub)
        _ -> Error(Nil)
      }
  }
}

fn run_subcommand_group_autocomplete(
  group_subcommands: Dict(String, ChatInput(state)),
  i: Interaction,
  state: state,
  invoked: option_value.Subcommand,
) -> Result(response.AutocompleteResponse, Nil) {
  case dict.get(group_subcommands, invoked.name) {
    Ok(chat_input) ->
      chat_input.run_autocomplete(chat_input, i, state, invoked.options)
    _ -> Error(Nil)
  }
}
