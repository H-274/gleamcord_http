import gleamcord_http
import gleamcord_http/component

fn modal_components() {
  [
    component.StringSelectLabel(
      label: "Animal",
      description: "Your Fav. Animal",
      component: component.default_string_select(
        "fav-animal",
        [
          component.default_select_option("Dog", "dog"),
          component.default_select_option("Cat", "cat"),
          component.default_select_option("Snake", "snake"),
          component.default_select_option("Fish", "fish"),
        ],
        "",
      ),
    ),
    component.TextInputLabel(
      label: "Reason",
      description: "",
      component: component.default_long_text(
        "reason",
        "Explain why it's your fav.",
      ),
    ),
  ]
}

pub fn test_modal() {
  use _i, _v <- gleamcord_http.GleamcordModal(
    custom_id: "test-modal",
    title: "Test",
    components: modal_components(),
  )

  "Answers submitted"
  |> gleamcord_http.basic_text_message
  |> gleamcord_http.ModalMessageResponse
}
