import component/content
import component/interactive
import gleam/json.{type Json}
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

pub fn action_row_json(row: ActionRow) -> Json {
  let components = case row {
    ButtonRow(buttons) -> #(
      "components",
      json.array(buttons, interactive.button_json),
    )
    StringSelectRow(s) -> #(
      "components",
      json.array([s], interactive.string_select_json),
    )
    UserSelectRow(s) -> #(
      "components",
      json.array([s], interactive.user_select_json),
    )
    RoleSelectRow(s) -> #(
      "components",
      json.array([s], interactive.role_select_json),
    )
    MentionableSelectRow(s) -> #(
      "components",
      json.array([s], interactive.mentionable_select_json),
    )
    ChannelSelectRow(s) -> #(
      "components",
      json.array([s], interactive.channel_select_json),
    )
  }

  [#("type", json.int(1)), components]
  |> json.object
}

pub type Section {
  Section(
    components: List(content.TextDisplay),
    accessories: List(SectionAccessory),
  )
}

pub fn section_json(section: Section) -> Json {
  let components = #(
    "components",
    json.array(section.components, content.text_display_json),
  )
  let accessories = #(
    "accessories",
    json.array(section.accessories, section_accessory_json),
  )

  [#("type", json.int(9)), components, accessories]
  |> json.object
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

pub fn section_custom_button(custom_button: interactive.CustomButton) {
  custom_button
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

pub fn section_accessory_json(accessory: SectionAccessory) -> Json {
  case accessory {
    SectionThumbnail(t) -> content.thumbnail_json(t)
    SectionButton(b) -> interactive.button_json(b)
  }
}

pub type Separator {
  SmallSeparator(divider: Bool)
  LargeSeparator(divider: Bool)
}

pub fn separator_json(separator: Separator) -> Json {
  let spacing = case separator {
    SmallSeparator(..) -> #("spacing", json.int(1))
    LargeSeparator(..) -> #("spacing", json.int(2))
  }

  [#("type", json.int(14)), #("divider", json.bool(separator.divider)), spacing]
  |> json.object
}

pub type Container {
  Container(components: List(ContainerComponent), accent: Int, spoiler: Bool)
}

pub fn container_json(container: Container) -> Json {
  [
    #("type", json.int(17)),
    #("components", json.array(container.components, container_component_json)),
    #("accent_color", json.int(container.accent)),
    #("spoiler", json.bool(container.spoiler)),
  ]
  |> json.object
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

fn container_component_json(container_component: ContainerComponent) -> Json {
  case container_component {
    ContainerRow(r) -> action_row_json(r)
    ContainerText(t) -> content.text_display_json(t)
    ContainerSection(s) -> section_json(s)
    ContainerGallery(g) -> content.media_gallery_json(g)
    ContainerSeparator(s) -> separator_json(s)
    ContainerFile(f) -> content.file_json(f)
  }
}

pub type Label {
  Label(label: String, description: String, component: LabelComponent)
}

pub fn label_json(label: Label) -> Json {
  [
    #("type", json.int(18)),
    #("label", json.string(label.label)),
    #("description", json.string(label.description)),
    #("component", label_component_json(label.component)),
  ]
  |> json.object
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

fn label_component_json(component: LabelComponent) {
  case component {
    LabelTextInput(t) -> interactive.text_input_json(t)
    LabelStringSelect(s) -> interactive.string_select_json(s)
    LabelUserSelect(u) -> interactive.user_select_json(u)
    LabelRoleSelect(r) -> interactive.role_select_json(r)
    LabelMentionableSelect(m) -> interactive.mentionable_select_json(m)
    LabelChannelSelect(c) -> interactive.channel_select_json(c)
    LabelFileUpload(f) -> interactive.file_upload_json(f)
    LabelRadioGroup(r) -> interactive.radio_group_json(r)
    LabelCheckboxGroup(c) -> interactive.checkbox_group_json(c)
    LabelCheckbox(c) -> interactive.checkbox_json(c)
  }
}
