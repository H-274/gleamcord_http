import message_component/button_component.{type ButtonComponent}
import message_component/select_component.{type SelectComponent}
import message_component/text_input_component.{type TextInputComponent}

pub type Response {
  JsonString(String)
}

pub type Error {
  NotImplemented
}

pub type MessageComponent(ctx) {
  Button(ButtonComponent(ctx))
  TextInput(TextInputComponent(ctx))
  Select(SelectComponent(ctx))
}
