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
pub const channel_select = component.ChannelSelect

pub fn modal_example() {
  let set_modal_submit = fn(run) {
    Modal("modal_example", "Example", run:, components: [
      component.LabelTextInput(ice_cream_input)
        |> component.Label(
          label: "Ice Cream Flavor",
          description: "Fav. flavour",
        ),
      component.LabelChannelSelect(channel_select)
        |> component.Label(label: "Channels", description: ""),
    ])
  }

  use interaction, components <- set_modal_submit
  let assert Ok(resolved) =
    decode.run(interaction, decode.at(["data", "resolved"], decode.dynamic))
  let assert Ok(ice_cream) =
    component.get_text_input_value(components, ice_cream_input.custom_id)
  let assert Ok(channels) =
    component.get_channel_select_value(components, resolved, todo)

  echo #(ice_cream, channels)

  ModalMessageResponse(todo as "Missing message type")
}
