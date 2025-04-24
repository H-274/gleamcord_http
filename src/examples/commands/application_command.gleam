import application_command
import application_command_param as param
import discord/entities/choice
import discord/entities/context.{Guild}
import discord/entities/integration_type.{GuildInstall}
import discord/entities/message
import gleam/erlang/process
import gleam/list
import gleam/result
import gleam/string

const cities = ["New York", "New Mexico", "Tokyo", "Toronto"]

pub fn simple_command() -> application_command.ApplicationCommand(_) {
  let def =
    application_command.new_definition(
      name: "Hello",
      desc: "world",
      integs: [GuildInstall],
      contexts: [Guild],
    )

  let params = [city_param()]

  use i, params, bot <- application_command.chat_input_command(def:, params:)
  let city = result.unwrap(param.get_string(params:, name: "city"), "world")

  use <- application_command.deferred_message_reply(i, bot)
  process.sleep(1000)

  message.Message("Hello " <> city)
}

fn city_param() {
  let name = "city"
  let builder =
    param.base(name:, desc: "city to greet")
    |> param.required(False)
    |> param.string_builder()
    |> param.string_min_length(2)
    |> param.string_min_length(25)

  use _i, params, _bot <- param.string_with_autocomplete(builder)
  let assert Ok(input) = param.get_string(params:, name:)

  list.filter(cities, string.starts_with(_, input))
  |> list.map(fn(city) { choice.new(city, city) })
  |> param.StringChoices
}

pub fn command_tree() -> application_command.ApplicationCommand(_) {
  let def =
    application_command.new_definition(
      name: "info",
      desc: "give information about a given object",
      integs: [GuildInstall],
      contexts: [Guild],
    )

  let commands = [user_leaf(), channel_leaf(), nested_node()]

  application_command.chat_input_tree_commands(def:, commands:)
}

fn user_leaf() {
  let def =
    application_command.new_node_definition(
      name: "user",
      desc: "information about a given user",
    )
  let user_param = {
    param.base(name: "user", desc: "user to get info from")
    |> param.required(True)
    |> param.user_def()
  }

  let params = [user_param]

  use _i, params, _bot <- application_command.tree_leaf(def:, params:)
  let resolved = todo as "i.data.resolved"
  let assert Ok(_user) =
    param.get_resolved_user(params:, name: "user", resolved:)

  todo as "Command logic"
}

fn channel_leaf() {
  let def =
    application_command.new_node_definition(
      name: "channel",
      desc: "information about a given channel",
    )

  let channel_param = {
    param.base(name: "channel", desc: "channel to get info from")
    |> param.required(True)
    |> param.channel_def()
  }

  let params = [channel_param]

  use _i, params, _bot <- application_command.tree_leaf(def:, params:)
  let resolved = todo as "i.data.resolved"
  let assert Ok(_channel) =
    param.get_resolved_channel(params:, name: "channel", resolved:)

  todo as "Command logic"
}

fn nested_node() {
  let def =
    application_command.new_node_definition(
      name: "nested",
      desc: "nesting some subcommands",
    )

  let commands = [user_leaf(), channel_leaf()]

  application_command.tree_node(def:, commands:)
}
