//// TODO replace dynamics

import bot.{type Bot}
import gleam/dynamic.{type Dynamic}
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
  fn(Interaction(StringSelectData), Bot, ctx, List(String)) ->
    Result(ComponentResponse, ComponentError)

pub type TextInputHandler(ctx) =
  fn(Interaction(TextInputData), Bot, ctx, String) ->
    Result(ComponentResponse, ComponentError)

pub type UserSelectHandler(ctx) =
  fn(Interaction(UserSelectData), Bot, ctx, List(Dynamic)) ->
    Result(ComponentResponse, ComponentError)

pub type RoleSelectHandler(ctx) =
  fn(Interaction(RoleSelectData), Bot, ctx, List(Dynamic)) ->
    Result(ComponentResponse, ComponentError)

pub type MentionableSelectHandler(ctx) =
  fn(Interaction(MentionableSelectData), Bot, ctx, List(Dynamic)) ->
    Result(ComponentResponse, ComponentError)

pub type ChannelSelectHandler(ctx) =
  fn(Interaction(ChannelSelectData), Bot, ctx, List(Dynamic)) ->
    Result(ComponentResponse, ComponentError)

pub fn undefined(_, _, _) {
  Error(NotImplemented)
}
