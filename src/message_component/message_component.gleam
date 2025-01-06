import message_component/button_component.{type ButtonComponent}

pub type Response {
  JsonString(String)
}

pub type Error {
  NotImplemented
}

/// TODO
pub type MessageComponent(ctx) {
  ButtonComponent(ButtonComponent(ctx))
}
