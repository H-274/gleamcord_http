pub type Interaction {
  Interaction
}

pub type Command(bot, success, failure) {
  Command(handler: Handler(bot, success, failure))
}

pub type Handler(bot, success, failure) =
  fn(Interaction, bot) -> Result(success, failure)
