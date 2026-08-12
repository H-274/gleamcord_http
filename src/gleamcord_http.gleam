import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/list
import gleam/result
import gleam/string
import gleamcord_http/command_option.{type CommandOption}
import gleamcord_http/component

pub type Command {
  ChatCommand(
    def: CommandDefinition,
    options: List(CommandOption),
    run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
  )
  ChatCommandGroup(
    def: CommandDefinition,
    elements: Dict(String, ChatCommandGroupElement),
  )
  UserCommand(def: CommandDefinition, run: fn(Dynamic) -> CommandResponse)
  MessageCommand(def: CommandDefinition, run: fn(Dynamic) -> CommandResponse)
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

pub type CommandDefinition {
  CommandDefinition(
    name: String,
    description: String,
    default_member_permissions: String,
    integ_types: List(Int),
    contexts: List(Int),
    nsfw: Bool,
  )
}

pub fn simple_definition(name name: String, desc description: String) {
  CommandDefinition(
    name:,
    description:,
    default_member_permissions: "",
    integ_types: [1],
    contexts: [1],
    nsfw: False,
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

pub fn sub_command_group_dict(sub_commands: List(ChatSubCommand)) {
  list.map(sub_commands, fn(item) { #(item.name, item) })
  |> dict.from_list
}

pub fn group_sub_command(
  name name: String,
  desc description: String,
  opts options: List(CommandOption),
  run run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
) {
  ChatSubCommand(name:, description:, options:, run:)
  |> ChatGroupSubCommand
}

pub type ChatSubCommand {
  ChatSubCommand(
    name: String,
    description: String,
    options: List(CommandOption),
    run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
  )
}

pub fn sub_command(
  name name: String,
  desc description: String,
  opts options: List(CommandOption),
  run run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
) {
  ChatSubCommand(name:, description:, options:, run:)
}

pub type CommandResponse {
  CommandMessageResponse(Nil)
  CommandDeferredMessageResponse(fn() -> Nil)
  CommandModalResponse(Nil)
}

pub type MessageComponent {
  ButtonMessageComponent(
    btn: component.CustomButton,
    run: fn(Dynamic) -> MessageComponentResponse,
  )
  StringSelectMessageComponent(
    select: component.StringSelect,
    run: fn(Dynamic, List(String)) -> MessageComponentResponse,
  )
  UserSelectMessageComponent(
    select: component.UserSelect,
    run: fn(Dynamic, List(Dynamic)) -> MessageComponentResponse,
  )
  RoleSelectMessageComponent(
    select: component.RoleSelect,
    run: fn(Dynamic, List(Dynamic)) -> MessageComponentResponse,
  )
  MentionableSelectMessageComponent(
    select: component.MentionableSelect,
    run: fn(Dynamic, List(Dynamic)) -> MessageComponentResponse,
  )
  ChannelSelectMessageComponent(
    select: component.ChannelSelect,
    run: fn(Dynamic, List(Dynamic)) -> MessageComponentResponse,
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

pub type HandlingError(custom_error) {
  DecodingError(List(decode.DecodeError))
  NotFound(String)
}

fn commands_map(commands, map) {
  dict.from_list(list.flatten(list.map(commands, map)))
}

pub fn build_command_paths(
  commands: List(Command),
) -> Dict(String, fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse) {
  use command <- commands_map(commands)
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

pub fn handle_command_paths(
  interaction: Dynamic,
  command_paths: Dict(
    String,
    fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
  ),
) {
  use typ <- result.try(
    decode.run(interaction, decode.at(["data", "type"], decode.int))
    |> result.map_error(DecodingError),
  )
  let #(path, options) = #(
    get_command_path(interaction, accumulator: ""),
    get_command_options(interaction),
  )

  case typ {
    1 ->
      case dict.get(command_paths, path) {
        Ok(run) -> run(interaction, options) |> Ok
        Error(_) -> Error(NotFound("Chat Command"))
      }
    2 | 3 ->
      case dict.get(command_paths, path) {
        Ok(run) -> run(interaction, dict.new()) |> Ok
        Error(_) -> Error(NotFound("User Command or Message Command"))
      }
    _ -> Error(NotFound("Invalid type"))
  }
}

fn get_command_path(interaction: Dynamic, accumulator accumulator: String) {
  todo
}

fn get_command_options(interaction: Dynamic) {
  todo
}
