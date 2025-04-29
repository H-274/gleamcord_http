import gleam/json

/// TODO
pub type Message {
  Message(String)
}

pub fn json(message: Message) {
  let Message(content) = message

  json.object([#("content", json.string(content))])
}
