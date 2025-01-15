import bot
import credentials.{Credentials}
import gleam/erlang/process

pub fn main() {
  let assert Ok(_) =
    Credentials("app_id", "pub_key", "token")
    |> bot.Configuration(context: Nil, commands: [], components: [])
    |> bot.start(8080)

  process.sleep_forever()
}
