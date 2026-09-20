import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/json.{type Json}
import gleam/list
import gleam/result
import gleam/string
import gleamcord_http/component
import gleamcord_http/discord

pub type Command {
  ChatCommand(
    def: CommandDefinition,
    options: List(CommandOption),
    run: fn(
      discord.Interaction,
      discord.CommandData,
      Dict(String, discord.ValueOption),
    ) -> CommandResponse,
  )
  ChatCommandGroup(
    def: CommandDefinition,
    elements: Dict(String, ChatCommandGroupElement),
  )
  UserCommand(
    def: CommandDefinition,
    run: fn(discord.Interaction, discord.CommandData) -> CommandResponse,
  )
  MessageCommand(
    def: CommandDefinition,
    run: fn(discord.Interaction, discord.CommandData) -> CommandResponse,
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
  SubCommandGroupElement(
    name: String,
    description: String,
    sub_commands: Dict(String, ChatSubCommand),
  )
  SubCommandElement(ChatSubCommand)
}

pub fn group_elements(elements: List(ChatCommandGroupElement)) {
  list.map(elements, fn(item) {
    case item {
      SubCommandGroupElement(name:, ..) -> #(name, item)
      SubCommandElement(sub_command) -> #(sub_command.name, item)
    }
  })
  |> dict.from_list
}

pub fn group_sub_command(
  name name: String,
  desc description: String,
  opts options: List(CommandOption),
  run run: fn(
    discord.Interaction,
    discord.CommandData,
    Dict(String, discord.ValueOption),
  ) -> CommandResponse,
) {
  ChatSubCommand(name:, description:, options:, run:)
  |> SubCommandElement
}

pub type ChatSubCommand {
  ChatSubCommand(
    name: String,
    description: String,
    options: List(CommandOption),
    run: fn(
      discord.Interaction,
      discord.CommandData,
      Dict(String, discord.ValueOption),
    ) -> CommandResponse,
  )
}

pub fn sub_command(
  name name: String,
  desc description: String,
  opts options: List(CommandOption),
  run run: fn(
    discord.Interaction,
    discord.CommandData,
    Dict(String, discord.ValueOption),
  ) -> CommandResponse,
) {
  ChatSubCommand(name:, description:, options:, run:)
}

pub fn sub_commands(sub_commands: List(ChatSubCommand)) {
  list.map(sub_commands, fn(item) { #(item.name, item) })
  |> dict.from_list
}

pub type NewMessage {
  NewMessage
  NewComponentMessage
}

pub fn new_message_json(new_message: NewMessage) -> Json {
  todo
}

pub type CommandResponse {
  CommandMessageResponse(NewMessage)
  CommandDeferredMessageResponse(fn() -> NewMessage)
  CommandModalResponse(Modal)
}

pub fn generate_commands_map(
  commands: List(Command),
) -> Dict(
  String,
  fn(
    discord.Interaction,
    discord.CommandData,
    Dict(String, discord.ValueOption),
  ) -> CommandResponse,
) {
  list.map(commands, fn(command) {
    case command {
      ChatCommand(def: command, run:, ..) -> [#(command.name, run)]
      ChatCommandGroup(def: group, elements:) ->
        list.map(dict.values(elements), fn(item) {
          case item {
            SubCommandElement(sub_command) -> [
              #(
                string.join([group.name, sub_command.name], "/"),
                sub_command.run,
              ),
            ]
            SubCommandGroupElement(name: sub_group, sub_commands:, ..) ->
              list.map(dict.values(sub_commands), fn(item) {
                #(
                  string.join([group.name, sub_group, item.name], "/"),
                  item.run,
                )
              })
          }
        })
        |> list.flatten

      UserCommand(def: command, run:) | MessageCommand(def: command, run:) -> [
        #(command.name, fn(i, d, _) { run(i, d) }),
      ]
    }
  })
  |> list.flatten
  |> dict.from_list
}

pub fn handle_mapped_command(
  commands_map: Dict(
    String,
    fn(
      discord.Interaction,
      discord.CommandData,
      Dict(String, discord.ValueOption),
    ) -> CommandResponse,
  ),
  interaction: discord.Interaction,
  data: discord.CommandData,
) {
  let #(path, options) = extract_command_path_options(data)

  case dict.get(commands_map, path) {
    Ok(run) -> run(interaction, data, options) |> Ok
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
  commands: Dict(String, Command),
  interaction: discord.Interaction,
  data: discord.CommandData,
) -> Result(CommandResponse, HandlingError) {
  case data, dict.get(commands, data.name) {
    discord.UserCommandData(..), Ok(UserCommand(run:, ..))
    | discord.MessageCommandData(..), Ok(MessageCommand(run:, ..))
    -> Ok(run(interaction, data))

    discord.ChatCommandData(options:, ..), Ok(ChatCommand(run:, ..)) ->
      case options {
        discord.ValueOptions(options) -> Ok(run(interaction, data, options))
        _ -> Error(NotFound("Value options for: " <> data.name))
      }

    discord.ChatCommandData(options:, ..), Ok(ChatCommandGroup(elements:, ..))
    ->
      case options {
        discord.SubCommandOption(sub_opt) ->
          case dict.get(elements, sub_opt.name) {
            Ok(SubCommandElement(sub)) ->
              Ok(sub.run(interaction, data, sub_opt.options))
            _ -> Error(NotFound("Sub command: " <> sub_opt.name))
          }
        discord.SubCommandGroupOption(name: group_name, sub_command:) ->
          case dict.get(elements, group_name) {
            Ok(SubCommandGroupElement(sub_commands:, ..)) ->
              case dict.get(sub_commands, sub_command.name) {
                Ok(ChatSubCommand(run:, ..)) ->
                  Ok(run(interaction, data, sub_command.options))
                _ -> Error(NotFound("Group sub command: " <> sub_command.name))
              }
            _ -> Error(NotFound("Sub command group: " <> group_name))
          }
        discord.ValueOptions(_) ->
          panic as "Command group should not have value options"
      }
    _, _ -> Error(NotFound("Command: " <> data.name))
  }
}

// TODO review autocomplete run signature
pub fn build_autocomplete_map(
  commands: List(Command),
) -> Dict(String, fn(discord.Interaction, Dynamic) -> Dynamic) {
  todo
}

pub fn handle_mapped_autocomplete(
  autocomplete_map: Dict(String, AutocompleteRun),
  interaction: discord.Interaction,
  data: discord.CommandData,
) {
  use #(path, option) <- result.try(extract_autocomplete_path(data))

  case dict.get(autocomplete_map, path), option {
    Ok(StringAutocomplete(run)), discord.StringOption(value:, ..) ->
      StringAutocompleteResponse(run(interaction, data, value)) |> Ok
    Ok(IntegerAutocomplete(run)), discord.IntegerOption(value:, ..) ->
      IntegerAutocompleteResponse(run(interaction, data, value)) |> Ok
    Ok(NumberAutocomplete(run)), discord.NumberOption(value:, ..) ->
      NumberAutocompleteResponse(run(interaction, data, value)) |> Ok
    _, _ -> Error(NotFound("Autocomplete with path: " <> path))
  }
}

fn extract_autocomplete_path(data) {
  let #(path, options) = extract_command_path_options(data)
  case discord.options_find_focused(options) {
    Ok(focused_option) ->
      Ok(#(path <> "/" <> focused_option.name, focused_option))
    _ -> Error(NotFound("Focused option"))
  }
}

pub fn handle_autocomplete_dict(
  commands: Dict(String, Command),
  interaction: discord.Interaction,
  data: discord.CommandData,
) {
  case data, dict.get(commands, data.name) {
    discord.ChatCommandData(options: discord.ValueOptions(options), ..),
      Ok(ChatCommand(options: option_defs, ..))
    -> run_option_autocomplete(option_defs, options, interaction, data)
    discord.ChatCommandData(options: discord.SubCommandOption(sub_command), ..),
      Ok(ChatCommandGroup(elements:, ..))
    ->
      case dict.get(elements, sub_command.name) {
        Ok(SubCommandElement(def)) ->
          run_option_autocomplete(
            def.options,
            sub_command.options,
            interaction,
            data,
          )
        _ -> Error(NotFound("Sub command: " <> sub_command.name))
      }
    discord.ChatCommandData(
      options: discord.SubCommandGroupOption(name:, sub_command:),
      ..,
    ),
      Ok(ChatCommandGroup(elements:, ..))
    -> {
      case dict.get(elements, name) {
        Ok(SubCommandGroupElement(sub_commands:, ..)) ->
          case dict.get(sub_commands, sub_command.name) {
            Ok(ChatSubCommand(options:, ..)) ->
              run_option_autocomplete(
                options,
                sub_command.options,
                interaction,
                data,
              )
            _ -> Error(NotFound("Sub command: " <> sub_command.name))
          }
        _ -> Error(NotFound("Sub command group: " <> sub_command.name))
      }
    }
    _, _ -> Error(NotFound("Command: " <> data.name))
  }
}

fn run_option_autocomplete(
  option_defs: List(CommandOption),
  options: Dict(String, discord.ValueOption),
  interaction: discord.Interaction,
  data: discord.CommandData,
) {
  use focused_option <- result.try(
    discord.options_find_focused(options)
    |> result.replace_error(NotFound("Focused option")),
  )
  case
    list.find(option_defs, fn(o) { o.name == focused_option.name }),
    focused_option
  {
    Ok(StringAutocompleteOption(run:, ..)), discord.StringOption(value:, ..) ->
      StringAutocompleteResponse(run(interaction, data, value)) |> Ok
    Ok(IntegerAutocompleteOption(run:, ..)), discord.IntegerOption(value:, ..)
    -> IntegerAutocompleteResponse(run(interaction, data, value)) |> Ok
    Ok(NumberAutocompleteOption(run:, ..)), discord.NumberOption(value:, ..) ->
      NumberAutocompleteResponse(run(interaction, data, value)) |> Ok
    _, _ -> Error(NotFound("Focused option definition"))
  }
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
    run: StringAutocomplete,
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
    run: IntegerAutocomplete,
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
    run: NumberAutocomplete,
  )
  AttachmentOption(name: String, description: String, required: Bool)
}

pub fn command_options(options: List(CommandOption)) {
  list.map(options, fn(o) { #(o.name, o) })
  |> dict.from_list
}

pub type AutocompleteRun {
  StringAutocomplete(StringAutocomplete)
  IntegerAutocomplete(IntegerAutocomplete)
  NumberAutocomplete(NumberAutocomplete)
}

pub type StringAutocomplete =
  fn(discord.Interaction, discord.CommandData, String) ->
    List(#(String, String))

pub type IntegerAutocomplete =
  fn(discord.Interaction, discord.CommandData, Int) -> List(#(String, Int))

pub type NumberAutocomplete =
  fn(discord.Interaction, discord.CommandData, Float) -> List(#(String, Float))

pub type AutocompleteResponse {
  StringAutocompleteResponse(List(#(String, String)))
  IntegerAutocompleteResponse(List(#(String, Int)))
  NumberAutocompleteResponse(List(#(String, Float)))
}

pub type MessageComponent {
  ButtonMessageComponent(
    btn: component.CustomButton,
    run: fn(discord.Interaction, discord.ComponentData) ->
      MessageComponentResponse,
  )
  StringSelectMessageComponent(
    select: component.StringSelect,
    run: fn(discord.Interaction, discord.ComponentData, List(String)) ->
      MessageComponentResponse,
  )
  UserSelectMessageComponent(
    select: component.UserSelect,
    run: fn(discord.Interaction, discord.ComponentData, List(Dynamic)) ->
      MessageComponentResponse,
  )
  RoleSelectMessageComponent(
    select: component.RoleSelect,
    run: fn(discord.Interaction, discord.ComponentData, List(Dynamic)) ->
      MessageComponentResponse,
  )
  MentionableSelectMessageComponent(
    select: component.MentionableSelect,
    run: fn(discord.Interaction, discord.ComponentData, List(Dynamic)) ->
      MessageComponentResponse,
  )
  ChannelSelectMessageComponent(
    select: component.ChannelSelect,
    run: fn(discord.Interaction, discord.ComponentData, List(Dynamic)) ->
      MessageComponentResponse,
  )
}

pub type MessageComponentResponse {
  MessageComponentMessageResponse(NewMessage)
  MessageComponentDeferredMessageResponse(fn() -> NewMessage)
  MessageComponentMessageUpdate(NewMessage)
  MessageComponentDeferredMessageUpdate(fn() -> NewMessage)
  MessageComponentModalResponse(Modal)
}

pub fn handle_component_dict(
  components: Dict(String, MessageComponent),
  interaction: discord.Interaction,
  data: discord.ComponentData,
) {
  use component <- result.try(
    dict.get(components, data.custom_id)
    |> result.replace_error(NotFound("Component: " <> data.custom_id)),
  )
  case component {
    ButtonMessageComponent(run:, ..) -> todo
    StringSelectMessageComponent(run:, ..) -> todo
    UserSelectMessageComponent(run:, ..) -> todo
    RoleSelectMessageComponent(run:, ..) -> todo
    MentionableSelectMessageComponent(run:, ..) -> todo
    ChannelSelectMessageComponent(run:, ..) -> todo
  }
}

pub type Modal {
  Modal(
    custom_id: String,
    title: String,
    components: List(component.Label),
    run: fn(discord.Interaction, discord.ModalData, Dict(String, Dynamic)) ->
      ModalResponse,
  )
}

pub fn modal_json(modal: Modal) -> Json {
  todo
}

pub type ModalResponse {
  ModalMessageResponse(NewMessage)
  ModalDeferredMessageResponse(fn() -> NewMessage)
  ModalMessageUpdate(NewMessage)
  ModalDeferredMessageUpdate(fn() -> NewMessage)
}

pub fn handle_modal_dict(
  modals: Dict(String, Modal),
  interaction: discord.Interaction,
  data: discord.ModalData,
) {
  use modal <- result.try(
    dict.get(modals, data.custom_id)
    |> result.replace_error(NotFound("Modal: " <> data.custom_id)),
  )

  Ok(modal.run(interaction, data, data.components))
}

pub type HandlingError {
  DecodingError(List(decode.DecodeError))
  NotFound(String)
}
