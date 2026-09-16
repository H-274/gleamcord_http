import gleamcord_http.{Modal, ModalMessageResponse}
import gleamcord_http/component
import gleamcord_http/discord

pub const ice_cream_input = component.ShortTextInput(
  custom_id: "ice_cream_input",
  min_len: 1,
  max_len: 128,
  required: True,
  value: "",
  placeholder: "",
)

pub const channel_select = component.ChannelSelect(custom_id: "channel")

pub fn modal_example() {
  use _i, d, c <- Modal(
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
  )

  let assert Ok(ice_cream) =
    discord.component_text_input(c, ice_cream_input.custom_id)
  let assert Ok(channels) =
    discord.component_channel_select(c, channel_select.custom_id, d.resolved)

  echo #(ice_cream, channels)

  ModalMessageResponse(todo as "Missing message type")
}
