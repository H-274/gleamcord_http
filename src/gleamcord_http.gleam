import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/list
import gleam/result
import gleam/string
import gleamcord_http/command_option.{type CommandOption}
import gleamcord_http/component
import gleamcord_http/discord

pub type Command {
  ChatCommand(
    def: CommandDefinition,
    options: List(CommandOption),
    run: fn(discord.CommandInteraction, Dict(String, Dynamic)) ->
      CommandResponse,
  )
  ChatCommandGroup(
    def: CommandDefinition,
    elements: Dict(String, ChatCommandGroupElement),
  )
  UserCommand(
    def: CommandDefinition,
    run: fn(discord.CommandInteraction) -> CommandResponse,
  )
  MessageCommand(
    def: CommandDefinition,
    run: fn(discord.CommandInteraction) -> CommandResponse,
  )
}

pub fn command_dict(commands: List(Command)) -> Dict(String, Command) {
  list.map(commands, fn(item) { #(item.def.name, item) })
  |> dict.from_list
}

pub type CommandDefinition {
  GuildCommandDefinition(
    name: String,
    description: String,
    default_member_permissions: String,
    nsfw: Bool,
  )
  DMCommandDefinition(
    name: String,
    description: String,
    default_member_permissions: String,
    nsfw: Bool,
  )
  CommandDefinition(
    name: String,
    description: String,
    default_member_permissions: String,
    integ_types: List(Int),
    contexts: List(Int),
    nsfw: Bool,
  )
}

pub type ChatCommandGroupElement {
  ChatSubCommandGroup(
    name: String,
    description: String,
    sub_commands: Dict(String, ChatSubCommand),
  )
  ChatGroupSubCommand(ChatSubCommand)
}

pub fn command_group_element_dict(elements: List(ChatCommandGroupElement)) {
  list.map(elements, fn(item) {
    case item {
      ChatSubCommandGroup(name:, ..) -> #(name, item)
      ChatGroupSubCommand(sub_command) -> #(sub_command.name, item)
    }
  })
  |> dict.from_list
}

pub fn group_sub_command(
  name name: String,
  desc description: String,
  opts options: List(CommandOption),
  run run: fn(discord.CommandInteraction, Dict(String, Dynamic)) ->
    CommandResponse,
) {
  ChatSubCommand(name:, description:, options:, run:)
  |> ChatGroupSubCommand
}

pub type ChatSubCommand {
  ChatSubCommand(
    name: String,
    description: String,
    options: List(CommandOption),
    run: fn(discord.CommandInteraction, Dict(String, Dynamic)) ->
      CommandResponse,
  )
}

pub fn sub_command(
  name name: String,
  desc description: String,
  opts options: List(CommandOption),
  run run: fn(discord.CommandInteraction, Dict(String, Dynamic)) ->
    CommandResponse,
) {
  ChatSubCommand(name:, description:, options:, run:)
}

pub fn sub_command_dict(sub_commands: List(ChatSubCommand)) {
  list.map(sub_commands, fn(item) { #(item.name, item) })
  |> dict.from_list
}

pub type CommandResponse {
  CommandMessageResponse(Nil)
  CommandDeferredMessageResponse(fn() -> Nil)
  CommandModalResponse(Nil)
}

fn command_maps(commands, map) {
  dict.from_list(list.flatten(list.map(commands, map)))
}

pub fn build_command_maps(
  commands: List(Command),
) -> Dict(
  String,
  fn(discord.CommandInteraction, Dict(String, Dynamic)) -> CommandResponse,
) {
  use command <- command_maps(commands)
  case command {
    ChatCommand(def: command, run:, ..) -> [#(command.name, run)]
    ChatCommandGroup(def: group, elements:) ->
      list.map(dict.values(elements), fn(item) {
        case item {
          ChatGroupSubCommand(sub_command) -> [
            #(string.join([group.name, sub_command.name], "/"), sub_command.run),
          ]
          ChatSubCommandGroup(name: sub_group, sub_commands:, ..) ->
            list.map(dict.values(sub_commands), fn(item) {
              #(string.join([group.name, sub_group, item.name], "/"), item.run)
            })
        }
      })
      |> list.flatten

    UserCommand(def: command, run:) -> [#(command.name, fn(i, _) { run(i) })]
    MessageCommand(def: command, run:) -> [#(command.name, fn(i, _) { run(i) })]
  }
}

pub fn handle_command_maps(
  interaction: discord.CommandInteraction,
  command_maps: Dict(
    String,
    fn(discord.CommandInteraction, Dict(String, Dynamic)) -> CommandResponse,
  ),
) {
  let assert Ok(#(path, options)) = get_command_data(interaction)

  case dict.get(command_maps, path) {
    Ok(run) -> run(interaction, options) |> Ok
    Error(_) -> Error(NotFound("Chat Command"))
  }
}

fn get_command_data(
  interaction: discord.CommandInteraction,
) -> Result(#(String, Dict(String, Dynamic)), HandlingError) {
  use typ <- result.try(
    decode.run(todo, decode.at(["data", "type"], decode.int))
    |> result.map_error(DecodingError),
  )

  case typ {
    1 -> todo
    2 | 3 ->
      decode.run(todo, decode.at(["name"], decode.string))
      |> result.map_error(DecodingError)
      |> result.map(fn(path) { #(path, dict.new()) })

    _ -> Error(NotFound("Path"))
  }
}

pub fn handle_command_dict(
  interaction: discord.CommandInteraction,
  commands: Dict(String, Command),
) {
  todo
}

// TODO review autocomplete run signature
pub fn build_autocomplete_map(
  commands: List(Command),
) -> Dict(String, fn(discord.CommandInteraction, Dynamic) -> Dynamic) {
  todo
}

// TODO
pub fn handle_autocomplete_map(
  interaction: discord.CommandInteraction,
  autocomplete_map: Dict(a, b),
) {
  todo
}

pub type MessageComponent {
  ButtonMessageComponent(
    btn: component.CustomButton,
    run: fn(discord.Interaction) -> MessageComponentResponse,
  )
  StringSelectMessageComponent(
    select: component.StringSelect,
    run: fn(discord.Interaction, List(String)) -> MessageComponentResponse,
  )
  UserSelectMessageComponent(
    select: component.UserSelect,
    run: fn(discord.Interaction, List(Dynamic)) -> MessageComponentResponse,
  )
  RoleSelectMessageComponent(
    select: component.RoleSelect,
    run: fn(discord.Interaction, List(Dynamic)) -> MessageComponentResponse,
  )
  MentionableSelectMessageComponent(
    select: component.MentionableSelect,
    run: fn(discord.Interaction, List(Dynamic)) -> MessageComponentResponse,
  )
  ChannelSelectMessageComponent(
    select: component.ChannelSelect,
    run: fn(discord.Interaction, List(Dynamic)) -> MessageComponentResponse,
  )
}

pub type MessageComponentResponse {
  MessageComponentMessageResponse(Nil)
  MessageComponentDeferredMessageResponse(fn() -> Nil)
  MessageComponentMessageUpdate(Nil)
  MessageComponentDeferredMessageUpdate(fn() -> Nil)
  MessageComponentModalResponse(Nil)
}

pub type Modal {
  Modal(
    custom_id: String,
    title: String,
    components: List(component.Label),
    run: fn(Dynamic, Dict(String, Dynamic)) -> ModalResponse,
  )
}

pub type ModalResponse {
  ModalMessageResponse(Nil)
  ModalDeferredMessageResponse(fn() -> Nil)
  ModalMessageUpdate(Nil)
  ModalDeferredMessageUpdate(fn() -> Nil)
}

pub type HandlingError {
  DecodingError(List(decode.DecodeError))
  NotFound(String)
}
