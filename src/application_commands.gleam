//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object

import gleam/dict.{type Dict}

/// TODO: Replace signature types with signature values
/// unless we want a builder to make the signatures
pub type AplicationCommand {
  ChatInput(signature: ChatInputSignature, handler: ChatInputHandler)
  ChatInputGroup(
    signature: ChatInputSignature,
    subcommands: List(#(ChatInputSignature, ChatInputHandler)),
  )
  User(signature: UserSignature, handler: UserHandler)
  Message(signature: MessageSignature, handler: MessageHandler)
}

pub type ChatInputSignature {
  ChatInputSignature
}

pub type ChatInputHandler =
  fn(String, Dict(String, ChatInputOptionValue)) -> String

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
