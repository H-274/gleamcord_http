import command/message_command
import command/text_command
import command/user_command

pub type Bot {
  Bot(
    auth: Auth,
    text_commands: List(text_command.Command(Bot)),
    user_commands: List(user_command.Command(Bot)),
    message_commands: List(message_command.Command(Bot)),
  )
}

pub fn new(auth auth: Auth) {
  Bot(auth:, text_commands: [], user_commands: [], message_commands: [])
}

pub fn text_commands(
  bot bot: Bot,
  text_commands text_commands: List(text_command.Command(Bot)),
) {
  Bot(..bot, text_commands:)
}

pub fn user_commands(
  bot bot: Bot,
  user_commands user_commands: List(user_command.Command(Bot)),
) {
  Bot(..bot, user_commands:)
}

pub fn message_commands(
  bot bot: Bot,
  message_command message_commands: List(message_command.Command(Bot)),
) {
  Bot(..bot, message_commands:)
}

pub type Auth {
  Auth(application_id: String, public_key: String, bot_token: String)
}
