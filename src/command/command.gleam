import command/interaction.{type Interaction}
import command/option_value
import gleam/dict.{type Dict}
import gleam/json.{type Json}
import gleam/list
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

pub fn json(command: Command(_)) -> Json {
  let signature_json = signature_json(command.signature)
  case command {
    ChatInput(options:, ..) -> [
      #("type", json.int(1)),
      #("options", options_json(options)),
      ..signature_json
    ]
    Group(elements:, ..) -> [
      #("type", json.int(1)),
      #("options", elements_json(elements)),
      ..signature_json
    ]
    User(..) -> [#("type", json.int(2)), ..signature_json]
    Message(..) -> [#("type", json.int(3)), ..signature_json]
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
    default_member_permissions: "",
    integrations: [],
    contexts: [],
    nsfw: False,
  )
}

fn signature_json(signature: Signature) -> List(#(String, Json)) {
  let Signature(
    name:,
    description:,
    default_member_permissions:,
    integrations:,
    contexts:,
    nsfw:,
  ) = signature

  [
    #("name", json.string(name)),
    #("description", json.string(description)),
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
    channel_types: List(Nil),
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

fn options_json(options: List(#(String, Option(_)))) -> Json {
  list.map(options, fn(o) { o.1 }) |> json.array(option_json)
}

fn option_json(option: Option(_)) -> Json {
  let name = option.name
  let description = option.description
  let required = option.required
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
      #("channel_types", todo),
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

  [
    #("name", json.string(name)),
    #("description", json.string(description)),
    #("required", json.bool(required)),
    ..distinct_fields
  ]
  |> json.object
}

pub type ChatInputHandler(state) =
  fn(Interaction, Dict(String, option_value.Value), state) -> Response(state)

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
  fn(Interaction, Dict(String, option_value.Value), t, state) ->
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

fn elements_json(elements: Dict(String, Element(_))) -> Json {
  dict.values(elements) |> json.array(element_json)
}

fn element_json(element: Element(_)) -> Json {
  case element {
    GroupElement(name:, description:, subcommands:) ->
      [
        #("type", json.int(2)),
        #("name", json.string(name)),
        #("description", json.string(description)),
        #("options", json.array(dict.values(subcommands), subcommand_json)),
      ]
      |> json.object
    SubcommandElement(subcommand) -> subcommand_json(subcommand)
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

fn subcommand_json(subcommand: Subcommand(_)) -> Json {
  let Subcommand(name:, description:, options:, ..) = subcommand

  [
    #("type", json.int(1)),
    #("name", json.string(name)),
    #("description", json.string(description)),
    #("options", options_json(options)),
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
        Ok(ChatInput(handler:, ..)), option_value.Values(v) ->
          handler(i, v, state) |> Ok
        Ok(Group(elements:, ..)), option_value.Group(g) ->
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
  group: option_value.Group,
) {
  case group {
    option_value.SubcommandElement(invoked) ->
      case dict.get(elements, invoked.name) {
        Ok(SubcommandElement(s)) -> s.handler(i, invoked.options, state) |> Ok
        _ -> Error(Nil)
      }
    option_value.GroupElement(name:, subcommand:) ->
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
        Ok(ChatInput(options:, ..)), option_value.Values(values) ->
          options_autocomplete(options, i, values, state)
        Ok(Group(elements:, ..)), option_value.Group(g) ->
          handle_group_autocomplete_interaction(g, elements, i, state)
        _, _ -> Error(Nil)
      }
    _ -> Error(Nil)
  }
}

fn handle_group_autocomplete_interaction(
  g: option_value.Group,
  elements: Dict(String, Element(_)),
  i: Interaction,
  state: _,
) -> Result(Autocomplete, Nil) {
  case g {
    option_value.SubcommandElement(invoked) ->
      case dict.get(elements, invoked.name) {
        Ok(SubcommandElement(s)) ->
          options_autocomplete(s.options, i, invoked.options, state)
        _ -> Error(Nil)
      }
    option_value.GroupElement(name:, subcommand:) ->
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
  values: Dict(String, option_value.Value),
  state: _,
) -> Result(Autocomplete, Nil) {
  let assert Ok(focused) = dict.values(values) |> option_value.find_focused
  case list.key_find(options, focused.name), focused {
    Ok(StringAutocompleteOption(autocomplete:, ..)),
      option_value.StringValue(value:, ..)
    ->
      autocomplete(i, values, value, state)
      |> StringAutocomplete
      |> Ok
    Ok(IntegerAutocompleteOption(autocomplete:, ..)),
      option_value.IntegerValue(value:, ..)
    ->
      autocomplete(i, values, value, state)
      |> IntegerAutocomplete
      |> Ok
    Ok(NumberAutocompleteOption(autocomplete:, ..)),
      option_value.NumberValue(value:, ..)
    ->
      autocomplete(i, values, value, state)
      |> NumberAutocomplete
      |> Ok
    _, _ -> Error(Nil)
  }
}
