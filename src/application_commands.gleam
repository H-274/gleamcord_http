//// Based on:
//// - https://discord.com/developers/docs/interactions/application-commands#application-command-object

import gleam/dynamic
import internal/type_utils

pub opaque type AplicationCommand {
  ChatInputCommand(
    signature: ChatInputSignature,
    handler_or_subcommands: type_utils.Or(
      ChatInputHandler,
      List(#(ChatInputSignature, ChatInputHandler)),
    ),
  )
  UserCommand(signature: UserSignature, handler: UserHandler)
  MessageCommand(signature: MessageSignature, handler: MessageHandler)
}

pub fn chat_input(signature: ChatInputSignature, handler: ChatInputHandler) {
  ChatInputCommand(signature:, handler_or_subcommands: type_utils.A(handler))
}

pub fn chat_input_group(
  signature: ChatInputSignature,
  subcommands: List(#(ChatInputSignature, ChatInputHandler)),
) {
  ChatInputCommand(
    signature:,
    handler_or_subcommands: type_utils.B(subcommands),
  )
}

pub fn user(signature: UserSignature, handler: UserHandler) {
  UserCommand(signature:, handler:)
}

pub fn message(signature: MessageSignature, handler: MessageHandler) {
  MessageCommand(signature:, handler:)
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
