import bot.{Bot}
import example/command/message_command
import example/command/text_command
import example/command/user_command
import example/full/app/router
import gleam/erlang/process
import mist
import wisp
import wisp/wisp_mist

pub fn full_example() {
  let application_id = "your_application_id"
  let public_key = "your_public_key"
  let bot_token = "your_bot_token"

  let secret_key_base = wisp.random_string(64)

  let auth = bot.Auth(application_id:, public_key:, bot_token:)
  let bot =
    Bot(
      auth:,
      text_commands: [text_command.standalone_example()],
      user_commands: [user_command.example()],
      message_commands: [message_command.example()],
    )

  let assert Ok(_) =
    router.handle_request(_, bot, Nil)
    |> wisp_mist.handler(secret_key_base)
    |> mist.new()
    |> mist.port(8000)
    |> mist.start()

  process.sleep_forever()
}
