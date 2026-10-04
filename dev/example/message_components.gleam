import gleam/list
import gleam/option
import gleam/string
import gleamcord_http
import gleamcord_http/component.{
  PrimaryButton, SelectOption, StringButton, StringSelect,
}

pub const next_button = gleamcord_http.Button(
  component: PrimaryButton(
    custom_id: "next",
    appearance: StringButton("Next"),
    disabled: False,
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
    label: string.capitalise(tag),
    value: tag,
    description: "Tagged with " <> tag,
    emoji: option.None,
    default: False,
  )
}

pub fn tag_select_handler(_i, _values) {
  "New results"
  |> gleamcord_http.ComponentMessageResponse
}
