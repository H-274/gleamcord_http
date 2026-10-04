import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/json.{type Json}
import gleam/list
import gleam/string
import gleamcord_http/component
import gleamcord_http/discord
import gleamcord_http/locale

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

pub fn command_json(
  command: GleamcordCommand,
  translator: locale.Translator,
) -> Json {
  let def_json = command_def_json_list(command.definition, translator)

  case command {
    ChatCommand(options:, ..) -> [
      #("type", json.int(1)),
      #("options", json.array(options, option_json(_, translator))),
      ..def_json
    ]
    ChatCommandGroup(elements:, ..) -> [
      #("type", json.int(1)),
      #("options", json.array(elements, group_element_json(_, translator))),
      ..def_json
    ]
    UserCommand(..) -> [#("type", json.int(2)), ..def_json]
    MessageCommand(..) -> [#("type", json.int(3)), ..def_json]
  }
  |> json.object
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

fn command_def_json_list(
  command_definition: CommandDefinition,
  translator: locale.Translator,
) -> List(#(String, Json)) {
  let CommandDefinition(
    name:,
    description:,
    default_member_permissions:,
    integration_types:,
    contexts:,
    nsfw:,
  ) = command_definition

  [
    #("name", json.string(name)),
    #(
      "name_localizations",
      json.dict(translator(name), locale.to_string, json.string),
    ),
    #("description", json.string(description)),
    #(
      "description_localizations",
      json.dict(translator(description), locale.to_string, json.string),
    ),
    #("default_member_permissions", json.string(default_member_permissions)),
    #("integration_types", json.array(integration_types, json.int)),
    #("contexts", json.array(contexts, json.int)),
    #("nsfw", json.bool(nsfw)),
  ]
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

fn group_element_json(
  group_element: CommandGroupElement,
  translator: locale.Translator,
) {
  case group_element {
    SubCommandGroup(name:, description:, sub_commands:) ->
      [
        #("name", json.string(name)),
        #(
          "name_localizations",
          json.dict(translator(name), locale.to_string, json.string),
        ),
        #("description", json.string(description)),
        #(
          "description_localizations",
          json.dict(translator(description), locale.to_string, json.string),
        ),
        #("options", json.array(sub_commands, sub_command_json(_, translator))),
      ]
      |> json.object
    SubCommandElement(sub_command) -> sub_command_json(sub_command, translator)
  }
}

pub type SubCommand {
  SubCommand(
    name: String,
    description: String,
    options: List(CommandOption),
    handler: ChatCommandHandler,
  )
}

fn sub_command_json(sub_command: SubCommand, translator: locale.Translator) {
  let SubCommand(name:, description:, options:, ..) = sub_command

  [
    #("name", json.string(name)),
    #(
      "name_localizations",
      json.dict(translator(name), locale.to_string, json.string),
    ),
    #("description", json.string(description)),
    #(
      "description_localizations",
      json.dict(translator(description), locale.to_string, json.string),
    ),
    #("options", json.array(options, option_json(_, translator))),
  ]
  |> json.object
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
    choices: List(OptionChoice(String)),
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
    choices: List(OptionChoice(Int)),
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
    choices: List(OptionChoice(Float)),
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

