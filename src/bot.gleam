import application_command.{type ApplicationCommand}
import gleam/set.{type Set}

pub type Bot(ctx) {
  Bot(
    application_id: String,
    token: String,
    public_key: String,
    commands: Set(ApplicationCommand(Bot(ctx))),
  )
}

pub fn new(
  app_id application_id: String,
  token token: String,
  pub_key public_key: String,
) {
  let commands = set.new()
  Bot(application_id:, token:, public_key:, commands:)
}

pub fn commands(bot: Bot(ctx), commands: List(ApplicationCommand(Bot(ctx)))) {
  let commands = set.from_list(commands)
  Bot(..bot, commands:)
}

pub fn add_command(bot: Bot(ctx), command: ApplicationCommand(Bot(ctx))) {
  let commands = set.insert(bot.commands, command)
  Bot(..bot, commands:)
}
