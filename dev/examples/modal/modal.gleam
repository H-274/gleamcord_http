import component/interactive.{LongTextInput, ShortTextInput}
import component/layout
import gleam/dict
import message
import modal/modal
import modal/response

const nickname_input = ShortTextInput(
  custom_id: "nickname",
  required: True,
  value: "",
  placeholder: "Joe",
  min_len: 1,
  max_len: 100,
)

const description_input = LongTextInput(
  custom_id: "description",
  required: False,
  value: "",
  placeholder: "I am ...",
  min_len: 0,
  max_len: 4000,
)

pub fn about_me() {
  let components = [
    layout.Label(
      label: "Nickname",
      description: "",
      component: modal.TextInput(nickname_input),
    ),
    layout.Label(
      label: "Description",
      description: "A bit about yourself",
      component: modal.TextInput(description_input),
    ),
  ]
  use _i, _s, values <- modal.new("about-me", "About me", components:)
  let assert Ok(nickname) = dict.get(values, nickname_input.custom_id)

  echo nickname

  { "Form submitted!" }
  |> message.NewText([])
  |> response.MessageWithSource
}
