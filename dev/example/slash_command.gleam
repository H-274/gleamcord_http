import gleam/dict
import gleam/dynamic/decode
import gleam/result
import gleamcord_http
import gleamcord_http/discord

pub const greet_target =
  gleamcord_http.UserOption(
    name: "target",
    description: "target to greet",
    required: True,
  )

pub fn greet_command() {
  use i, o <- gleamcord_http.strict_guild_slash_command(
    "greet",
    "greets a user",
    [greet_target],
  )

  let assert Ok(user_snowflake) = discord.user_value(o, greet_target.name)
  let username = case dict.get(i.data.resolved.members, user_snowflake) {
    Ok(member) ->
      decode.run(member, decode.at(["username"], decode.string))
      |> result.unwrap("Unknown")
    _ -> "Unknown"
  }

  gleamcord_http.basic_text_message("Hello " <> username)
  |> gleamcord_http.CommandMessageResponse
}
