import gleam/dynamic.{type Dynamic}

pub type Success {
  Pong
  MessageReply(Message)
  MessageUpdate(Message)
  Deferred
}

const default_message = Message(False, "", [], Nil, 0, [], Nil)

pub type Message {
  Message(
    tts: Bool,
    content: String,
    embeds: List(Dynamic),
    allowed_mentions: Nil,
    flags: Int,
    components: List(Dynamic),
    poll: Nil,
  )
}

/// Always Ok
pub fn new_message_reply(
  with: fn(Message) -> Message,
) -> Result(Success, Failure) {
  Ok(MessageReply(with(default_message)))
}

/// Always Ok
pub fn new_message_update(
  with: fn(Message) -> Message,
) -> Result(Success, Failure) {
  Ok(MessageUpdate(with(default_message)))
}

pub type Failure {
  NotFound
  NotImplemented
  InternalServerError
  Other(String)
}
