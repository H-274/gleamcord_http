import application_command/application_command as command
import bot
import examples/application_command/application_command as example_commands

pub fn example() {
  bot.new(app_id: "", pub_key: "", token: "", state: Nil)
  |> bot.add_commands([
    example_commands.chat_input() |> command.from_chat_input,
    example_commands.chat_input_group() |> command.from_chat_input_group,
    example_commands.user_command() |> command.from_user,
    example_commands.message_command() |> command.from_message,
  ])
}
