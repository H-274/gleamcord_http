import gleam/list
import gleam/result
import interaction.{type Interaction}
import interaction/application_command
import interaction/application_command/chat_input
import interaction/application_command/message
import interaction/application_command/user

/// TODO: add message components and modal submits
pub type Bot(ctx) {
  Bot(
    pub_key: String,
    chat_commands: List(
      #(String, chat_input.Command(Bot(ctx), Success, Failure)),
    ),
    message_commands: List(
      #(String, message.Command(Bot(ctx), Success, Failure)),
    ),
    user_commands: List(#(String, user.Command(Bot(ctx), Success, Failure))),
    context: ctx,
  )
}

pub fn handle_interaction(
  bot: Bot(_),
  interaction: Interaction,
) -> Result(Success, Failure) {
  case interaction {
    interaction.Ping(_) -> Ok(Pong)
    interaction.ApplicationCommand(i) -> handle_command(bot, i)
    interaction.ApplicationCommandAutocomplete(_i) ->
      todo as "Missing logic for application command autocompletion"
    interaction.MessageComponent(_i) ->
      todo as "Missing logic for message components"
    interaction.ModalSubmit(_i) -> todo as "Missing logic for modal submissions"
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
    list.key_find(bot.chat_commands, interaction.name)
    |> result.replace_error(NotFound),
  )
  use handler <- result.try(
    chat_input.extract_command_handler(command, interaction.options)
    |> result.replace_error(NotFound),
  )

  handler(interaction, bot)
}

fn handle_message_command(bot: Bot(_), interaction: message.Interaction) {
  use command <- result.try(
    list.key_find(bot.message_commands, interaction.name)
    |> result.replace_error(NotFound),
  )

  command.handler(interaction, bot)
}

fn handle_user_command(bot: Bot(_), interaction: user.Interaction) {
  use command <- result.try(
    list.key_find(bot.user_commands, interaction.name)
    |> result.replace_error(NotFound),
  )

  command.handler(interaction, bot)
}

pub type Success {
  Pong
  MessageReply
  MessageUpdate
  Deferred
}

pub type Failure {
  NotFound
  InternalServerError
  Other(String)
}
