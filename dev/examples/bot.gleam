import application_command/application_command as command
import bot
import examples/application_command/chat_input as chat_input_command
import examples/application_command/chat_input_group as chat_input_group_command
import examples/application_command/message_command
import examples/application_command/user_command

pub fn example() {
  bot.new(app_id: "", pub_key: "", token: "", state: Nil)
  |> bot.add_commands([
    chat_input_command.ping() |> command.from_chat_input,
    chat_input_command.slow() |> command.from_chat_input,
    chat_input_command.greeting() |> command.from_chat_input,
    chat_input_group_command.favourite() |> command.from_chat_input_group,
    user_command.promote() |> command.from_user,
    message_command.report() |> command.from_message,
  ])
}
