import channel
import command/command_options
import command/interaction.{type Interaction}
import gleam/dict.{type Dict}
import gleam/json.{type Json}
import gleam/list
import locale
import message
import modal/modal.{type Modal}

pub opaque type Command(state) {
  ChatInput(
    signature: Signature,
    options: List(#(String, Option(state))),
    handler: ChatInputHandler(state),
  )
  Group(signature: Signature, elements: Dict(String, Element(state)))
  User(signature: Signature, handler: UserHandler(state))
  Message(signature: Signature, handler: MessageHandler(state))
}

pub fn chat_input(
  sig signature: Signature,
  opts options: List(Option(_)),
  handler handler: ChatInputHandler(_),
) -> Command(_) {
  let options =
    options
    |> list.map(fn(o) { #(o.name, o) })

  ChatInput(signature:, options:, handler:)
}

pub fn group(
  sig signature: Signature,
  elements elements: List(Element(_)),
) -> Command(_) {
  let elements =
    elements
    |> list.map(fn(e) {
      case e {
        GroupElement(name:, ..) -> #(name, e)
        SubcommandElement(s) -> #(s.name, e)
      }
    })
    |> dict.from_list

  Group(signature:, elements:)
}

pub fn user(
  sig signature: Signature,
  handler handler: UserHandler(_),
) -> Command(_) {
  User(signature:, handler:)
}

pub fn message(
  sig signature: Signature,
  handler handler: MessageHandler(_),
) -> Command(_) {
  Message(signature:, handler:)
}

pub fn to_tuple(command: Command(_)) -> #(String, Command(_)) {
  #(command.signature.name, command)
}

pub fn json(command: Command(_), translator: locale.Translator) -> Json {
  case command {
    ChatInput(options:, ..) -> [
      #("type", json.int(1)),
      #("options", options_json(options, translator)),
      ..signature_json(command.signature, translator)
    ]
    Group(elements:, ..) -> [
      #("type", json.int(1)),
      #("options", elements_json(elements, translator)),
      ..signature_json(command.signature, translator)
    ]
    User(..) -> [
      #("type", json.int(2)),
      ..context_signature_json(command.signature, translator)
    ]
    Message(..) -> [
      #("type", json.int(3)),
      ..context_signature_json(command.signature, translator)
    ]
  }
  |> json.object
}

pub type Signature {
  Signature(
    name: String,
    description: String,
    default_member_permissions: String,
    integrations: List(Integration),
    contexts: List(Context),
    nsfw: Bool,
  )
}

pub fn simple_signature(
  name name: String,
  desc description: String,
) -> Signature {
  Signature(
    name:,
    description:,
    default_member_permissions: "0",
    integrations: [GuildInstall],
    contexts: [Guild, BotDM, PrivateChannel],
    nsfw: False,
  )
}

fn signature_json(signature: Signature, translator: locale.Translator) {
  let Signature(
    name:,
    description:,
    default_member_permissions:,
    integrations:,
    contexts:,
    nsfw:,
  ) = signature
  let name_localizations =
    json.dict(translator(name), locale.to_string, json.string)
  let description_localizations =
    json.dict(translator(description), locale.to_string, json.string)

  [
    #("name", json.string(name)),
    #("name_localizations", name_localizations),
    #("description", json.string(description)),
    #("description_localization", description_localizations),
    #("default_member_permissions", json.string(default_member_permissions)),
    #("integrations", json.array(integrations, integration_json)),
    #("contexts", json.array(contexts, context_json)),
    #("nsfw", json.bool(nsfw)),
  ]
}

fn context_signature_json(signature: Signature, translator: locale.Translator) {
  let Signature(
    name:,
    description: _,
    default_member_permissions:,
    integrations:,
    contexts:,
    nsfw:,
  ) = signature
  let name_localizations =
    json.dict(translator(name), locale.to_string, json.string)
  [
    #("name", json.string(name)),
    #("name_localizations", name_localizations),
    #("default_member_permissions", json.string(default_member_permissions)),
    #("integrations", json.array(integrations, integration_json)),
    #("contexts", json.array(contexts, context_json)),
    #("nsfw", json.bool(nsfw)),
  ]
}

pub type Integration {
  GuildInstall
  UserInstall
}

fn integration_json(integration: Integration) {
  case integration {
    GuildInstall -> json.int(0)
    UserInstall -> json.int(1)
  }
}

pub type Context {
  Guild
  BotDM
  PrivateChannel
}

fn context_json(context: Context) {
  case context {
    Guild -> json.int(0)
    BotDM -> json.int(1)
    PrivateChannel -> json.int(2)
  }
}

pub type Option(state) {
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
    autocomplete: AutocompleteHandler(state, String),
  )
  IntegerOption(
    name: String,
    description: String,
    required: Bool,
    min_val: Int,
    max_val: Int,
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
    min_val: Int,
    max_val: Int,
    autocomplete: AutocompleteHandler(state, Int),
  )
  BooleanOption(name: String, description: String, required: Bool)
  UserOption(name: String, description: String, required: Bool)
  ChannelOption(
    name: String,
    description: String,
    required: Bool,
    channel_types: List(channel.Type),
  )
  RoleOption(name: String, description: String, required: Bool)
  MentionableOption(name: String, description: String, required: Bool)
  NumberOption(
    name: String,
    description: String,
    required: Bool,
    min_val: Float,
    max_val: Float,
  )
  NumberChoiceOption(
    name: String,
    description: String,
    required: Bool,
    chcoices: List(#(String, Float)),
  )
  NumberAutocompleteOption(
    name: String,
    description: String,
    required: Bool,
    min_val: Float,
    max_val: Float,
    autocomplete: AutocompleteHandler(state, Float),
  )
  AttachmentOption(name: String, description: String, required: Bool)
}

fn options_json(
  options: List(#(String, Option(_))),
  translator: locale.Translator,
) -> Json {
  list.map(options, fn(o) { o.1 }) |> json.array(option_json(_, translator))
}

fn option_json(option: Option(_), translator: locale.Translator) -> Json {
  let distinct_fields = case option {
    StringOption(min_len:, max_len:, ..) -> [
      #("type", json.int(3)),
      #("min_length", json.int(min_len)),
      #("max_length", json.int(max_len)),
    ]
    StringChoiceOption(choices:, ..) -> [
      #("type", json.int(3)),
      #("choices", json.array(choices, string_choice_json)),
    ]
    StringAutocompleteOption(min_len:, max_len:, ..) -> [
      #("type", json.int(3)),
      #("min_length", json.int(min_len)),
      #("max_length", json.int(max_len)),
      #("autocomplete", json.bool(True)),
    ]
    IntegerOption(min_val:, max_val:, ..) -> [
      #("type", json.int(4)),
      #("min_value", json.int(min_val)),
      #("max_value", json.int(max_val)),
    ]
    IntegerChoiceOption(choices:, ..) -> [
      #("type", json.int(4)),
      #("choices", json.array(choices, integer_choice_json)),
    ]
    IntegerAutocompleteOption(min_val:, max_val:, ..) -> [
      #("type", json.int(4)),
      #("min_value", json.int(min_val)),
      #("max_value", json.int(max_val)),
      #("autocomplete", json.bool(True)),
    ]
    BooleanOption(..) -> [#("type", json.int(5))]
    UserOption(..) -> [#("type", json.int(6))]
    ChannelOption(channel_types:, ..) -> [
      #("type", json.int(7)),
      #(
        "channel_types",
        json.array(channel_types, fn(t) { channel.type_to_id(t) |> json.int }),
      ),
    ]
    RoleOption(..) -> [#("type", json.int(8))]
    MentionableOption(..) -> [#("type", json.int(9))]
    NumberOption(min_val:, max_val:, ..) -> [
      #("type", json.int(10)),
      #("min_value", json.float(min_val)),
      #("max_value", json.float(max_val)),
    ]
    NumberChoiceOption(chcoices:, ..) -> [
      #("type", json.int(10)),
      #("choices", json.array(chcoices, number_choice_json)),
    ]
    NumberAutocompleteOption(min_val:, max_val:, ..) -> [
      #("type", json.int(10)),
      #("min_value", json.float(min_val)),
      #("max_value", json.float(max_val)),
      #("autocomplet", json.bool(True)),
    ]
    AttachmentOption(..) -> [#("type", json.int(11))]
  }

  let name = option.name
  let description = option.description
  let required = option.required
  let name_localizations =
    json.dict(translator(name), locale.to_string, json.string)
  let description_localizations =
    json.dict(translator(description), locale.to_string, json.string)
  [
    #("name", json.string(name)),
    #("name_localizations", name_localizations),
    #("description", json.string(description)),
    #("description_localizations", description_localizations),
    #("required", json.bool(required)),
    ..distinct_fields
  ]
  |> json.object
}

pub type ChatInputHandler(state) =
  fn(Interaction, Dict(String, command_options.Value), state) -> Response(state)

pub type UserHandler(state) =
  fn(Interaction, state) -> Response(state)

pub type MessageHandler(state) =
  fn(Interaction, state) -> Response(state)

pub type Response(state) {
  MessageResponse(message.New)
  DeferredMessageResponse(fn() -> message.New)
  ModalResponse(Modal(state))
}

pub type AutocompleteHandler(state, t) =
  fn(Interaction, Dict(String, command_options.Value), t, state) ->
    List(#(String, t))

pub type Autocomplete {
  StringAutocomplete(List(#(String, String)))
  IntegerAutocomplete(List(#(String, Int)))
  NumberAutocomplete(List(#(String, Float)))
}

pub fn autocomplete_json(autocomplete: Autocomplete) -> Json {
  [
    #("choices", case autocomplete {
      StringAutocomplete(a) -> json.array(a, string_choice_json)
      IntegerAutocomplete(a) -> json.array(a, integer_choice_json)
      NumberAutocomplete(a) -> json.array(a, number_choice_json)
    }),
  ]
  |> json.object
}

fn string_choice_json(choice: #(String, String)) {
  [#("name", json.string(choice.0)), #("value", json.string(choice.1))]
  |> json.object
}

fn integer_choice_json(choice: #(String, Int)) {
  [#("name", json.string(choice.0)), #("value", json.int(choice.1))]
  |> json.object
}

fn number_choice_json(choice: #(String, Float)) {
  [#("name", json.string(choice.0)), #("value", json.float(choice.1))]
  |> json.object
}

pub opaque type Element(state) {
  GroupElement(
    name: String,
    description: String,
    subcommands: Dict(String, Subcommand(state)),
  )
  SubcommandElement(Subcommand(state))
}

pub fn group_element(
  name name: String,
  desc description: String,
  sub subcommands: List(Subcommand(_)),
) -> Element(_) {
  let subcommands =
    subcommands
    |> list.map(fn(s) { #(s.name, s) })
    |> dict.from_list

  GroupElement(name:, description:, subcommands:)
}

pub fn subcommand_element(subcommand: Subcommand(_)) -> Element(_) {
  SubcommandElement(subcommand)
}

fn elements_json(
  elements: Dict(String, Element(_)),
  translator: locale.Translator,
) -> Json {
  dict.values(elements) |> json.array(element_json(_, translator))
}

fn element_json(element: Element(_), translator: locale.Translator) -> Json {
  case element {
    GroupElement(name:, description:, subcommands:) -> {
      let name_localizations =
        json.dict(translator(name), locale.to_string, json.string)
      let description_localization =
        json.dict(translator(description), locale.to_string, json.string)
      [
        #("type", json.int(2)),
        #("name", json.string(name)),
        #("name_localizations", name_localizations),
        #("description", json.string(description)),
        #("description_localizations", description_localization),
        #(
          "options",
          json.array(dict.values(subcommands), subcommand_json(_, translator)),
        ),
      ]
      |> json.object
    }
    SubcommandElement(subcommand) -> subcommand_json(subcommand, translator)
  }
}

pub opaque type Subcommand(state) {
  Subcommand(
    name: String,
    description: String,
    options: List(#(String, Option(state))),
    handler: ChatInputHandler(state),
  )
}

pub fn subcommand(
  name name: String,
  desc description: String,
  opts options: List(Option(_)),
  handler handler: ChatInputHandler(_),
) -> Subcommand(_) {
  let options =
    options
    |> list.map(fn(o) { #(o.name, o) })

  Subcommand(name:, description:, options:, handler:)
}

fn subcommand_json(
  subcommand: Subcommand(_),
  translator: locale.Translator,
) -> Json {
  let Subcommand(name:, description:, options:, ..) = subcommand
  let name_localizations =
    json.dict(translator(name), locale.to_string, json.string)
  let description_localizations =
    json.dict(translator(description), locale.to_string, json.string)

  [
    #("type", json.int(1)),
    #("name", json.string(name)),
    #("name_localizations", name_localizations),
    #("description", json.string(description)),
    #("description_localizations", description_localizations),
    #("options", options_json(options, translator)),
  ]
  |> json.object
}

pub fn handle_interaction(
  commands: Dict(String, Command(_)),
  i: Interaction,
  state: _,
) {
  case i.data {
    interaction.ChatInput(data) ->
      case dict.get(commands, data.name), data.options {
        Ok(ChatInput(handler:, ..)), command_options.Values(v) ->
          handler(i, v, state) |> Ok
        Ok(Group(elements:, ..)), command_options.Group(g) ->
          handle_group_interaction(i, state, elements, g)
        _, _ -> Error(Nil)
      }
    interaction.User(data) ->
      case dict.get(commands, data.name) {
        Ok(User(_, handler:)) -> handler(i, state) |> Ok
        _ -> Error(Nil)
      }
    interaction.Message(data) ->
      case dict.get(commands, data.name) {
        Ok(Message(_, handler:)) -> handler(i, state) |> Ok
        _ -> Error(Nil)
      }
  }
}

fn handle_group_interaction(
  i: Interaction,
  state: _,
  elements: Dict(String, Element(_)),
  group: command_options.Group,
) {
  case group {
    command_options.SubcommandElement(invoked) ->
      case dict.get(elements, invoked.name) {
        Ok(SubcommandElement(s)) -> s.handler(i, invoked.options, state) |> Ok
        _ -> Error(Nil)
      }
    command_options.GroupElement(name:, subcommand:) ->
      case dict.get(elements, name) {
        Ok(GroupElement(subcommands:, ..)) ->
          case dict.get(subcommands, subcommand.name) {
            Ok(s) -> s.handler(i, subcommand.options, state) |> Ok
            _ -> Error(Nil)
          }
        _ -> Error(Nil)
      }
  }
}

pub fn handle_autocomplete_interaction(
  commands: Dict(String, Command(_)),
  i: Interaction,
  state: _,
) {
  case i.data {
    interaction.ChatInput(data) ->
      case dict.get(commands, data.name), data.options {
        Ok(ChatInput(options:, ..)), command_options.Values(values) ->
          options_autocomplete(options, i, values, state)
        Ok(Group(elements:, ..)), command_options.Group(g) ->
          handle_group_autocomplete_interaction(g, elements, i, state)
        _, _ -> Error(Nil)
      }
    _ -> Error(Nil)
  }
}

fn handle_group_autocomplete_interaction(
  g: command_options.Group,
  elements: Dict(String, Element(_)),
  i: Interaction,
  state: _,
) -> Result(Autocomplete, Nil) {
  case g {
    command_options.SubcommandElement(invoked) ->
      case dict.get(elements, invoked.name) {
        Ok(SubcommandElement(s)) ->
          options_autocomplete(s.options, i, invoked.options, state)
        _ -> Error(Nil)
      }
    command_options.GroupElement(name:, subcommand:) ->
      case dict.get(elements, name) {
        Ok(GroupElement(subcommands:, ..)) ->
          case dict.get(subcommands, subcommand.name) {
            Ok(Subcommand(options:, ..)) ->
              options_autocomplete(options, i, subcommand.options, state)
            _ -> Error(Nil)
          }
        _ -> Error(Nil)
      }
  }
}

fn options_autocomplete(
  options: List(#(String, Option(_))),
  i: Interaction,
  values: Dict(String, command_options.Value),
  state: _,
) -> Result(Autocomplete, Nil) {
  let assert Ok(focused) = dict.values(values) |> command_options.find_focused
  case list.key_find(options, focused.name), focused {
    Ok(StringAutocompleteOption(autocomplete:, ..)),
      command_options.StringValue(value:, ..)
    ->
      autocomplete(i, values, value, state)
      |> StringAutocomplete
      |> Ok
    Ok(IntegerAutocompleteOption(autocomplete:, ..)),
      command_options.IntegerValue(value:, ..)
    ->
      autocomplete(i, values, value, state)
      |> IntegerAutocomplete
      |> Ok
    Ok(NumberAutocompleteOption(autocomplete:, ..)),
      command_options.NumberValue(value:, ..)
    ->
      autocomplete(i, values, value, state)
      |> NumberAutocomplete
      |> Ok
    _, _ -> Error(Nil)
  }
}
