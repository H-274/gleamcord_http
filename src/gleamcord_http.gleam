import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/json.{type Json}
import gleam/list
import gleam/result
import gleamcord_http/component
import gleamcord_http/discord
import gleamcord_http/locale

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
    default_member_permissions: "0",
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

// TODO reduce code duplication
pub fn command_json(command: Command, translator: locale.Translator) {
  [
    #("name", json.string(command.def.name)),
    #(
      "name_localizations",
      json.dict(translator(command.def.name), locale.to_string, json.string),
    ),
    #("description", json.string(command.def.description)),
    #(
      "description_localizations",
      json.dict(
        translator(command.def.description),
        locale.to_string,
        json.string,
      ),
    ),
    #(
      "default_member_permissions",
      json.string(command.def.default_member_permissions),
    ),
    #("integration_types", json.array(command.def.integ_types, json.int)),
    #("contexts", json.array(command.def.contexts, json.int)),
    #("nsfw", json.bool(command.def.nsfw)),
    ..case command {
      ChatCommand(options:, ..) -> [
        #("type", json.int(1)),
        #("options", json.array(options, option_json(_, translator))),
      ]
      ChatCommandGroup(elements:, ..) -> [
        #("type", json.int(1)),
        #(
          "options",
          json.array(dict.values(elements), fn(e) {
            case e {
              SubCommandElement(sub_command) -> [
                #("type", json.int(1)),
                #("name", json.string(sub_command.name)),
                #(
                  "name_localizations",
                  json.dict(
                    translator(sub_command.name),
                    locale.to_string,
                    json.string,
                  ),
                ),
                #("description", json.string(sub_command.description)),
                #(
                  "description_localizations",
                  json.dict(
                    translator(sub_command.description),
                    locale.to_string,
                    json.string,
                  ),
                ),
                #(
                  "options",
                  json.array(sub_command.options, option_json(_, translator)),
                ),
              ]
              SubCommandGroupElement(name:, description:, sub_commands:) -> [
                #("type", json.int(2)),
                #("name", json.string(name)),
                #(
                  "name_localizations",
                  json.dict(translator(name), locale.to_string, json.string),
                ),
                #("description", json.string(description)),
                #(
                  "description_localizations",
                  json.dict(
                    translator(description),
                    locale.to_string,
                    json.string,
                  ),
                ),
                #(
                  "options",
                  json.array(dict.values(sub_commands), fn(sub_command) {
                    [
                      #("type", json.int(1)),
                      #("name", json.string(sub_command.name)),
                      #(
                        "name_localizations",
                        json.dict(
                          translator(sub_command.name),
                          locale.to_string,
                          json.string,
                        ),
                      ),
                      #("description", json.string(sub_command.description)),
                      #(
                        "description_localizations",
                        json.dict(
                          translator(sub_command.description),
                          locale.to_string,
                          json.string,
                        ),
                      ),
                      #(
                        "options",
                        json.array(sub_command.options, option_json(
                          _,
                          translator,
                        )),
                      ),
                    ]
                    |> json.object
                  }),
                ),
              ]
            }
            |> json.object
          }),
        ),
      ]
      UserCommand(..) -> [#("type", json.int(3))]
      MessageCommand(..) -> [#("type", json.int(4))]
    }
  ]
  |> json.object
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
        _ -> Error(NotFound("value options for, " <> data.name))
      }

    discord.ChatCommandData(options:, ..), Ok(ChatCommandGroup(elements:, ..))
    ->
      case options {
        discord.SubCommandOption(sub_opt) ->
          case dict.get(elements, sub_opt.name) {
            Ok(SubCommandElement(sub)) ->
              Ok(sub.run(interaction, data, sub_opt.options))
            _ -> Error(NotFound("sub command, " <> sub_opt.name))
          }
        discord.SubCommandGroupOption(name: group_name, sub_command:) ->
          case dict.get(elements, group_name) {
            Ok(SubCommandGroupElement(sub_commands:, ..)) ->
              case dict.get(sub_commands, sub_command.name) {
                Ok(ChatSubCommand(run:, ..)) ->
                  Ok(run(interaction, data, sub_command.options))
                _ -> Error(NotFound("group sub command, " <> sub_command.name))
              }
            _ -> Error(NotFound("sub command group, " <> group_name))
          }
        discord.ValueOptions(_) ->
          panic as "Command group should not have value options"
      }
    _, _ -> Error(NotFound("command, " <> data.name))
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
        _ -> Error(NotFound("sub command, " <> sub_command.name))
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
            _ -> Error(NotFound("sub command, " <> sub_command.name))
          }
        _ -> Error(NotFound("sub command group, " <> sub_command.name))
      }
    }
    _, _ -> Error(NotFound("command, " <> data.name))
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
    _, _ -> Error(NotFound("focused option definition"))
  }
}

