import component/layout

/// For responses, ephemeral is available. Otherwise, only the suppression flags and `IsVoiceMessage` are available. `IsComponentsV2` should be automatically added depending on the variant used
pub type New {
  NewText(content: String, flags: List(Flag))
  NewComponent(content: List(ComponentRoot), flags: List(Flag))
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

pub type ComponentRoot {
  RootRow(layout.ActionRow)
  RootContainer(layout.Container)
  RootSeparator(layout.Separator)
  RootSection(layout.Section)
}
