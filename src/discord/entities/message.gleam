import gleam/json.{type Json}

/// TODO
pub type Message {
  Message(String)
}

pub fn json(message: Message) -> Json {
  let Message(content) = message

  json.object([#("content", json.string(content))])
}
