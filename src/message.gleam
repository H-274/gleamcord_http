import component/layout
import gleam/int
import gleam/json.{type Json}
import gleam/list

/// For responses, ephemeral is available. Otherwise, only the suppression flags and `IsVoiceMessage` are available. `IsComponentsV2` will be automatically added depending on the variant used
pub type New {
  Raw(json: Json)
  NewText(content: String, flags: List(Flag))
  NewComponent(components: List(ComponentRoot), flags: List(Flag))
}

pub fn new_json(new: New) -> Json {
  case new {
    Raw(json:) -> json
    NewText(content:, flags:) ->
      [#("content", json.string(content)), #("flags", flags_json(flags))]
      |> json.object
    NewComponent(components:, flags:) ->
      [
        #("components", json.array(components, component_root_json)),
        #("flags", flags_json([IsComponentsV2, ..flags])),
      ]
      |> json.object
  }
}

const crossposted = 0b1

const is_crosspost = 0b10

const suppress_embeds = 0b100

const source_message_deleted = 0b1000

const urgent = 0b10000

const has_thread = 0b100000

const ephemeral = 0b1000000

const loading = 0b10000000

const failed_role_mentions = 0b100000000

const suppress_notifications = 0b1000000000000

const is_voice_message = 0b10000000000000

const has_snapshot = 0b100000000000000

const is_components_v2 = 0b1000000000000000

pub type Flag {
  Crossposted
  IsCrosspost
  SuppressEmbeds
  SourceMessageDeleted
  Urgent
  HasThread
  Ephemeral
  Loading
  FailedToMentionSomeRolesInThread
  SuppressNotifications
  IsVoiceMessage
  HasSnapshot
  IsComponentsV2
}

fn flags_json(flags: List(Flag)) {
  let bitfield =
    list.map(flags, flag_int)
    |> list.fold(0, int.bitwise_or)

  json.int(bitfield)
}

fn flag_int(flag: Flag) {
  case flag {
    Crossposted -> crossposted
    IsCrosspost -> is_crosspost
    SuppressEmbeds -> suppress_embeds
    SourceMessageDeleted -> source_message_deleted
    Urgent -> urgent
    HasThread -> has_thread
    Ephemeral -> ephemeral
    Loading -> loading
    FailedToMentionSomeRolesInThread -> failed_role_mentions
    SuppressNotifications -> suppress_notifications
    IsVoiceMessage -> is_voice_message
    HasSnapshot -> has_snapshot
    IsComponentsV2 -> is_components_v2
  }
}

pub type ComponentRoot {
  RootRow(layout.ActionRow)
  RootContainer(layout.Container)
  RootSeparator(layout.Separator)
  RootSection(layout.Section)
}

pub fn root_container(
  components components: List(layout.ContainerComponent),
  accent accent: Int,
  spoiler spoiler: Bool,
) {
  RootContainer(layout.Container(components:, accent:, spoiler:))
}

fn component_root_json(component: ComponentRoot) {
  case component {
    RootRow(r) -> layout.action_row_json(r)
    RootContainer(c) -> layout.container_json(c)
    RootSeparator(s) -> layout.separator_json(s)
    RootSection(s) -> layout.section_json(s)
  }
}
