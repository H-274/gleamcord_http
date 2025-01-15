import command/command.{type Command}
import credentials.{type Credentials}
import message_component/message_component.{type MessageComponent}

/// TODO
pub type Configuration(ctx) {
  Configuration(
    credentials: Credentials,
    commands: List(Command(ctx)),
    components: List(MessageComponent(ctx)),
  )
}
