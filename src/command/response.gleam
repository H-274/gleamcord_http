import entities/message

pub type Response {
  Message(message.Create)
  // TODO
  ComponentMessage(Nil)
}
