import command/chat_input_command.{type ChatInputCommand}
import command/message_command.{type MessageCommand}
import command/user_command.{type UserCommand}

pub type Command(ctx) {
  ChatInput(ChatInputCommand(ctx))
  User(UserCommand(ctx))
  Message(MessageCommand(ctx))
}
