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

pub const modal_example = Modal(
  custom_id: "modal_example",
  title: "Example",
  components: [
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
  ],
  run: modal_handler,
)

fn modal_handler(interaction, components) {
  let assert Ok(resolved) =
    decode.run(interaction, decode.at(["data", "resolved"], decode.dynamic))
  let assert Ok(ice_cream) =
    component.get_text_input_value(components, ice_cream_input.custom_id)
  let assert Ok(channels) =
    component.get_channel_select_values(
      components,
      resolved,
      channel_select.custom_id,
    )

  echo #(ice_cream, channels)

  ModalMessageResponse(todo as "Missing message type")
}
