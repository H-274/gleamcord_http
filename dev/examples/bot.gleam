import examples/command
import examples/message_component
import examples/modal
import gleamcord_http/bot

pub fn bot() {
  let bot =
    bot.new(state: Nil)
    |> bot.add_commands([
      command.greet(),
      command.report(),
      command.colour(),
      command.group(),
    ])
    |> bot.add_components([
      message_component.button(),
      message_component.string_select(),
      message_component.user_select(),
      message_component.role_select(),
      message_component.mentionable_select(),
      message_component.channel_select(),
    ])
    |> bot.add_modal(modal.about_me())

  echo bot
}
