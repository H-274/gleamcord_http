import bot
import examples/commands/application_command

pub fn main() {
  let _bot =
    bot.new("Pub Key", Nil)
    |> bot.add_chat_command(application_command.chat_input_command())
    |> bot.add_chat_command(application_command.chat_input_command_tree())
    |> bot.add_message_command(application_command.message_command())
    |> bot.add_user_command(application_command.user_command())
}
