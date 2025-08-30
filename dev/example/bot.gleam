import bot
import example/command/message_command
import example/command/text_command
import example/command/user_command

const application_id = "your_application_id"

const public_key = "your_public_key"

const bot_token = "your_bot_token"

pub fn bot() {
  let auth = bot.Auth(application_id:, public_key:, bot_token:)
  let _bot =
    bot.new(auth:)
    |> bot.text_commands([text_command.standalone()])
    |> bot.user_commands([user_command.example()])
    |> bot.message_commands([message_command.example()])
}
