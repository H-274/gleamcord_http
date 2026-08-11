import gleam/list

/// Layout
pub opaque type ActionRow {
  ButtonsActionRow(List(Button))
  SelectActionRow(Select)
}

pub fn buttons_action_row(buttons: List(Button)) {
  assert list.length(buttons) <= 5

  ButtonsActionRow(buttons)
}

pub fn select_action_row(select: Select) {
  SelectActionRow(select)
}

pub opaque type Section {
  Section(components: List(SectionChild), accessory: SectionAccessory)
}

pub fn section(components: List(SectionChild), accessory: SectionAccessory) {
  assert !list.is_empty(components) && list.length(components) <= 3

  Section(components:, accessory:)
}

pub type SectionChild {
  TextSectionChild(TextDisplay)
}

pub type SectionAccessory {
  ButtonAccessory(Button)
  ThumbnailAccessory(Thumbnail)
}

pub type Separator {
  SmallSeparator(divider: Bool)
  LargeSeparator(divider: Bool)
}

pub opaque type Container {
  Container(components: List(ContainerChild))
  AccentContainer(components: List(ContainerChild), accent_color: Int)
  SpoilerContainer(components: List(ContainerChild), spoiler: Bool)
  AccentSpoilerContainer(
    components: List(ContainerChild),
    accent_color: Int,
    spoiler: Bool,
  )
}

pub fn container(components: List(ContainerChild)) {
  assert !list.is_empty(components)

  Container(components:)
}

pub fn accent_container(components: List(ContainerChild), accent_color: Int) {
  assert !list.is_empty(components)

  AccentContainer(components:, accent_color:)
}

pub fn spoiler_container(components: List(ContainerChild), spoiler: Bool) {
  assert !list.is_empty(components)

  SpoilerContainer(components:, spoiler:)
}

pub fn accent_spoiler_container(
  components: List(ContainerChild),
  accent_color: Int,
  spoiler: Bool,
) {
  assert !list.is_empty(components)

  AccentSpoilerContainer(components:, accent_color:, spoiler:)
}

pub type ContainerChild {
  ContainerAccentRow(ActionRow)
  ContainerText(TextDisplay)
  ContainerSection(Section)
  ContainerMedia(MediaGallery)
  ContainerSeparator(Separator)
  ContainerFile(File)
}

pub type Label {
  Label(label: String, description: String, component: LabelComponent)
}

pub type LabelComponent {
  LabelText(TextDisplay)
  LabelStringSelect(StringSelect)
  LabelUserSelect(UserSelect)
  LabelRoleSelect(RoleSelect)
  LabelMentionableSelect(MentionableSelect)
  LabelChannelSelect(ChannelSelect)
  LabelFileUpload(FileUpload)
  LabelRadioGroup(RadioGroup)
  LabelCheckboxGroup(CheckboxGroup)
  LabelCheckbox(Checkbox)
}

/// Content
pub type TextDisplay =
  String

pub type Thumbnail {
  Thumbnail
}

pub type MediaGallery {
  MediaGallery
}

pub type File {
  File
}

/// Interactive
pub type Button {
  CustomButton(label: String, custom: CustomButton, disabled: Bool)
  EmojiCustomButton(
    label: String,
    custom: CustomButton,
    emoji: Nil,
    disabled: Bool,
  )
  UrlButton(label: String, url: String, disabled: Bool)
  UrlEmojiButton(label: String, url: String, emoji: Nil, disabled: Bool)
  PremiumButton(sku_id: String)
}

pub type CustomButton {
  PrimaryButton(custom_id: String)
  SecondaryButton(custom_id: String)
  SuccessButton(custom_id: String)
  DangerButton(custom_id: String)
}

pub type Select {
  StringSelectComponent(StringSelect)
  UserSelectComponent(UserSelect)
  RoleSelectComponent(RoleSelect)
  MentionableSelectComponent(MentionableSelect)
  ChannelSelectComponent(ChannelSelect)
}

pub type StringSelect {
  StringSelect
}

pub type TextInput {
  TextInput
}

pub type UserSelect {
  UserSelect
}

pub type RoleSelect {
  RoleSelect
}

pub type MentionableSelect {
  MentionableSelect
}

pub type ChannelSelect {
  ChannelSelect
}

pub type FileUpload {
  FileUpload
}

pub type RadioGroup {
  RadioGroup
}

pub type CheckboxGroup {
  CheckboxGroup
}

pub type Checkbox {
  Checkbox
}
