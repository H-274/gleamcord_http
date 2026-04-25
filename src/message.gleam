import component/layout
import gleam/json.{type Json}

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
  todo
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
  todo
}
