import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/list
import gleam/string
import gleamcord_http/component
import gleamcord_http/discord

pub type GleamcordCommand {
  ChatCommand(
    definition: CommandDefinition,
    options: List(CommandOption),
    handler: ChatCommandHandler,
  )
  ChatCommandGroup(
    definition: CommandDefinition,
    elements: List(CommandGroupElement),
  )
  UserCommand(definition: CommandDefinition, handler: ContextCommandHandler)
  MessageCommand(definition: CommandDefinition, handler: ContextCommandHandler)
}

pub type CommandDefinition {
  CommandDefinition(
    name: String,
    description: String,
    default_member_permissions: String,
    integration_types: List(Int),
    contexts: List(Int),
    nsfw: Bool,
  )
}

pub const guild_command_definition = CommandDefinition(
  name: "todo",
  description: "todo",
  default_member_permissions: "0",
  integration_types: [0],
  contexts: [1],
  nsfw: False,
)

pub type CommandGroupElement {
  SubCommandGroup(
    name: String,
    description: String,
    sub_commands: List(SubCommand),
  )
  SubCommandElement(SubCommand)
}

pub type SubCommand {
  SubCommand(
    name: String,
    description: String,
    options: List(CommandOption),
    handler: ChatCommandHandler,
  )
}

pub type CommandOption {
  StringOption(
    name: String,
    description: String,
    required: Bool,
    min_length: Int,
    max_length: Int,
  )
  StringChoicesOption(
    name: String,
    description: String,
    required: Bool,
    choices: List(#(String, String)),
  )
  StringAutocompleteOption(
    name: String,
    description: String,
    required: Bool,
    min_length: Int,
    max_length: Int,
    autocomplete: StringAutocompleteHandler,
  )
  IntegerOption(
    name: String,
    description: String,
    required: Bool,
    min_value: Int,
    max_value: Int,
  )
  IntegerChoicesOption(
    name: String,
    description: String,
    required: Bool,
    choices: List(#(String, Int)),
  )
  IntegerAutocompleteOption(
    name: String,
    description: String,
    required: Bool,
    min_value: Int,
    max_value: Int,
    autocomplete: IntegerAutocompleteHandler,
  )
  BooleanOption(name: String, description: String, required: Bool)
  UserOption(name: String, description: String, required: Bool)
  ChannelOption(
    name: String,
    description: String,
    required: Bool,
    channel_types: List(Int),
  )
  RoleOption(name: String, description: String, required: Bool)
  MentionableOption(name: String, description: String, required: Bool)
  NumberOption(
    name: String,
    description: String,
    required: Bool,
    min_value: Float,
    max_value: Float,
  )
  NumberChoicesOption(
    name: String,
    description: String,
    required: Bool,
    choices: List(#(String, Float)),
  )
  NumberAutocompleteOption(
    name: String,
    description: String,
    required: Bool,
    min_value: Float,
    max_value: Float,
    autocomplete: NumberAutocompleteHandler,
  )
  AttachmentOption(name: String, description: String, required: Bool)
}

pub type CommandHandler {
  ChatCommandHandler(ChatCommandHandler)
  ContextCommandHandler(ContextCommandHandler)
}

pub type ChatCommandHandler =
  fn(discord.CommandInteraction, Dict(String, discord.ValueOption)) ->
    CommandResponse

pub type ContextCommandHandler =
  fn(discord.CommandInteraction) -> CommandResponse

pub type CommandResponse {
  CommandMessageResponse(String)
  CommandDeferredMessageResponse(fn() -> String)
  CommandModalResponse
}

pub type AutocompleteHandler {
  StringAutocompleteHandler(StringAutocompleteHandler)
  IntegerAutocompleteHandler(IntegerAutocompleteHandler)
  NumberAutocompleteHandler(NumberAutocompleteHandler)
}

pub type StringAutocompleteHandler =
  fn(discord.CommandInteraction, Dict(String, discord.ValueOption), String) ->
    List(#(String, String))

pub type IntegerAutocompleteHandler =
  fn(discord.CommandInteraction, Dict(String, discord.ValueOption), Int) ->
    List(#(String, Int))

pub type NumberAutocompleteHandler =
  fn(discord.CommandInteraction, Dict(String, discord.ValueOption), Float) ->
    List(#(String, Float))

pub type AutocompleteResponse {
  StringAutocompleteResponse(StringAutocompleteResponse)
  IntegerAutocompleteResponse(IntegerAutocompleteResponse)
  NumberAutocompleteResponse(NumberAutocompleteResponse)
}

pub type StringAutocompleteResponse =
  List(#(String, String))

pub type IntegerAutocompleteResponse =
  List(#(String, Int))

pub type NumberAutocompleteResponse =
  List(#(String, Float))

/// Converts a list of `GleamcordCommands` to a set of dictionaries.
/// These dictionaries are to get a certain command/autocomplete interaction's handler based on its path
/// 
/// If multiple commands in the list share a path, the last command with the path takes precedence
pub fn command_dicts(commands: List(GleamcordCommand)) -> CommandDicts {
  let acc = #(dict.new(), dict.new())
  use acc, dicts <- list.fold(list.flat_map(commands, command_dicts_lists), acc)
  #(dict.merge(acc.0, dicts.0), dict.merge(acc.1, dicts.1))
}

fn command_dicts_lists(command: GleamcordCommand) -> List(CommandDicts) {
  case command {
    ChatCommand(definition:, options:, handler:) -> {
      let command_dict =
        dict.from_list([#(definition.name, ChatCommandHandler(handler))])
      let autocomplete_dict =
        dict.from_list(autocomplete_list(definition.name, options))
      [#(command_dict, autocomplete_dict)]
    }
    ChatCommandGroup(definition:, elements:) ->
      group_elements_dicts_list(definition.name, elements)
    UserCommand(definition:, handler:)
    | MessageCommand(definition:, handler:) -> {
      let command_dict =
        dict.from_list([#(definition.name, ContextCommandHandler(handler))])
      [#(command_dict, dict.new())]
    }
  }
}

fn group_elements_dicts_list(
  command_path: String,
  elements: List(CommandGroupElement),
) -> List(CommandDicts) {
  use element <- list.flat_map(elements)
  case element {
    SubCommandElement(sub_command) -> [
      sub_command_dicts(command_path, sub_command),
    ]
    SubCommandGroup(name:, sub_commands:, ..) -> {
      let path = string.join([command_path, name], "/")
      list.map(sub_commands, sub_command_dicts(path, _))
    }
  }
}

fn sub_command_dicts(
  command_path: String,
  sub_command: SubCommand,
) -> CommandDicts {
  let path = string.join([command_path, sub_command.name], "/")
  let command_dict =
    dict.from_list([#(path, ChatCommandHandler(sub_command.handler))])
  let autocomplete_dict =
    dict.from_list(autocomplete_list(path, sub_command.options))
  #(command_dict, autocomplete_dict)
}

type CommandDicts =
  #(dict.Dict(String, CommandHandler), dict.Dict(String, AutocompleteHandler))

fn autocomplete_list(
  command_path: String,
  options: List(CommandOption),
) -> List(#(String, AutocompleteHandler)) {
  use option <- list.filter_map(options)
  let path = string.join([command_path, option.name], "/")
  case option {
    StringAutocompleteOption(autocomplete:, ..) ->
      #(path, StringAutocompleteHandler(autocomplete)) |> Ok
    IntegerAutocompleteOption(autocomplete:, ..) ->
      #(path, IntegerAutocompleteHandler(autocomplete)) |> Ok
    NumberAutocompleteOption(autocomplete:, ..) ->
      #(path, NumberAutocompleteHandler(autocomplete)) |> Ok
    _ -> Error(Nil)
  }
}

pub type GleamcordComponent {
  Button(component: component.InteractiveButton, handler: ButtonHandler)
  StringSelect(component: component.StringSelect, handler: SelectHandler)
  UserSelect(component: component.UserSelect, handler: SelectHandler)
  RoleSelect(component: component.RoleSelect, handler: SelectHandler)
  MentionableSelect(
    component: component.MentionableSelect,
    handler: SelectHandler,
  )
  ChannelSelect(component: component.ChannelSelect, handler: SelectHandler)
}

pub fn component_tuple(component: GleamcordComponent) {
  case component {
    Button(component:, handler:) -> #(
      component.custom_id,
      ComponentButtonHandler(handler),
    )
    StringSelect(component:, handler:) -> #(
      component.custom_id,
      ComponentSelectHandler(handler),
    )
    UserSelect(component:, handler:) -> #(
      component.custom_id,
      ComponentSelectHandler(handler),
    )
    RoleSelect(component:, handler:) -> #(
      component.custom_id,
      ComponentSelectHandler(handler),
    )
    MentionableSelect(component:, handler:) -> #(
      component.custom_id,
      ComponentSelectHandler(handler),
    )
    ChannelSelect(component:, handler:) -> #(
      component.custom_id,
      ComponentSelectHandler(handler),
    )
  }
}

pub type ComponentHandler {
  ComponentButtonHandler(ButtonHandler)
  ComponentSelectHandler(SelectHandler)
}

pub type ButtonHandler =
  fn(discord.ComponentInteraction) -> ComponentResponse

pub type SelectHandler =
  fn(discord.ComponentInteraction, List(String)) -> ComponentResponse

pub type ComponentResponse {
  ComponentMessageResponse(String)
  ComponentDeferredMessageResponse(fn() -> String)
  ComponentMessageUpdate(String)
  ComponentDeferredMessageUpdate(fn() -> String)
  ComponentModalResponse
}

pub type GleamcordModal {
  GleamcordModal(
    custom_id: String,
    title: String,
    components: List(component.Label),
    handler: ModalHandler,
  )
}

pub type ModalHandler =
  fn(discord.ModalInteraction, Dict(String, Dynamic)) -> ModalResponse

pub type ModalResponse {
  ModalMessageResponse(String)
  ModalDeferredMessageResponse(fn() -> String)
  ModalMessageUpdate(String)
  ModalDeferredMessageUpdate(fn() -> String)
}
