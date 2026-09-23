import gleam/dict
import gleam/list
import gleam/string
import gleamcord_http/discord

pub type GleamcordCommand {
  ChatCommand(
    definition: CommandDefinition,
    options: List(CommandOption),
    handler: CommandHandler,
  )
  ChatCommandGroup(
    definition: CommandDefinition,
    elements: List(CommandGroupElement),
  )
  UserCommand(definition: CommandDefinition, handler: CommandHandler)
  MessageCommand(definition: CommandDefinition, handler: CommandHandler)
}

/// TODO
pub type CommandDefinition {
  CommandDefinition(name: String, description: String)
}

/// TODO
pub type CommandGroupElement {
  SubCommandGroup(name: String, sub_commands: List(SubCommand))
  SubCommandElement(SubCommand)
}

/// TODO
pub type SubCommand {
  SubCommand(
    name: String,
    description: String,
    options: List(CommandOption),
    handler: CommandHandler,
  )
}

/// TODO
pub type CommandOption {
  StringOption(name: String)
  StringChoicesOption(name: String)
  StringAutocompleteOption(
    name: String,
    description: String,
    autocomplete: StringAutocompleteHandler,
  )
  IntegerAutocompleteOption(
    name: String,
    description: String,
    autocomplete: IntegerAutocompleteHandler,
  )
  NumberAutocompleteOption(
    name: String,
    description: String,
    autocomplete: NumberAutocompleteHandler,
  )
}

pub type CommandHandler =
  fn(discord.CommandInteraction) -> CommandResponse

/// TODO
pub type CommandResponse

pub type AutocompleteHandler {
  StringAutocompleteHandler(StringAutocompleteHandler)
  IntegerAutocompleteHandler(IntegerAutocompleteHandler)
  NumberAutocompleteHandler(NumberAutocompleteHandler)
}

pub type StringAutocompleteHandler =
  fn(discord.CommandInteraction, String) -> List(#(String, String))

pub type IntegerAutocompleteHandler =
  fn(discord.CommandInteraction, Int) -> List(#(String, Int))

pub type NumberAutocompleteHandler =
  fn(discord.CommandInteraction, Float) -> List(#(String, Float))

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
/// There dictionaries are to get a certain command/autocomplete interaction's handler based on its path
/// 
/// If multiple commands in the list share a path, the last command with the path takes precedence
pub fn commands_dicts(
  commands: List(GleamcordCommand),
) -> #(
  dict.Dict(String, CommandHandler),
  dict.Dict(String, AutocompleteHandler),
) {
  let final = #(dict.new(), dict.new())
  use
    #(final_command_dict, final_autocomplete_dict),
    #(command_dict, autocomplete_dict)
  <- list.fold(list.flat_map(commands, command_dicts_lists), final)

  #(
    dict.merge(final_command_dict, command_dict),
    dict.merge(final_autocomplete_dict, autocomplete_dict),
  )
}

pub fn command_dicts_lists(
  command: GleamcordCommand,
) -> List(
  #(dict.Dict(String, CommandHandler), dict.Dict(String, AutocompleteHandler)),
) {
  case command {
    ChatCommand(definition:, options:, handler:) -> [
      #(
        dict.from_list([#(definition.name, handler)]),
        dict.from_list(autocomplete_list(definition.name, options)),
      ),
    ]
    ChatCommandGroup(definition:, elements:) ->
      group_elements_dicts_list(definition.name, elements)
    UserCommand(definition:, handler:)
    | MessageCommand(definition:, handler:) -> [
      #(dict.from_list([#(definition.name, handler)]), dict.new()),
    ]
  }
}

fn group_elements_dicts_list(
  command_path: String,
  elements: List(CommandGroupElement),
) -> List(
  #(dict.Dict(String, CommandHandler), dict.Dict(String, AutocompleteHandler)),
) {
  use element <- list.flat_map(elements)
  case element {
    SubCommandElement(sub_command) -> [
      sub_command_dicts(command_path, sub_command),
    ]
    SubCommandGroup(name:, sub_commands:) -> {
      let path = string.join([command_path, name], "/")
      list.map(sub_commands, sub_command_dicts(path, _))
    }
  }
}

fn sub_command_dicts(
  command_path: String,
  sub_command: SubCommand,
) -> #(
  dict.Dict(String, CommandHandler),
  dict.Dict(String, AutocompleteHandler),
) {
  let path = string.join([command_path, sub_command.name], "/")
  #(
    dict.from_list([#(path, sub_command.handler)]),
    dict.from_list(autocomplete_list(path, sub_command.options)),
  )
}

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
