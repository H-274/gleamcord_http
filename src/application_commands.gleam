//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object

import gleam/dynamic

/// TODO: Replace signature types with signature values
/// unless we want a builder to make the signatures
pub type AplicationCommand {
  ChatInput(
    signature: ChatInputSignature,
    handler_or_subcommands: ChatInputHandler,
  )
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
  fn(String, dynamic.Dynamic) -> String

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
