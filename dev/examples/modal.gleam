import gleam/dynamic/decode
import gleamcord_http.{Modal, ModalMessageResponse}
import gleamcord_http/component

pub const ice_cream_input = component.ShortTextInput(
  custom_id: "ice_cream_input",
  min_len: 1,
  max_len: 128,
  required: True,
  value: "",
  placeholder: "",
)

// TODO
pub const channel_select = component.ChannelSelect(custom_id: "channel")

pub fn modal_example() {
  use i, c <- Modal(custom_id: "modal_example", title: "Example", components: [
    component.Label(
      label: "Ice Cream Flavor",
      description: "Fav. flavour",
      component: component.LabelTextInput(ice_cream_input),
    ),
    component.Label(
      label: "Channels",
      description: "",
      component: component.LabelChannelSelect(channel_select),
    ),
  ])

  let assert Ok(resolved) =
    decode.run(i, decode.at(["data", "resolved"], decode.dynamic))
  let assert Ok(ice_cream) =
    component.get_text_input_value(c, ice_cream_input.custom_id)
  let assert Ok(channels) =
    component.get_channel_select_values(c, resolved, channel_select.custom_id)

  echo #(ice_cream, channels)

  ModalMessageResponse(todo as "Missing message type")
}
