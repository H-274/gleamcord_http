import gleam/dict
import gleam/dynamic/decode
import gleam/result
import gleamcord_http
import gleamcord_http/discord

pub const greet_command =
  gleamcord_http.SlashCommand(
    ..gleamcord_http.strict_guild_slash_command,
    name: "greet",
    description: "greets a user",
    options: [greet_target],
    handler: greet_command_handler,
  )

pub const greet_target =
  gleamcord_http.UserOption(
    name: "target",
    description: "target to greet",
    required: True,
  )

fn greet_command_handler(i: discord.CommandInteraction, o) {
  let assert Ok(user_snowflake) = discord.user_value(o, greet_target.name)
  let username = case dict.get(i.data.resolved.members, user_snowflake) {
    Ok(member) ->
      decode.run(member, decode.at(["username"], decode.string))
      |> result.unwrap("Unknown")
    _ -> "Unknown"
  }

  gleamcord_http.CommandMessageResponse("Hello " <> username)
}
