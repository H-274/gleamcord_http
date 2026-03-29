import application_command/application_command as command
import bot
import examples/application_command/application_command as example_commands

pub fn example() {
  let bot =
    bot.new(app_id: "", pub_key: "", token: "", state: Nil)
    |> bot.add_command(command.from_chat_input(example_commands.chat_input()))
    |> bot.add_command(
      command.from_chat_input_group(example_commands.chat_input_group()),
    )
    |> bot.add_command(command.from_user(example_commands.user_command()))
    |> bot.add_command(command.from_message(example_commands.message_command()))

  echo bot
}
