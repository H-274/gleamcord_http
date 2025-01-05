import resolved.{type Resolved}

pub type ButtonData {
  ButtonData(custom_id: String)
}

pub type StringSelectData {
  StringSelectData(custom_id: String, values: List(String))
}

pub type TextInputData {
  TextInputData(custom_id: String, value: String)
}

pub type UserSelectData {
  UserSelectData(custom_id: String, values: List(String), resolved: Resolved)
}

pub type RoleSelectData {
  RoleSelectData(custom_id: String, values: List(String), resolved: Resolved)
}

pub type MentionableSelectData {
  MentionableSelectData(
    custom_id: String,
    values: List(String),
    resolved: Resolved,
  )
}

pub type ChannelSelectData {
  ChannelSelectData(custom_id: String, values: List(String), resolved: Resolved)
}
