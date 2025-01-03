import command/chat_input
import command/message
import command/user

pub type Command(ctx) {
  ChatInput(chat_input.Command(ctx))
  User(user.Command(ctx))
  Message(message.Command(ctx))
}
