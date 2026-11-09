import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/json.{type Json}
import gleam/list
import gleamcord_http/component
import gleamcord_http/discord
import gleamcord_http/locale

pub type SlashCommand {
  SlashCommand(
    name: String,
    description: String,
    // Maps to default_member_permissions
    permissions: String,
    // Maps to integration_types
    integrations: List(Int),
    contexts: List(Int),
    nsfw: Bool,
    options: List(CommandOption),
    handler: SlashCommandHandler,
  )
  SlashCommandGroup(
    name: String,
    description: String,
    // Maps to default_member_permissions
    permissions: String,
    // Maps to integration_types
    integrations: List(Int),
    contexts: List(Int),
    nsfw: Bool,
    sub_commands: List(SubCommandElement),
  )
}

/// Slash commands that are installed in guilds and only useable in guilds
pub const strict_guild_slash_command =
  SlashCommand(
    name: "",
    description: "",
    permissions: "0",
    integrations: [0],
    contexts: [0],
    nsfw: False,
    options: [],
    handler: slash_command_identity,
  )

/// Slash command that is installed per user and callable in DMs with the bot
pub const strict_user_slash_command =
  SlashCommand(
    name: "",
    description: "",
    permissions: "0",
    integrations: [1],
    contexts: [1],
    nsfw: False,
    options: [],
    handler: slash_command_identity,
  )

/// Slash command group that is installed in guilds and only useable in guilds
pub const strict_guild_slash_command_group =
  SlashCommandGroup(
    name: "",
    description: "",
    permissions: "0",
    integrations: [0],
    contexts: [0],
    nsfw: False,
    sub_commands: [],
  )

/// Slash command group that is installed per user and callable in DMs with the bot
pub const strict_user_slash_command_group =
  SlashCommandGroup(
    name: "",
    description: "",
    permissions: "0",
    integrations: [1],
    contexts: [1],
    nsfw: False,
    sub_commands: [],
  )

pub fn slash_command_json(
  command: SlashCommand,
  translator: locale.Translator,
) {
  json.object([
    #("name", json.string(command.name)),
    #(
      "name_localization",
      json.dict(translator(command.name), locale.to_string, json.string),
    ),
    #("description", json.string(command.description)),
    #(
      "description_localization",
      json.dict(translator(command.description), locale.to_string, json.string),
    ),
    #("options", case command {
      SlashCommand(options:, ..) ->
        json.array(options, option_json(_, translator))
      SlashCommandGroup(sub_commands:, ..) ->
        json.array(sub_commands, sub_command_element_json(_, translator))
    }),
    #("default_member_permissions", json.string(command.permissions)),
    #("integration_types", json.array(command.integrations, json.int)),
    #("contexts", json.array(command.contexts, json.int)),
    #("nsfw", json.bool(command.nsfw)),
  ])
}

pub type SubCommandElement {
  SubCommandGroupElement(
    name: String,
    description: String,
    sub_commands: List(SubCommand),
  )
  SubCommandElement(SubCommand)
}

fn sub_command_element_json(
  sub_command_element: SubCommandElement,
  translator: locale.Translator,
) {
  case sub_command_element {
    SubCommandGroupElement(name:, description:, sub_commands:) ->
      json.object([
        #("name", json.string(name)),
        #(
          "name_localization",
          json.dict(translator(name), locale.to_string, json.string),
        ),
        #("description", json.string(description)),
        #(
          "description_localization",
          json.dict(translator(description), locale.to_string, json.string),
        ),
        #("options", json.array(sub_commands, sub_command_json(_, translator))),
      ])
    SubCommandElement(sub_command) -> sub_command_json(sub_command, translator)
  }
}

pub type SubCommand {
  SubCommand(
    name: String,
    description: String,
    options: List(CommandOption),
    handler: SlashCommandHandler,
  )
}

fn sub_command_json(sub_command: SubCommand, translator: locale.Translator) {
  let SubCommand(name:, description:, options:, ..) = sub_command

  json.object([
    #("name", json.string(name)),
    #(
      "name_localization",
      json.dict(translator(name), locale.to_string, json.string),
    ),
    #("description", json.string(description)),
    #(
      "description_localization",
      json.dict(translator(description), locale.to_string, json.string),
    ),
    #("options", json.array(options, option_json(_, translator))),
  ])
}

