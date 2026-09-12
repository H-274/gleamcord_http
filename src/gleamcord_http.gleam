import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/list
import gleam/string
import gleamcord_http/component
import gleamcord_http/discord

pub type Command {
  ChatCommand(
    def: CommandDefinition,
    options: List(CommandOption),
    run: fn(discord.Interaction, Dict(String, discord.ValueOption)) ->
      CommandResponse,
  )
  ChatCommandGroup(
    def: CommandDefinition,
    elements: Dict(String, ChatCommandGroupElement),
  )
  UserCommand(
    def: CommandDefinition,
    run: fn(discord.Interaction) -> CommandResponse,
  )
  MessageCommand(
    def: CommandDefinition,
    run: fn(discord.Interaction) -> CommandResponse,
  )
}

pub fn command_dict(commands: List(Command)) -> Dict(String, Command) {
  list.map(commands, fn(item) { #(item.def.name, item) })
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

pub fn basic_command_definition(name name: String, desc description: String) {
  CommandDefinition(
    name:,
    description:,
    default_member_permissions: "",
    integ_types: [0],
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

pub fn group_elements(elements: List(ChatCommandGroupElement)) {
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
  run run: fn(discord.Interaction, Dict(String, discord.ValueOption)) ->
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
    run: fn(discord.Interaction, Dict(String, discord.ValueOption)) ->
      CommandResponse,
  )
}

pub fn sub_command(
  name name: String,
  desc description: String,
  opts options: List(CommandOption),
  run run: fn(discord.Interaction, Dict(String, discord.ValueOption)) ->
    CommandResponse,
) {
  ChatSubCommand(name:, description:, options:, run:)
}

pub fn sub_command_elements(sub_commands: List(ChatSubCommand)) {
  list.map(sub_commands, fn(item) { #(item.name, item) })
  |> dict.from_list
}

pub type CommandResponse {
  CommandMessageResponse(Nil)
  CommandDeferredMessageResponse(fn() -> Nil)
  CommandModalResponse(Nil)
}

pub fn generate_commands_map(
  commands: List(Command),
) -> Dict(
  String,
  fn(discord.Interaction, Dict(String, discord.ValueOption)) -> CommandResponse,
) {
  list.map(commands, fn(command) {
    case command {
      ChatCommand(def: command, run:, ..) -> [#(command.name, run)]
      ChatCommandGroup(def: group, elements:) ->
        list.map(dict.values(elements), fn(item) {
          case item {
            ChatGroupSubCommand(sub_command) -> [
              #(
                string.join([group.name, sub_command.name], "/"),
                sub_command.run,
              ),
            ]
            ChatSubCommandGroup(name: sub_group, sub_commands:, ..) ->
              list.map(dict.values(sub_commands), fn(item) {
                #(
                  string.join([group.name, sub_group, item.name], "/"),
                  item.run,
                )
              })
          }
        })
        |> list.flatten

      UserCommand(def: command, run:) -> [#(command.name, fn(i, _) { run(i) })]
      MessageCommand(def: command, run:) -> [
        #(command.name, fn(i, _) { run(i) }),
      ]
    }
  })
  |> list.flatten
  |> dict.from_list
}

pub fn handle_mapped_command(
  interaction: discord.Interaction,
  data: discord.CommandData,
  commands_map: Dict(
    String,
    fn(discord.Interaction, Dict(String, discord.ValueOption)) ->
      CommandResponse,
  ),
) {
  let #(path, options) = extract_command_path_options(data)

  case dict.get(commands_map, path) {
    Ok(run) -> run(interaction, options) |> Ok
    Error(_) -> Error(NotFound("Command with path: " <> path))
  }
}

fn extract_command_path_options(
  data: discord.CommandData,
) -> #(String, Dict(String, discord.ValueOption)) {
  case data {
    discord.UserCommandData(..) | discord.MessageCommandData(..) -> #(
      data.name,
      dict.new(),
    )
    discord.ChatCommandData(name:, options:, ..) -> {
      case options {
        discord.ValueOptions(options) -> #(name, options)
        discord.SubCommandOption(sub) -> #(
          string.join([name, sub.name], "/"),
          sub.options,
        )
        discord.SubCommandGroupOption(name: sub_group, sub_command: sub) -> #(
          string.join([name, sub_group, sub.name], "/"),
          sub.options,
        )
      }
    }
  }
}

pub fn handle_command_dict(
  interaction: discord.Interaction,
  data: discord.CommandData,
  commands: Dict(String, Command),
) -> Result(CommandResponse, HandlingError) {
  case data, dict.get(commands, data.name) {
    discord.UserCommandData(..), Ok(UserCommand(run:, ..)) ->
      Ok(run(interaction))
    discord.MessageCommandData(..), Ok(MessageCommand(run:, ..)) ->
      Ok(run(interaction))

    discord.ChatCommandData(options:, ..), Ok(ChatCommand(run:, ..)) ->
      case options {
        discord.ValueOptions(options) -> Ok(run(interaction, options))
        _ -> Error(NotFound("Value options for: " <> data.name))
      }

    discord.ChatCommandData(options:, ..), Ok(ChatCommandGroup(elements:, ..))
    ->
      case options {
        discord.SubCommandOption(sub_opt) ->
          case dict.get(elements, sub_opt.name) {
            Ok(ChatGroupSubCommand(sub)) ->
              Ok(sub.run(interaction, sub_opt.options))
            _ -> Error(NotFound("Sub command: " <> sub_opt.name))
          }
        discord.SubCommandGroupOption(name: group_name, sub_command:) ->
          case dict.get(elements, group_name) {
            Ok(ChatSubCommandGroup(sub_commands:, ..)) ->
              case dict.get(sub_commands, sub_command.name) {
                Ok(ChatSubCommand(run:, ..)) ->
                  Ok(run(interaction, sub_command.options))
                _ -> Error(NotFound("Group sub command: " <> sub_command.name))
              }
            _ -> Error(NotFound("Sub command group: " <> group_name))
          }
        discord.ValueOptions(_) ->
          panic as "Command group should not have value options"
      }
    _, _ -> Error(NotFound("Command matching: " <> data.name))
  }
}

// TODO review autocomplete run signature
pub fn build_autocomplete_map(
  commands: List(Command),
) -> Dict(String, fn(discord.Interaction, Dynamic) -> Dynamic) {
  todo
}

// TODO
pub fn handle_autocomplete_map(
  interaction: discord.Interaction,
  data: discord.CommandData,
  autocomplete_map: Dict(a, b),
) {
  todo
}

pub type CommandOption {
  StringOption(
    name: String,
    description: String,
    min_len: Int,
    max_len: Int,
    required: Bool,
  )
  StringChoiceOption(
    name: String,
    description: String,
    choices: List(#(String, String)),
    required: Bool,
  )
  StringAutocompleteOption(
    name: String,
    description: String,
    min_len: Int,
    max_len: Int,
    required: Bool,
    run: fn(discord.Interaction, String) -> List(#(String, String)),
  )
  IntegerOption(
    name: String,
    description: String,
    min_value: Int,
    max_value: Int,
    required: Bool,
  )
  IntegerChoiceOption(
    name: String,
    description: String,
    choices: List(#(String, Int)),
    required: Bool,
  )
  IntegerAutocompleteOption(
    name: String,
    description: String,
    min_value: Int,
    max_value: Int,
    required: Bool,
    run: fn(discord.Interaction, Int) -> List(#(String, Int)),
  )
  BoooleanOption(name: String, description: String, required: Bool)
  UserOption(name: String, description: String, required: Bool)
  ChannelOption(
    name: String,
    description: String,
    channel_types: List(Int),
    required: Bool,
  )
  RoleOption(name: String, description: String, required: Bool)
  MentionableOption(name: String, description: String, required: Bool)
  NumberOption(
    name: String,
    description: String,
    min_value: Float,
    max_value: Float,
    required: Bool,
  )
  NumberChoiceOption(
    name: String,
    description: String,
    choices: List(#(String, Float)),
    required: Bool,
  )
  NumberAutocompleteOption(
    name: String,
    description: String,
    min_value: Float,
    max_value: Float,
    required: Bool,
    run: fn(discord.Interaction, Float) -> List(#(String, Float)),
  )
  AttachmentOption(name: String, description: String, required: Bool)
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
