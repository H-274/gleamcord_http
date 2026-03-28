//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object

import application_command/chat_input.{type ChatInput}
import application_command/chat_input_group.{type ChatInputGroup}
import application_command/message.{type Message}
import application_command/option_value
import application_command/response.{type Response}
import application_command/user.{type User}
import gleam/dict.{type Dict}
import interaction/data
import interaction/interaction.{type Interaction}

pub opaque type ApplicationCommand(state) {
  ChatInput(ChatInput(state))
  ChatInputGroup(ChatInputGroup(state))
  User(User(state))
  Message(Message(state))
}

pub fn from_chat_input(chat_input: ChatInput(_)) {
  ChatInput(chat_input)
}

pub fn from_chat_input_group(chat_input_group: ChatInputGroup(_)) {
  ChatInputGroup(chat_input_group)
}

pub fn from_user(user: User(_)) {
  User(user)
}

pub fn from_message(message: Message(_)) {
  Message(message)
}

pub fn handle_interaction(
  commands: Dict(String, ApplicationCommand(state)),
  state: state,
  i: Interaction,
  data: data.ApplicationCommand,
) -> Result(Response, Nil) {
  case data {
    data.ChatInputApplicationCommand(name:, options:, ..) ->
      case dict.get(commands, name), options {
        Ok(ChatInput(chat_input)), option_value.Values(values) ->
          chat_input.run(chat_input, i, state, values)

        Ok(ChatInputGroup(chat_input_group)), option_value.Group(group) ->
          chat_input_group.run(chat_input_group, i, state, group)
        _, _ -> Error(Nil)
      }

    data.UserApplicationCommand(name:, ..) ->
      case dict.get(commands, name) {
        Ok(User(user)) -> user.run(user, i, state)
        _ -> Error(Nil)
      }

    data.MessageApplicationCommand(name:, ..) ->
      case dict.get(commands, name) {
        Ok(Message(message)) -> message.run(message, i, state)
        _ -> Error(Nil)
      }
  }
}

pub fn handle_autocomplete_interaction(
  commands: Dict(String, ApplicationCommand(state)),
  state: state,
  i: Interaction,
  data: data.ApplicationCommand,
) -> Result(response.AutocompleteResponse, Nil) {
  case data {
    data.ChatInputApplicationCommand(name: ivk_name, options:, ..) ->
      case dict.get(commands, ivk_name), options {
        Ok(ChatInput(chat_input)), option_value.Values(values) ->
          chat_input.run_autocomplete(chat_input, i, state, values)

        Ok(ChatInputGroup(chat_input_group)), option_value.Group(group) ->
          chat_input_group.run_autocomplete(chat_input_group, i, state, group)

        _, _ -> Error(Nil)
      }
    _ -> Error(Nil)
  }
}
