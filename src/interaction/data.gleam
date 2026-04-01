import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}
import resolved.{type Resolved}

// TODO: revisit asserting types and structure to avoid needing to pass on a dynamic type
pub type MessageComponent {
  MessageComponent(
    custom_id: String,
    component_type: String,
    values: Option(List(Dynamic)),
    resolved: Option(Dynamic),
  )
}

pub fn message_component_decoder() -> decode.Decoder(MessageComponent) {
  use custom_id <- decode.field("custom_id", decode.string)
  use component_type <- decode.field("component_type", decode.string)
  use values <- decode.optional_field(
    "values",
    option.None,
    decode.optional(decode.list(decode.dynamic)),
  )
  use resolved <- decode.optional_field(
    "resolved",
    option.None,
    decode.optional(decode.dynamic),
  )
  decode.success(MessageComponent(
    custom_id:,
    component_type:,
    values:,
    resolved:,
  ))
}

pub type ModalSubmit {
  ModalSubmit(
    custom_id: String,
    components: List(Dynamic),
    resolved: Option(Resolved),
  )
}

pub fn modal_submit_decoder() -> decode.Decoder(ModalSubmit) {
  use custom_id <- decode.field("custom_id", decode.string)
  use components <- decode.field("components", decode.list(decode.dynamic))
  use resolved <- decode.optional_field(
    "resolved",
    option.None,
    decode.optional(resolved.decoder()),
  )
  decode.success(ModalSubmit(custom_id:, components:, resolved:))
}
