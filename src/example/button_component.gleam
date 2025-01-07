import gleam/dynamic
import message_component/buttons/styled_button.{type StyledButton}

pub fn styled_button() -> StyledButton(Nil) {
  let define_button = fn(handler) {
    styled_button.new_with_label("agree", styled_button.Primary, "Agree")
    |> styled_button.emoji(dynamic.from(""))
    |> styled_button.handler(handler)
  }

  use _i, _bot, _ctx <- define_button()
  Error(styled_button.NotImplemented)
}
