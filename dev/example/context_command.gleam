import gleamcord_http
import gleamcord_http/discord

pub const report_message =
  gleamcord_http.MessageContextCommand(
    ..gleamcord_http.strict_guild_message_command,
    name: "report",
    handler: report_message_handler,
  )

fn report_message_handler(i: discord.CommandInteraction) {
  let assert discord.MessageCommandData(target_id:, ..) = i.data

  { "Successfully reported message: `" <> target_id <> "`" }
  |> gleamcord_http.basic_text_message
  |> gleamcord_http.CommandMessageResponse
}

pub const boop_user =
  gleamcord_http.UserContextCommand(
    ..gleamcord_http.strict_guild_user_command,
    name: "boop",
    handler: boop_user_handler,
  )

fn boop_user_handler(i: discord.CommandInteraction) {
  let assert discord.UserCommandData(target_id:, ..) = i.data

  { "<@" <> target_id <> ">" <> ", you've been booped" }
  |> gleamcord_http.basic_text_message
  |> gleamcord_http.CommandMessageResponse
}
