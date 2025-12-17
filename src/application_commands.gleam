//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object

import gleam/dict.{type Dict}
import internal/type_utils

/// TODO: Replace signature types with signature values
/// unless we want a builder to make the signatures
pub opaque type AplicationCommand {
  ChatInput(signature: ChatInputSignature, handler: ChatInputHandler)
  ChatInputGroup(
    signature: ChatInputSignature,
    subcommands: List(
      type_utils.Or(ChatInputSubcommandGroup, ChatInputSubcommand),
    ),
  )
  User(signature: UserSignature, handler: UserHandler)
  Message(signature: MessageSignature, handler: MessageHandler)
}

pub fn chat_input(signature: ChatInputSignature, handler: ChatInputHandler) {
  ChatInput(signature:, handler:)
}

pub fn chat_input_group(signature: ChatInputSignature) {
  ChatInputGroup(signature:, subcommands: [])
}

pub fn add_subcommand_group(
  command: AplicationCommand,
  subcommand_group: ChatInputSubcommandGroup,
) {
  case command {
    ChatInputGroup(_, subcommands) ->
      ChatInputGroup(..command, subcommands: [
        type_utils.A(subcommand_group),
        ..subcommands
      ])
    _ -> command
  }
}

pub fn add_subcommand(
  command: AplicationCommand,
  subcommand: ChatInputSubcommand,
) {
  case command {
    ChatInputGroup(_, subcommands) ->
      ChatInputGroup(..command, subcommands: [
        type_utils.B(subcommand),
        ..subcommands
      ])
    _ -> command
  }
}

pub fn user(signature: UserSignature, handler: UserHandler) {
  User(signature:, handler:)
}

pub fn message(signature: MessageSignature, handler: MessageHandler) {
  Message(signature:, handler:)
}

pub type ChatInputSubcommandGroup {
  ChatInputSubcommandGroup(
    signature: ChatInputSignature,
    subcommands: List(ChatInputSubcommand),
  )
}

pub fn subcommand_group(
  signature: ChatInputSignature,
  subcommands: List(ChatInputSubcommand),
) {
  ChatInputSubcommandGroup(signature:, subcommands:)
}

pub opaque type ChatInputSubcommand {
  ChatInputSubcommand(signature: ChatInputSignature, handler: ChatInputHandler)
}

pub fn subcommand(signature: ChatInputSignature, handler: ChatInputHandler) {
  ChatInputSubcommand(signature:, handler:)
}

pub type ChatInputSignature {
  ChatInputSignature
}

pub type ChatInputHandler =
  fn(Nil, Dict(String, ChatInputOptionValue)) -> String

pub type ChatInputOptionValue {
  StringValue(value: String)
  IntegerValue(value: Int)
  BooleanValue(value: Bool)
  UserValue(value: Int)
  ChannelValue(value: Int)
  RoleValue(value: Int)
  MentionableValue(value: Int)
  NumberValue(value: Float)
  AttachmentValue(value: Int)
}

pub type UserSignature {
  UserSignature
}

pub type UserHandler {
  UserHandler
}

pub type MessageSignature {
  MessageSignature
}

pub type MessageHandler {
  MessageHandler
}
