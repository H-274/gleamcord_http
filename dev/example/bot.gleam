import bot
import example/command/message_command
import example/command/text_command
import example/command/user_command

pub fn bot_example() {
  let application_id = "your_application_id"
  let public_key = "your_public_key"
  let bot_token = "your_bot_token"

  let auth = bot.Auth(application_id:, public_key:, bot_token:)
  let _bot =
    bot.new(auth:)
    |> bot.text_commands([text_command.standalone_example()])
    |> bot.user_commands([user_command.example()])
    |> bot.message_commands([message_command.example()])
}