pub type CommandOption {
  StringOption(
    name: String,
    description: String,
    required: Bool,
    min_len: Int,
    max_len: Int,
  )
  StringChoiceOption(
    name: String,
    description: String,
    required: Bool,
    choices: List(#(String, String)),
  )
  StringAutocompleteOption(
    name: String,
    description: String,
    required: Bool,
    min_len: Int,
    max_len: Int,
    run: StringAutocomplete,
  )
  IntegerOption(
    name: String,
    description: String,
    required: Bool,
    min_value: Int,
    max_value: Int,
  )
  IntegerChoiceOption(
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
    run: IntegerAutocomplete,
  )
  BoooleanOption(name: String, description: String, required: Bool)
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
  NumberChoiceOption(
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
    run: NumberAutocomplete,
  )
  AttachmentOption(name: String, description: String, required: Bool)
}

pub fn command_options(options: List(CommandOption)) {
  list.map(options, fn(o) { #(o.name, o) })
  |> dict.from_list
}

pub fn option_json(option: CommandOption, translator: locale.Translator) {
  [
    #("name", json.string(option.name)),
    #(
      "name_localizations",
      json.dict(translator(option.name), locale.to_string, json.string),
    ),
    #("description", json.string(option.description)),
    #(
      "description_localizations",
      json.dict(translator(option.description), locale.to_string, json.string),
    ),
    #("required", json.bool(option.required)),
    ..case option {
      StringOption(min_len:, max_len:, ..) -> [
        #("type", json.int(3)),
        #("min_length", json.int(min_len)),
        #("max_length", json.int(max_len)),
      ]
      StringAutocompleteOption(min_len:, max_len:, ..) -> [
        #("type", json.int(3)),
        #("min_length", json.int(min_len)),
        #("max_length", json.int(max_len)),
        #("autocomplete", json.bool(True)),
      ]
      StringChoiceOption(choices:, ..) -> [
        #("type", json.int(3)),
        #(
          "choices",
          json.array(choices, fn(c) {
            [
              #("name", json.string(c.0)),
              #(
                "name_localizations",
                json.dict(translator(c.0), locale.to_string, json.string),
              ),
              #("value", json.string(c.1)),
            ]
            |> json.object
          }),
        ),
      ]
      IntegerOption(min_value:, max_value:, ..) -> [
        #("type", json.int(4)),
        #("min_value", json.int(min_value)),
        #("max_value", json.int(max_value)),
      ]
      IntegerAutocompleteOption(min_value:, max_value:, ..) -> [
        #("type", json.int(4)),
        #("min_value", json.int(min_value)),
        #("max_value", json.int(max_value)),
        #("autocomplete", json.bool(True)),
      ]
      IntegerChoiceOption(choices:, ..) -> [
        #("type", json.int(4)),
        #(
          "choices",
          json.array(choices, fn(c) {
            [
              #("name", json.string(c.0)),
              #(
                "name_localizations",
                json.dict(translator(c.0), locale.to_string, json.string),
              ),
              #("value", json.int(c.1)),
            ]
            |> json.object
          }),
        ),
      ]
      BoooleanOption(..) -> [#("type", json.int(5))]
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
      NumberAutocompleteOption(min_value:, max_value:, ..) -> [
        #("type", json.int(10)),
        #("min_value", json.float(min_value)),
        #("max_value", json.float(max_value)),
        #("autocomplete", json.bool(True)),
      ]
      NumberChoiceOption(choices:, ..) -> [
        #("type", json.int(10)),
        #(
          "choices",
          json.array(choices, fn(c) {
            [
              #("name", json.string(c.0)),
              #(
                "name_localizations",
                json.dict(translator(c.0), locale.to_string, json.string),
              ),
              #("value", json.float(c.1)),
            ]
            |> json.object
          }),
        ),
      ]
      AttachmentOption(..) -> [#("type", json.int(11))]
    }
  ]
  |> json.object
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
    |> result.replace_error(NotFound("component, " <> data.custom_id)),
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
    |> result.replace_error(NotFound("modal, " <> data.custom_id)),
  )

  Ok(modal.run(interaction, data, data.components))
}

pub type HandlingError {
  DecodingError(List(decode.DecodeError))
  NotFound(String)
}
