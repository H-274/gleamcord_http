import application_command.{type ApplicationCommand}

pub type Bot(ctx) {
  Bot(
    application_id: String,
    token: String,
    public_key: String,
    commands: List(ApplicationCommand(Bot(ctx))),
  )
}
