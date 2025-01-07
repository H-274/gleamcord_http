import message_component/button_component.{type ButtonComponent}
import message_component/text_input_component.{type TextInputComponent}

pub type Response {
  JsonString(String)
}

pub type Error {
  NotImplemented
}

/// TODO
pub type MessageComponent(ctx) {
  ButtonComponent(ButtonComponent(ctx))
  TextInput(TextInputComponent(ctx))
}
