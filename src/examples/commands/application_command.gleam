import application_command
import application_command_param as param
import discord/entities/choice
import discord/entities/context.{Guild}
import discord/entities/integration_type.{GuildInstall}
import gleam/list
import gleam/result
import gleam/string
import response

const cities = ["New York", "New Mexico", "Tokyo", "Toronto"]

pub fn simple_command() -> application_command.ApplicationCommand(_) {
  let def =
    application_command.new_definition(
      name: "Hello",
      desc: "world",
      integs: [GuildInstall],
      contexts: [Guild],
    )
  let city_param = {
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
    |> response.StringChoices()
  }

  let params = [city_param]

  use _i, params, _bot <- application_command.chat_input_command(def, params)
  let _city = result.unwrap(param.get_string(params:, name: "city"), "world")

  todo as "Command logic"
}

pub fn command_tree() -> application_command.ApplicationCommand(_) {
  let def =
    application_command.new_definition(
      name: "info",
      desc: "give information about a given object",
      integs: [GuildInstall],
      contexts: [Guild],
    )
  let user_leaf = {
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
    let assert Ok(_user) =
      param.get_resolved_user(params:, name: "user", resolved: todo)

    todo as "Command logic"
  }
  let channel_leaf = {
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
    let assert Ok(_channel) =
      param.get_resolved_channel(params:, name: "channel", resolved: todo)

    todo as "Command logic"
  }
  let nested_node = fn(commands) {
    application_command.new_node_definition(
      name: "nested",
      desc: "nesting some subcommands",
    )
    |> application_command.tree_node(commands:)
  }

  let commands = [
    user_leaf,
    channel_leaf,
    nested_node([user_leaf, channel_leaf]),
  ]

  application_command.chat_input_tree_commands(def:, commands:)
}
