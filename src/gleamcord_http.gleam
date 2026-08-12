import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/list
import gleam/result
import gleamcord_http/command_option.{type CommandOption}
import gleamcord_http/component

pub type Command {
  ChatCommand(
    def: CommandDefinition,
    options: List(CommandOption),
    run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
  )
  ChatCommandGroup(
    def: CommandDefinition,
    elements: List(ChatCommandGroupElement),
  )
  UserCommand(def: CommandDefinition, run: fn(Dynamic) -> CommandResponse)
  MessageCommand(def: CommandDefinition, run: fn(Dynamic) -> CommandResponse)
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

pub fn simple_definition(name name: String, desc description: String) {
  CommandDefinition(
    name:,
    description:,
    default_member_permissions: "",
    integ_types: [1],
    contexts: [1],
    nsfw: False,
  )
}

pub type ChatCommandGroupElement {
  ChatSubCommandGroup(
    name: String,
    description: String,
    sub_commands: List(ChatSubCommand),
  )
  ChatGroupSubCommand(ChatSubCommand)
}

pub fn group_sub_command(
  name name: String,
  desc description: String,
  opts options: List(CommandOption),
  run run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
) {
  ChatSubCommand(name:, description:, options:, run:)
  |> ChatGroupSubCommand
}

pub type ChatSubCommand {
  ChatSubCommand(
    name: String,
    description: String,
    options: List(CommandOption),
    run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
  )
}

pub fn sub_command(
  name name: String,
  desc description: String,
  opts options: List(CommandOption),
  run run: fn(Dynamic, Dict(String, Dynamic)) -> CommandResponse,
) {
  ChatSubCommand(name:, description:, options:, run:)
}

pub type CommandResponse {
  CommandMessageResponse(Nil)
  CommandDeferredMessageResponse(fn() -> Nil)
  CommandModalResponse(Nil)
}

pub type MessageComponent {
  ButtonMessageComponent(
    btn: component.CustomButton,
    run: fn(Dynamic) -> MessageComponentResponse,
  )
  StringSelectMessageComponent(
    select: component.StringSelect,
    run: fn(Dynamic, List(String)) -> MessageComponentResponse,
  )
  UserSelectMessageComponent(
    select: component.UserSelect,
    run: fn(Dynamic, List(Dynamic)) -> MessageComponentResponse,
  )
  RoleSelectMessageComponent(
    select: component.RoleSelect,
    run: fn(Dynamic, List(Dynamic)) -> MessageComponentResponse,
  )
  MentionableSelectMessageComponent(
    select: component.MentionableSelect,
    run: fn(Dynamic, List(Dynamic)) -> MessageComponentResponse,
  )
  ChannelSelectMessageComponent(
    select: component.ChannelSelect,
    run: fn(Dynamic, List(Dynamic)) -> MessageComponentResponse,
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

pub type HandlingError(custom_error) {
  DecodingError(List(decode.DecodeError))
  NotFound(String)
}

pub fn handle_command(
  commands commands: List(Command),
  interaction interaction: Dynamic,
) {
  use data <- result.try(
    decode.run(interaction, decode.at(["data"], decode.dynamic))
    |> result.map_error(DecodingError),
  )
  use typ <- result.try(
    decode.run(data, decode.at(["type"], decode.int))
    |> result.map_error(DecodingError),
  )
  use name <- result.try(
    decode.run(data, decode.at(["name"], decode.string))
    |> result.map_error(DecodingError),
  )
  use command <- result.try(
    list.find(commands, fn(item) { item.def.name == name })
    |> result.replace_error(NotFound("Command")),
  )

  case typ, command {
    1, ChatCommand(run:, ..) -> handle_chat_command(run, data, interaction)
    1, ChatCommandGroup(elements:, ..) ->
      handle_chat_command_group(elements, data, interaction)
    2, UserCommand(run:, ..) -> run(interaction) |> Ok
    3, MessageCommand(run:, ..) -> run(interaction) |> Ok

    _, _ -> Error(NotFound("Matching Command"))
  }
}

fn handle_chat_command(run, data: Dynamic, interaction: Dynamic) {
  use options <- result.try(
    decode.run(
      data,
      decode.at(
        ["options"],
        decode.list({
          use name <- decode.field("name", decode.string)
          use option <- decode.field([], decode.dynamic)
          decode.success(#(name, option))
        })
          |> decode.map(dict.from_list),
      ),
    )
    |> result.map_error(DecodingError),
  )

  run(interaction, options) |> Ok
}

fn handle_chat_command_group(
  elements: List(ChatCommandGroupElement),
  data: Dynamic,
  interaction: Dynamic,
) {
  use options <- result.try(
    decode.run(data, decode.at(["options"], decode.dynamic))
    |> result.map_error(DecodingError),
  )
  use sub_type <- result.try(
    decode.run(options, decode.at([0], decode.at(["type"], decode.int)))
    |> result.map_error(DecodingError),
  )
  use name <- result.try(
    decode.run(options, decode.at([0], decode.at(["name"], decode.string)))
    |> result.map_error(DecodingError),
  )
  use element <- result.try(
    list.find(elements, fn(item) {
      case item {
        ChatSubCommandGroup(name: group_name, ..) -> group_name == name
        ChatGroupSubCommand(command) -> command.name == name
      }
    })
    |> result.replace_error(NotFound("Command")),
  )
  case sub_type, element {
    1, ChatSubCommandGroup(sub_commands:, ..) ->
      handle_chat_sub_command_group(sub_commands, options, interaction)
    2, ChatGroupSubCommand(command) -> {
      use options <- result.try(
        decode.run(
          options,
          decode.at(
            [0],
            decode.at(
              ["options"],
              decode.list({
                use name <- decode.field("name", decode.string)
                use option <- decode.field([], decode.dynamic)
                decode.success(#(name, option))
              }),
            ),
          )
            |> decode.map(dict.from_list),
        )
        |> result.map_error(DecodingError),
      )
      command.run(interaction, options) |> Ok
    }
    _, _ -> Error(NotFound("Matching SubCommand/SubCommandGroup"))
  }
}

fn handle_chat_sub_command_group(
  elements: List(ChatSubCommand),
  options: Dynamic,
  interaction: Dynamic,
) {
  use options <- result.try(
    decode.run(options, decode.at([0], decode.at(["options"], decode.dynamic)))
    |> result.map_error(DecodingError),
  )
  use name <- result.try(
    decode.run(options, decode.at(["name"], decode.string))
    |> result.map_error(DecodingError),
  )
  use sub_command <- result.try(
    list.find(elements, fn(item) { item.name == name })
    |> result.replace_error(NotFound("SubCommand")),
  )
  use option_values <- result.try(
    decode.run(
      options,
      decode.list({
        use name <- decode.field("name", decode.string)
        use value <- decode.field([], decode.dynamic)
        decode.success(#(name, value))
      })
        |> decode.map(dict.from_list),
    )
    |> result.map_error(DecodingError),
  )

  sub_command.run(interaction, option_values) |> Ok
}
