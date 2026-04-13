import component/interactive.{ShortTextInput}
import component/layout
import modal/modal

const modal_nickname = layout.Label(
  "Nickname",
  "",
  modal.TextInput(
    ShortTextInput(
      custom_id: "nickname",
      required: True,
      value: "",
      placeholder: "Joe",
      min_len: 1,
      max_len: 100,
    ),
  ),
)

pub fn about_me() {
  let components = [modal_nickname]
  use _i, _s, values <- modal.new("about-me", "About me", components:)
  todo
}
