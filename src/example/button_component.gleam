import message_component/button_component

pub fn primary_btn() -> button_component.ButtonComponent(Nil) {
  let define_handler = fn(handler) {
    button_component.new_primary("agree")
    |> button_component.primary_label("Agree")
    |> button_component.primary_handler(handler)
  }

  use _i, _bot, _ctx <- define_handler()
  Error(button_component.NotImplemented)
}
