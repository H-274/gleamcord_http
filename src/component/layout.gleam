import component/content
import component/interactive

pub type ActionRow {
  ButtonRow(List(interactive.Button))
  StringSelectRow(interactive.StringSelect)
  UserSelectRow(interactive.UserSelect)
  RoleSelectRow(interactive.RoleSelect)
  MentionableSelectRow(interactive.MentionableSelect)
  ChannelSelectRow(interactive.ChannelSelect)
}

pub type Section {
  Section(
    components: List(content.TextDisplay),
    accessories: List(SectionAccessory),
  )
}

pub type SectionAccessory {
  SectionThumbnail(content.Thumbnail)
  SectionButton(interactive.Button)
}

pub type Separator {
  SmallSeparator(divider: Bool)
  LargeSeparator(divider: Bool)
}

pub type Container {
  Container(components: List(ContainerComponent), accent: Int, spoiler: Bool)
}

pub type ContainerComponent {
  ContainerRow(ActionRow)
  ContainerText(content.TextDisplay)
  ContainerSection(Section)
  ContainerGallery(content.MediaGallery)
  ContainerSeparator(Separator)
  ContainerFile(content.File)
}

pub type Label {
  Label(label: String, description: String, component: LabelComponent)
}

pub type LabelComponent {
  LabelTextInput(interactive.TextInput)
  LabelStringSelect(interactive.StringSelect)
  LabelUserSelect(interactive.UserSelect)
  LabelRoleSelect(interactive.RoleSelect)
  LabelMentionableSelect(interactive.MentionableSelect)
  LabelChannelSelect(interactive.ChannelSelect)
  LabelFileUpload(interactive.FileUpload)
  LabelRadioGroup(interactive.RadioGroup)
  LabelCheckboxGroup(interactive.CheckboxGroup)
  LabelCheckbox(interactive.Checkbox)
}
