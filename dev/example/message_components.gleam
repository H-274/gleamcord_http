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
      custom_id: "tag-select",
      options: get_tags(),
      placeholder: "Tags",
      min_values: 1,
      max_values: 3,
      required: True,
      disabled: False,
    ),
    handler: tag_select_handler,
  )
}

fn get_tags() {
  let tags: List(String) = todo as "get list of tags"
  list.map(tags, fn(tag) {
    SelectOption(
      label: string.capitalise(tag),
      value: tag,
      description: "Tagged with " <> tag,
      emoji: option.None,
      default: False,
    )
  })
  |> list.take(25)
}

pub fn tag_select_handler(_i, values) {
  todo
}
