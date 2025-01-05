//// TODO fix/unify response types

import bot.{type Bot}
import interaction.{type Interaction}
import message_component/data.{
  type ButtonData, type ChannelSelectData, type MentionableSelectData,
  type RoleSelectData, type StringSelectData, type TextInputData,
  type UserSelectData,
}

pub type ComponentResponse {
  JsonString(String)
}

pub type ComponentError {
  NotImplemented
}

pub type ButtonHandler(ctx) =
  fn(Interaction(ButtonData), Bot, ctx) ->
    Result(ComponentResponse, ComponentError)

pub type StringSelectHandler(ctx) =
  fn(Interaction(StringSelectData), Bot, ctx) ->
    Result(ComponentResponse, ComponentError)

pub type TextInputHandler(ctx) =
  fn(Interaction(TextInputData), Bot, ctx) ->
    Result(ComponentResponse, ComponentError)

pub type UserSelectHandler(ctx) =
  fn(Interaction(UserSelectData), Bot, ctx) ->
    Result(ComponentResponse, ComponentError)

pub type RoleSelectHandler(ctx) =
  fn(Interaction(RoleSelectData), Bot, ctx) ->
    Result(ComponentResponse, ComponentError)

pub type MentionableSelectHandler(ctx) =
  fn(Interaction(MentionableSelectData), Bot, ctx) ->
    Result(ComponentResponse, ComponentError)

pub type ChannelSelectHandler(ctx) =
  fn(Interaction(ChannelSelectData), Bot, ctx) ->
    Result(ComponentResponse, ComponentError)

pub fn undefined(_, _, _) {
  Error(NotImplemented)
}
