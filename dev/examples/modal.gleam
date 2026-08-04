import gleam/dict
import gleam/option
import gleamcord_http
import gleamcord_http/component/interactive.{
  LongTextInput, SelectOption, ShortTextInput, StringSelect,
}
import gleamcord_http/component/layout
import gleamcord_http/message

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

const fav_animal = StringSelect(
  custom_id: "fav-animal",
  options: [
    dog_option,
    cat_option,
    snake_option,
  ],
  placeholder: "",
  min_values: 1,
  max_values: 1,
  required: True,
  disabled: True,
)

const dog_option = SelectOption(
  label: "Dog",
  value: "DOG",
  description: "",
  emoji: option.None,
  default: False,
)

const cat_option = SelectOption(
  label: "Cat",
  value: "CAT",
  description: "",
  emoji: option.None,
  default: False,
)

const snake_option = SelectOption(
  label: "Snake",
  value: "SNAKE",
  description: "",
  emoji: option.None,
  default: False,
)

pub fn about_me() {
  let id = "about-me"
  let title = "About me"
  let components = [
    layout.Label(
      label: "Nickname",
      description: "",
      component: layout.LabelTextInput(nickname_input),
    ),
    layout.Label(
      label: "Description",
      description: "A bit about yourself",
      component: layout.LabelTextInput(description_input),
    ),
    layout.Label(
      label: "Favourite animal",
      description: "",
      component: layout.LabelStringSelect(fav_animal),
    ),
  ]

  use _interaction, values <- gleamcord_http.modal(id:, title:, components:)
  let assert Ok(nickname) = dict.get(values, nickname_input.custom_id)
  let assert Ok(description) = dict.get(values, description_input.custom_id)
  let assert Ok(animal) = dict.get(values, fav_animal.custom_id)

  echo #(nickname, description, animal)

  { "Form submitted!" }
  |> message.NewText([])
  |> gleamcord_http.MessageResponse
}
