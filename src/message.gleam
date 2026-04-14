import component/layout

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
