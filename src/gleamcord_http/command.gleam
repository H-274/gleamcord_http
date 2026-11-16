import gleam/dict.{type Dict}
import gleamcord_http.{type Message}
import gleamcord_http/discord
import gleamcord_http/modal.{type Modal}

pub type Slash {
  Slash(
    name: String,
    description: String,
    // Maps to default_member_permissions
    permissions: String,
    // Maps to integration_types
    integrations: List(discord.Integration),
    contexts: List(discord.Context),
    nsfw: Bool,
    options: List(Option),
    handler: SlashHandler,
  )
  SlashGroup(
    name: String,
    description: String,
    // Maps to default_member_permissions
    permissions: String,
    // Maps to integration_types
    integrations: List(discord.Integration),
    contexts: List(discord.Context),
    nsfw: Bool,
    sub_commands: List(GroupElement),
  )
}

pub fn slash(
  name name: String,
  desc description: String,
  opts options,
  handler handler,
) {
  Slash(
    name:,
    description:,
    permissions: "0",
    integrations: [],
    contexts: [],
    nsfw: False,
    options:,
    handler:,
  )
}

pub fn slash_group(
  name name: String,
  desc description: String,
  sub sub_commands,
) {
  SlashGroup(
    name:,
    description:,
    permissions: "0",
    integrations: [],
    contexts: [],
    nsfw: False,
    sub_commands:,
  )
}

pub type GroupElement {
  SubGroupElement(
    name: String,
    description: String,
    sub_commands: List(SubCommand),
  )
  SubElement(SubCommand)
}

pub type SubCommand {
  SubCommand(
    name: String,
    description: String,
    options: List(Option),
    handler: SlashHandler,
  )
}

pub type Option {
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

pub type OptionChoice(t) =
  #(String, t)

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

pub type SlashHandler =
  fn(discord.CommandInteraction, Dict(String, discord.ValueOption)) -> Response

pub type Context {
  User(
    name: String,
    // Maps to default_member_permissions
    permissions: String,
    // Maps to integration_types
    integrations: List(discord.Integration),
    contexts: List(discord.Context),
    nsfw: Bool,
    handler: ContextHandler,
  )
  Message(
    name: String,
    // Maps to default_member_permissions
    permissions: String,
    // Maps to integration_types
    integrations: List(discord.Integration),
    contexts: List(discord.Context),
    nsfw: Bool,
    handler: ContextHandler,
  )
}

pub fn guild_user(name: String, handler) {
  User(
    name:,
    permissions: "0",
    integrations: [discord.GuildInstall],
    contexts: [discord.GuildContext],
    nsfw: False,
    handler:,
  )
}

pub fn guild_message(name: String, handler) {
  Message(
    name:,
    permissions: "0",
    integrations: [discord.GuildInstall],
    contexts: [discord.GuildContext],
    nsfw: False,
    handler:,
  )
}

pub type ContextHandler =
  fn(discord.CommandInteraction) -> Response

pub type Handler {
  SlashHandler(SlashHandler)
  ContextHandler(ContextHandler)
}

pub type Response {
  MessageResponse(Message)
  DeferredMessageResponse(fn() -> Message)
  ModalResponse(Modal)
}
