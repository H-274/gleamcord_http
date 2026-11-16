import gleam/list
import gleam/string
import gleamcord_http
import gleamcord_http/component.{SelectOption, StringSelect}

pub fn next_button() {
  gleamcord_http.Button(
    component: component.default_primary_button("next", "Next"),
    handler: next_button_handler,
  )
}

pub fn next_button_handler(_i) {
  "Next message step"
  |> gleamcord_http.basic_text_message
  |> gleamcord_http.ComponentMessageResponse
}

pub fn tag_select() {
  gleamcord_http.StringSelect(
    component: StringSelect(
      ..component.default_string_select("tag-select", get_tags(), "Tags"),
      max_values: 3,
    ),
    handler: tag_select_handler,
  )
}

fn get_tags() {
  // Get list of tags
  let tags: List(String) = []

  use tag <- list.map(tags)
  SelectOption(
    ..component.default_select_option(string.capitalise(tag), tag),
    description: "Tagged with " <> tag,
  )
}

pub fn tag_select_handler(_i, _values) {
  "New results"
  |> gleamcord_http.basic_text_message
  |> gleamcord_http.ComponentMessageResponse
}
