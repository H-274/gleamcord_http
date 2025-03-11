import gleam/dict.{type Dict}
import gleam/result
import interaction.{type Interaction}
import interaction/application_command
import interaction/application_command/chat_input
import interaction/application_command/message
import interaction/application_command/user
import interaction/autocomplete
import interaction/message_component
import interaction/modal_submit
import interaction/response

/// TODO: add message components and modal submits
pub opaque type Bot(ctx) {
  Bot(
    public_ley: String,
    context: ctx,
    chat_commands: Dict(String, chat_input.Command(Bot(ctx))),
    message_commands: Dict(String, message.Command(Bot(ctx))),
    user_commands: Dict(String, user.Command(Bot(ctx))),
  )
}

pub fn new(public_ley: String, context: ctx) -> Bot(ctx) {
  Bot(
    public_ley:,
    context:,
    chat_commands: dict.from_list([]),
    message_commands: dict.from_list([]),
    user_commands: dict.from_list([]),
  )
}

pub fn get_key(bot: Bot(_)) {
  let Bot(public_ley: key, ..) = bot
  key
}

pub fn add_chat_command(bot: Bot(ctx), command: chat_input.Command(Bot(ctx))) {
  let Bot(chat_commands: commands, ..) = bot
  let chat_commands = dict.insert(commands, command.name, command)

  Bot(..bot, chat_commands:)
}

pub fn add_message_command(bot: Bot(ctx), command: message.Command(Bot(ctx))) {
  let Bot(message_commands: commands, ..) = bot
  let message_commands = dict.insert(commands, command.name, command)

  Bot(..bot, message_commands:)
}

pub fn add_user_command(bot: Bot(ctx), command: user.Command(Bot(ctx))) {
  let Bot(user_commands: commands, ..) = bot
  let user_commands = dict.insert(commands, command.name, command)

  Bot(..bot, user_commands:)
}

pub fn handle_interaction(
  bot: Bot(_),
  interaction: Interaction,
) -> Result(response.Success, response.Failure) {
  case interaction {
    interaction.Ping(_) -> Ok(response.Pong)
    interaction.ApplicationCommand(i) -> handle_command(bot, i)
    interaction.ApplicationCommandAutocomplete(i) ->
      handle_command_autcomplete(bot, i)
    interaction.MessageComponent(i) -> handle_message_component(bot, i)
    interaction.ModalSubmit(i) -> handle_modal_submit(bot, i)
  }
}

fn handle_command(bot: Bot(_), interaction: application_command.Interaction) {
  case interaction {
    application_command.ChatInputInteraction(i) ->
      handle_chat_input_command(bot, i)
    application_command.MessageInteraction(i) -> handle_message_command(bot, i)
    application_command.UserInteraction(i) -> handle_user_command(bot, i)
  }
}

fn handle_chat_input_command(bot: Bot(_), interaction: chat_input.Interaction) {
  use command <- result.try(
    dict.get(bot.chat_commands, interaction.name)
    |> result.replace_error(response.NotFound),
  )
  use handler <- result.try(
    chat_input.extract_command_handler(command, interaction.options)
    |> result.replace_error(response.NotFound),
  )

  handler(interaction, bot)
}

fn handle_message_command(bot: Bot(_), interaction: message.Interaction) {
  use command <- result.try(
    dict.get(bot.message_commands, interaction.name)
    |> result.replace_error(response.NotFound),
  )

  command.handler(interaction, bot)
}

fn handle_user_command(bot: Bot(_), interaction: user.Interaction) {
  use command <- result.try(
    dict.get(bot.user_commands, interaction.name)
    |> result.replace_error(response.NotFound),
  )

  command.handler(interaction, bot)
}

fn handle_command_autcomplete(
  bot: Bot(_),
  interaction: autocomplete.Interaction,
) {
  let _ = bot
  let _ = interaction
  todo as "Missing autocomplete handler logic"
}

fn handle_message_component(
  bot: Bot(_),
  interaction: message_component.Interaction,
) {
  let _ = bot
  let _ = interaction
  todo as "Missing message component handler logic"
}

fn handle_modal_submit(bot: Bot(_), interaction: modal_submit.Interaction) {
  let _ = bot
  let _ = interaction
  todo as "Missing modal submit handler logic"
}
