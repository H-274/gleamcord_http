import gleam/list
import gleam/string
import gleamcord_http
import gleamcord_http/component.{PrimaryButton, SelectOption, StringSelect}

pub const next_button =
  gleamcord_http.Button(
    component: PrimaryButton(
      ..component.default_primary_button,
      custom_id: "next",
      label: "Next",
    ),
    handler: next_button_handler,
  )

pub fn next_button_handler(_i) {
  "Next message step"
  |> gleamcord_http.ComponentMessageResponse
}

pub fn tag_select() {
  gleamcord_http.StringSelect(
    component: StringSelect(
      ..component.default_string_select,
      custom_id: "tag-select",
      options: get_tags(),
      placeholder: "Tags",
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
    ..component.default_select_option,
    label: string.capitalise(tag),
    value: tag,
    description: "Tagged with " <> tag,
  )
}

pub fn tag_select_handler(_i, _values) {
  "New results"
  |> gleamcord_http.ComponentMessageResponse
}
