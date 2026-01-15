import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}

pub type ApplicationCommand {
  ChatInputApplicationCommand(
    id: String,
    name: String,
    resolved: Option(Resolved),
    options: List(Dynamic),
    guild_id: Option(String),
    target_id: Option(String),
  )
  UserApplicationCommand(
    id: String,
    name: String,
    resolved: Option(Resolved),
    guild_id: Option(String),
    target_id: Option(String),
  )
  MessageApplicationCommand(
    id: String,
    name: String,
    resolved: Option(Resolved),
    guild_id: Option(String),
    target_id: Option(String),
  )
}

pub fn application_command_decoder() -> decode.Decoder(ApplicationCommand) {
  use variant <- decode.field("type", decode.string)
  case variant {
    "1" -> {
      use id <- decode.field("id", decode.string)
      use name <- decode.field("name", decode.string)
      use resolved <- decode.field(
        "resolved",
        decode.optional(resolved_decoder()),
      )
      use options <- decode.field("options", decode.list(decode.dynamic))
      use guild_id <- decode.field("guild_id", decode.optional(decode.string))
      use target_id <- decode.field("target_id", decode.optional(decode.string))
      decode.success(ChatInputApplicationCommand(
        id:,
        name:,
        resolved:,
        options:,
        guild_id:,
        target_id:,
      ))
    }
    "2" -> {
      use id <- decode.field("id", decode.string)
      use name <- decode.field("name", decode.string)
      use resolved <- decode.field(
        "resolved",
        decode.optional(resolved_decoder()),
      )
      use guild_id <- decode.field("guild_id", decode.optional(decode.string))
      use target_id <- decode.field("target_id", decode.optional(decode.string))
      decode.success(UserApplicationCommand(
        id:,
        name:,
        resolved:,
        guild_id:,
        target_id:,
      ))
    }
    "3" -> {
      use id <- decode.field("id", decode.string)
      use name <- decode.field("name", decode.string)
      use resolved <- decode.field(
        "resolved",
        decode.optional(resolved_decoder()),
      )
      use guild_id <- decode.field("guild_id", decode.optional(decode.string))
      use target_id <- decode.field("target_id", decode.optional(decode.string))
      decode.success(MessageApplicationCommand(
        id:,
        name:,
        resolved:,
        guild_id:,
        target_id:,
      ))
    }
    _ ->
      decode.failure(
        ChatInputApplicationCommand(
          id: "",
          name: "",
          resolved: option.None,
          options: [],
          guild_id: option.None,
          target_id: option.None,
        ),
        "ApplicationCommand",
      )
  }
}

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
    decode.optional(resolved_decoder()),
  )
  decode.success(ModalSubmit(custom_id:, components:, resolved:))
}

pub type Resolved {
  Resolved(
    users: Option(List(#(String, Dynamic))),
    members: Option(List(#(String, Dynamic))),
    roles: Option(List(#(String, Dynamic))),
    channels: Option(List(#(String, Dynamic))),
    messages: Option(List(#(String, Dynamic))),
    attachments: Option(List(#(String, Dynamic))),
  )
}

pub fn resolved_decoder() -> decode.Decoder(Resolved) {
  use users <- decode.optional_field(
    "users",
    option.None,
    decode.optional(
      decode.list({
        use a <- decode.field(0, decode.string)
        use b <- decode.field(1, decode.dynamic)

        decode.success(#(a, b))
      }),
    ),
  )
  use members <- decode.optional_field(
    "members",
    option.None,
    decode.optional(
      decode.list({
        use a <- decode.field(0, decode.string)
        use b <- decode.field(1, decode.dynamic)

        decode.success(#(a, b))
      }),
    ),
  )
  use roles <- decode.optional_field(
    "roles",
    option.None,
    decode.optional(
      decode.list({
        use a <- decode.field(0, decode.string)
        use b <- decode.field(1, decode.dynamic)

        decode.success(#(a, b))
      }),
    ),
  )
  use channels <- decode.optional_field(
    "channels",
    option.None,
    decode.optional(
      decode.list({
        use a <- decode.field(0, decode.string)
        use b <- decode.field(1, decode.dynamic)

        decode.success(#(a, b))
      }),
    ),
  )
  use messages <- decode.optional_field(
    "messages",
    option.None,
    decode.optional(
      decode.list({
        use a <- decode.field(0, decode.string)
        use b <- decode.field(1, decode.dynamic)

        decode.success(#(a, b))
      }),
    ),
  )
  use attachments <- decode.optional_field(
    "attachments",
    option.None,
    decode.optional(
      decode.list({
        use a <- decode.field(0, decode.string)
        use b <- decode.field(1, decode.dynamic)

        decode.success(#(a, b))
      }),
    ),
  )
  decode.success(Resolved(
    users:,
    members:,
    roles:,
    channels:,
    messages:,
    attachments:,
  ))
}