fn option_json(command_option: CommandOption, translator: locale.Translator) {
  [
    #("name", json.string(command_option.name)),
    #(
      "name_localizations",
      json.dict(translator(command_option.name), locale.to_string, json.string),
    ),
    #("description", json.string(command_option.description)),
    #(
      "description_localizations",
      json.dict(
        translator(command_option.description),
        locale.to_string,
        json.string,
      ),
    ),
    #("required", json.bool(command_option.required)),
    ..case command_option {
      StringOption(min_length:, max_length:, ..) -> [
        #("type", json.int(3)),
        #("min_length", json.int(min_length)),
        #("max_length", json.int(max_length)),
      ]
      StringChoicesOption(choices:, ..) -> [
        #("type", json.int(3)),
        #(
          "choices",
          json.array(choices, option_choice_json(_, json.string, translator)),
        ),
      ]
      StringAutocompleteOption(min_length:, max_length:, ..) -> [
        #("type", json.int(3)),
        #("min_length", json.int(min_length)),
        #("max_length", json.int(max_length)),
        #("autocomplete", json.bool(True)),
      ]
      IntegerOption(min_value:, max_value:, ..) -> [
        #("type", json.int(4)),
        #("min_value", json.int(min_value)),
        #("max_value", json.int(max_value)),
      ]
      IntegerChoicesOption(choices:, ..) -> [
        #("type", json.int(4)),
        #(
          "choices",
          json.array(choices, option_choice_json(_, json.int, translator)),
        ),
      ]
      IntegerAutocompleteOption(min_value:, max_value:, ..) -> [
        #("type", json.int(4)),
        #("min_value", json.int(min_value)),
        #("max_value", json.int(max_value)),
        #("autocomplete", json.bool(True)),
      ]
      BooleanOption(..) -> [#("type", json.int(5))]
      UserOption(..) -> [#("type", json.int(6))]
      ChannelOption(channel_types:, ..) -> [
        #("type", json.int(7)),
        #("channel_types", json.array(channel_types, json.int)),
      ]
      RoleOption(..) -> [#("type", json.int(8))]
      MentionableOption(..) -> [#("type", json.int(9))]
      NumberOption(min_value:, max_value:, ..) -> [
        #("type", json.int(10)),
        #("min_value", json.float(min_value)),
        #("max_value", json.float(max_value)),
      ]
      NumberChoicesOption(choices:, ..) -> [
        #("type", json.int(10)),
        #(
          "choices",
          json.array(choices, option_choice_json(_, json.float, translator)),
        ),
      ]
      NumberAutocompleteOption(min_value:, max_value:, ..) -> [
        #("type", json.int(10)),
        #("min_value", json.float(min_value)),
        #("max_value", json.float(max_value)),
        #("autocomplete", json.bool(True)),
      ]
      AttachmentOption(..) -> [#("type", json.int(11))]
    }
  ]
  |> json.object
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
  StringAutocompleteResponse(List(OptionChoice(String)))
  IntegerAutocompleteResponse(List(OptionChoice(Int)))
  NumberAutocompleteResponse(List(OptionChoice(Float)))
}

pub fn autocomplete_response_json(
  autocomplete_response: AutocompleteResponse,
  translator: locale.Translator,
) {
  case autocomplete_response {
    StringAutocompleteResponse(r) ->
      json.array(r, fn(e) {
        json.object([
          #("name", json.string(e.0)),
          #(
            "name_localizations",
            json.dict(translator(e.0), locale.to_string, json.string),
          ),
          #("value", json.string(e.1)),
        ])
      })
    IntegerAutocompleteResponse(r) ->
      json.array(r, fn(e) {
        json.object([
          #("name", json.string(e.0)),
          #(
            "name_localizations",
            json.dict(translator(e.0), locale.to_string, json.string),
          ),
          #("value", json.int(e.1)),
        ])
      })
    NumberAutocompleteResponse(r) ->
      json.array(r, fn(e) {
        json.object([
          #("name", json.string(e.0)),
          #(
            "name_localizations",
            json.dict(translator(e.0), locale.to_string, json.string),
          ),
          #("value", json.float(e.1)),
        ])
      })
  }
}

pub type OptionChoice(t) =
  #(String, t)

fn option_choice_json(
  choice: OptionChoice(t),
  apply: fn(t) -> Json,
  translator: locale.Translator,
) {
  [
    #("name", json.string(choice.0)),
    #(
      "name_localizations",
      json.dict(translator(choice.0), locale.to_string, json.string),
    ),
    #("value", apply(choice.1)),
  ]
  |> json.object
}

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
    Button(component: c, ..) -> #(c.custom_id, component)
    StringSelect(component: c, ..) -> #(c.custom_id, component)
    UserSelect(component: c, ..) -> #(c.custom_id, component)
    RoleSelect(component: c, ..) -> #(c.custom_id, component)
    MentionableSelect(component: c, ..) -> #(c.custom_id, component)
    ChannelSelect(component: c, ..) -> #(c.custom_id, component)
  }
}

pub fn components_dict(
  components: List(GleamcordComponent),
) -> Dict(String, ComponentHandler) {
  list.map(components, fn(component) {
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
  })
  |> dict.from_list
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
