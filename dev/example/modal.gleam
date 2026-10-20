import gleamcord_http
import gleamcord_http/component

pub const test_modal =
  gleamcord_http.GleamcordModal(
    custom_id: "test-modal",
    title: "Test",
    components: [
      component.StringSelectLabel(
        label: "Animal",
        description: "Your Fav. Animal",
        component: fav_animal_component,
      ),
      component.TextInputLabel(
        label: "Reason",
        description: "",
        component: reason_component,
      ),
    ],
    handler: test_modal_handler,
  )

const fav_animal_component =
  component.StringSelect(
    ..component.default_string_select,
    custom_id: "fav-animal",
    options: [
      component.SelectOption(
        ..component.default_select_option,
        label: "Dog",
        value: "dog",
      ),
      component.SelectOption(
        ..component.default_select_option,
        label: "Cat",
        value: "cat",
      ),
      component.SelectOption(
        ..component.default_select_option,
        label: "Snake",
        value: "snake",
      ),
      component.SelectOption(
        ..component.default_select_option,
        label: "Fish",
        value: "fish",
      ),
    ],
  )

const reason_component =
  component.LongTextInput(
    ..component.default_long_text,
    custom_id: "reson",
    placeholder: "Explain why it's your fav.",
  )

fn test_modal_handler(_i, _v) {
  "Answers submitted"
  |> gleamcord_http.ModalMessageResponse
}
