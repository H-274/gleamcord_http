import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/option.{type Option}

pub type ChannelType {
  GuildText
  DM
  GuildVoice
  GroupDM
  GuildCategory
  GuildAnnouncement
  AnnouncementThread
  PublicThread
  PrivateThread
  GuildStageVoice
  GuildDirectory
  GuildForum
  GuildMedia
}

pub fn channel_type_int(typ: ChannelType) {
  case typ {
    GuildText -> 0
    DM -> 1
    GuildVoice -> 2
    GroupDM -> 3
    GuildCategory -> 4
    GuildAnnouncement -> 5
    AnnouncementThread -> 10
    PublicThread -> 11
    PrivateThread -> 12
    GuildStageVoice -> 13
    GuildDirectory -> 14
    GuildForum -> 15
    GuildMedia -> 16
  }
}

pub type Resolved {
  Resolved(
    users: Option(Dict(String, Dynamic)),
    members: Option(Dict(String, Dynamic)),
    roles: Option(Dict(String, Dynamic)),
    channels: Option(Dict(String, Dynamic)),
    messages: Option(Dict(String, Dynamic)),
    attachments: Option(Dict(String, Dynamic)),
  )
}

pub fn resolved_decoder() -> decode.Decoder(Resolved) {
  use users <- decode.optional_field(
    "users",
    option.None,
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use members <- decode.optional_field(
    "members",
    option.None,
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use roles <- decode.optional_field(
    "roles",
    option.None,
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use channels <- decode.optional_field(
    "channels",
    option.None,
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use messages <- decode.optional_field(
    "messages",
    option.None,
    decode.optional(decode.dict(decode.string, decode.dynamic)),
  )
  use attachments <- decode.optional_field(
    "attachments",
    option.None,
    decode.optional(decode.dict(decode.string, decode.dynamic)),
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