pub type ContextCommand {
  UserContextCommand(
    name: String,
    // Maps to default_member_permissions
    permissions: String,
    // Maps to integration_types
    integrations: List(Int),
    contexts: List(Int),
    nsfw: Bool,
    handler: ContextCommandHandler,
  )
  MessageContextCommand(
    name: String,
    // Maps to default_member_permissions
    permissions: String,
    // Maps to integration_types
    integrations: List(Int),
    contexts: List(Int),
    nsfw: Bool,
    handler: ContextCommandHandler,
  )
}

/// User context commands that are installed in guilds and only useable in guilds
pub const strict_guild_user_command =
  UserContextCommand(
    name: "",
    permissions: "0",
    integrations: [0],
    contexts: [0],
    nsfw: False,
    handler: context_command_identity,
  )

/// Message context commands that are installed in guilds and only useable in guilds
pub const strict_guild_message_command =
  MessageContextCommand(
    name: "",
    permissions: "0",
    integrations: [0],
    contexts: [0],
    nsfw: False,
    handler: context_command_identity,
  )

pub fn context_command_json(
  command: ContextCommand,
  translator: locale.Translator,
) {
  json.object([
    #("name", json.string(command.name)),
    #(
      "name_localization",
      json.dict(translator(command.name), locale.to_string, json.string),
    ),
    #("default_member_permissions", json.string(command.permissions)),
    #("integration_types", json.array(command.integrations, json.int)),
    #("contexts", json.array(command.contexts, json.int)),
    #("nsfw", json.bool(command.nsfw)),
  ])
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

pub const default_string_option =
  StringOption(
    name: "todo",
    description: "",
    required: True,
    min_length: 1,
    max_length: 4000,
  )

pub const default_string_autocomplete_option =
  StringAutocompleteOption(
    name: "todo",
    description: "",
    required: True,
    min_length: 1,
    max_length: 4000,
    autocomplete: autocomplete_identity,
  )

pub const default_integer_option =
  IntegerOption(
    name: "todo",
    description: "",
    required: True,
    min_value: -9_007_199_254_740_991,
    max_value: 9_007_199_254_740_991,
  )

pub const default_integer_autocomplete_option =
  IntegerAutocompleteOption(
    name: "todo",
    description: "",
    required: True,
    min_value: -9_007_199_254_740_991,
    max_value: 9_007_199_254_740_991,
    autocomplete: autocomplete_identity,
  )

pub const default_number_option =
  NumberOption(
    name: "todo",
    description: "",
    required: True,
    min_value: -1.7976931348623157e308,
    max_value: 1.7976931348623157e308,
  )

pub const default_number_autocomplete_option =
  NumberAutocompleteOption(
    name: "todo",
    description: "",
    required: True,
    min_value: -1.7976931348623157e308,
    max_value: 1.7976931348623157e308,
    autocomplete: autocomplete_identity,
  )

fn autocomplete_identity(_, _, _) {
  []
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
  SlashCommandHandler(SlashCommandHandler)
  ContextCommandHandler(ContextCommandHandler)
}

pub type SlashCommandHandler =
  fn(discord.CommandInteraction, Dict(String, discord.ValueOption)) ->
    CommandResponse

fn slash_command_identity(_, _) {
  panic as "Implement a handler"
}

pub type ContextCommandHandler =
  fn(discord.CommandInteraction) -> CommandResponse

fn context_command_identity(_) {
  panic as "Implement a handler"
}

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
) -> Dict(String, GleamcordComponent) {
  list.map(components, fn(component) {
    case component {
      Button(component: c, ..) -> #(c.custom_id, component)
      StringSelect(component: c, ..) -> #(c.custom_id, component)
      UserSelect(component: c, ..) -> #(c.custom_id, component)
      RoleSelect(component: c, ..) -> #(c.custom_id, component)
      MentionableSelect(component: c, ..) -> #(c.custom_id, component)
      ChannelSelect(component: c, ..) -> #(c.custom_id, component)
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
