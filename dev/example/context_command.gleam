import gleamcord_http
import gleamcord_http/discord

pub fn report_message() {
  use i <- gleamcord_http.strict_guild_message_command("report")
  let assert discord.MessageCommandData(target_id:, ..) = i.data

  { "Successfully reported message: `" <> target_id <> "`" }
  |> gleamcord_http.basic_text_message
  |> gleamcord_http.CommandMessageResponse
}

pub fn boop_user_handler() {
  use i <- gleamcord_http.strict_guild_user_command("boop")
  let assert discord.UserCommandData(target_id:, ..) = i.data

  { "<@" <> target_id <> ">" <> ", you've been booped" }
  |> gleamcord_http.basic_text_message
  |> gleamcord_http.CommandMessageResponse
}
