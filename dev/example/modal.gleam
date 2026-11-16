import gleamcord_http
import gleamcord_http/component
import gleamcord_http/modal

fn favourite_components() {
  [
    component.StringSelectLabel(
      label: "Animal",
      description: "Your fav. animal",
      component: component.default_string_select(
        "fav-animal",
        [
          component.default_select_option("Dog", "dog"),
          component.default_select_option("Cat", "cat"),
          component.default_select_option("Snake", "snake"),
        ],
        "Select One",
      ),
    ),
    component.TextInputLabel(
      label: "Song",
      description: "Your fav. song",
      component: component.default_short_text("fav-song", ""),
    ),
  ]
}

pub fn favourite_things() {
  use _i, _f <- modal.Modal(
    custom_id: "fav-things",
    title: "Favourite Things",
    components: favourite_components(),
  )

  "Successfully submitted"
  |> gleamcord_http.basic_text_message
  |> modal.MessageResponse
}
