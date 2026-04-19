import component/content
import component/interactive
import gleam/option.{type Option}

pub type ActionRow {
  ButtonRow(List(interactive.Button))
  StringSelectRow(interactive.StringSelect)
  UserSelectRow(interactive.UserSelect)
  RoleSelectRow(interactive.RoleSelect)
  MentionableSelectRow(interactive.MentionableSelect)
  ChannelSelectRow(interactive.ChannelSelect)
}

pub fn string_select_row() {
  StringSelectRow(interactive.StringSelect)
}

pub fn user_select_row() {
  UserSelectRow(interactive.UserSelect)
}

pub fn role_select_row() {
  RoleSelectRow(interactive.RoleSelect)
}

pub fn mentionable_select_row() {
  MentionableSelectRow(interactive.MentionableSelect)
}

pub fn channel_select_row() {
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

pub fn section_thumbnail(
  media media: String,
  description description: String,
  spoiler spoiler: Bool,
) {
  SectionThumbnail(content.Thumbnail(media:, description:, spoiler:))
}

pub fn section_primary_button(
  custom_id custom_id: String,
  label label: String,
  disabled disabled: Bool,
  emoji emoji: Option(String),
) {
  interactive.PrimaryButton(custom_id:, label:, disabled:, emoji:)
  |> interactive.CustomButton
  |> SectionButton
}

pub fn section_secondary_button(
  custom_id custom_id: String,
  label label: String,
  disabled disabled: Bool,
  emoji emoji: Option(String),
) {
  interactive.SecondaryButton(custom_id:, label:, disabled:, emoji:)
  |> interactive.CustomButton
  |> SectionButton
}

pub fn section_success_button(
  custom_id custom_id: String,
  label label: String,
  disabled disabled: Bool,
  emoji emoji: Option(String),
) {
  interactive.SuccessButton(custom_id:, label:, disabled:, emoji:)
  |> interactive.CustomButton
  |> SectionButton
}

pub fn section_danger_button(
  custom_id custom_id: String,
  label label: String,
  disabled disabled: Bool,
  emoji emoji: Option(String),
) {
  interactive.DangerButton(custom_id:, label:, disabled:, emoji:)
  |> interactive.CustomButton
  |> SectionButton
}

pub fn section_link_button(
  label label: String,
  url url: String,
  emoji emoji: Option(String),
) {
  interactive.LinkButton(label:, url:, emoji:)
  |> SectionButton
}

pub fn section_premium_button(sku sku: String) {
  interactive.PremiumButton(sku:)
  |> SectionButton
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

pub fn container_button_row(buttons buttons: List(interactive.Button)) {
  ButtonRow(buttons)
  |> ContainerRow
}

pub fn container_string_select_row() {
  StringSelectRow(interactive.StringSelect)
  |> ContainerRow
}

pub fn container_user_select_row() {
  UserSelectRow(interactive.UserSelect)
  |> ContainerRow
}

pub fn container_role_select_row() {
  RoleSelectRow(interactive.RoleSelect)
  |> ContainerRow
}

pub fn container_mentionable_select_row() {
  MentionableSelectRow(interactive.MentionableSelect)
  |> ContainerRow
}

pub fn container_channel_select_row() {
  ChannelSelectRow(interactive.ChannelSelect)
  |> ContainerRow
}

pub fn container_section(
  components components: List(content.TextDisplay),
  accessories accessories: List(SectionAccessory),
) {
  ContainerSection(Section(components:, accessories:))
}

pub fn container_gallery() {
  ContainerGallery(content.MediaGallery)
}

pub fn container_small_separator(divider divider: Bool) {
  ContainerSeparator(SmallSeparator(divider:))
}

pub fn container_large_separator(divider divider: Bool) {
  ContainerSeparator(LargeSeparator(divider:))
}

pub fn container_file() {
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
