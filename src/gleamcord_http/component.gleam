import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}

/// Start of content components
pub type ActionRow {
  ButtonRow(List(Button))
  StringSelectRow(StringSelect)
  UserSelectRow(UserSelect)
  RoleSelectRow(RoleSelect)
  MentionableSelectRow(MentionableSelect)
  ChannelSelectRow(ChannelSelect)
}

pub type Section {
  ButtonSection(components: List(SectionChild), accessory: Button)
  ThumbnailSection(components: List(SectionChild), accessory: Thumbnail)
}

pub type SectionChild {
  SectionText(TextDisplay)
}

pub type Separator {
  SmallSeparator(divider: Bool)
  LargeSeparator(divider: Bool)
}

pub type Container {
  Container(
    components: List(ContainerChild),
    accent: Option(Int),
    spoiler: Bool,
  )
}

pub type ContainerChild {
  ContainerRow(ActionRow)
  ContainerText(TextDisplay)
  ContainerSection(Section)
  ContainerGallery(MediaGallery)
  ContainerSeparator(Separator)
  ContainerFile(File)
}

pub type Label {
  TextInputLabel(label: String, description: String, component: TextInput)
  StringSelectLabel(label: String, description: String, component: StringSelect)
  UserSelectLabel(label: String, description: String, component: UserSelect)
  RoleSelectLabel(label: String, description: String, component: RoleSelect)
  MentionableSelectSelectLabel(
    label: String,
    description: String,
    component: MentionableSelect,
  )
  ChannelSelectLabel(
    label: String,
    description: String,
    component: ChannelSelect,
  )
  FileUploadLabel(label: String, description: String, component: FileUpload)
  RadioGroupLabel(label: String, description: String, component: RadioGroup)
  CheckboxGroupLabel(
    label: String,
    description: String,
    component: CheckboxGroup,
  )
  CheckboxLabel(label: String, description: String, component: Checkbox)
}

/// Start of content components
pub type TextDisplay =
  String

pub type Thumbnail {
  Thumbnail(media_url: String, description: String, spoiler: Bool)
}

pub type MediaGallery {
  MediaGallery(items: List(GalleryItem))
}

pub type GalleryItem {
  GalleryItem(media_url: String, description: String, spoiler: Bool)
}

pub type File {
  File(media_url: String, spoiler: Bool)
}

/// Start of interactive components
pub type Button {
  InteractiveButton(InteractiveButton)
  LinkButton(url: String, appearance: ButtonDisplay, disabled: Bool)
  PremiunButton(sku_id: String, disabled: Bool)
}

pub type InteractiveButton {
  PrimaryButton(custom_id: String, appearance: ButtonDisplay, disabled: Bool)
  SecondaryButton(custom_id: String, appearance: ButtonDisplay, disabled: Bool)
  SuccessButton(custom_id: String, appearance: ButtonDisplay, disabled: Bool)
  DangerButton(custom_id: String, appearance: ButtonDisplay, disabled: Bool)
}

pub type ButtonDisplay {
  StringButton(label: String)
  EmojiButton(emoji: Dynamic)
  StringEmojiButton(label: String, emoji: Dynamic)
}

/// `required` only applies in modals, and `disabled` only applies to message components
pub type StringSelect {
  StringSelect(
    custom_id: String,
    options: List(SelectOption),
    placeholder: String,
    min_values: Int,
    max_values: Int,
    required: Bool,
    disabled: Bool,
  )
}

pub type SelectOption {
  SelectOption(
    label: String,
    value: String,
    description: String,
    emoji: Option(Dynamic),
    default: Bool,
  )
}

pub type TextInput {
  ShortTextInput(
    custom_id: String,
    min_length: Int,
    max_length: Int,
    required: Bool,
    value: String,
    placeholder: String,
  )
  LongTextInput(
    custom_id: String,
    min_length: Int,
    max_length: Int,
    required: Bool,
    value: String,
    placeholder: String,
  )
}

/// `required` only applies in modals, and `disabled` only applies to message components
pub type UserSelect {
  UserSelect(
    custom_id: String,
    placeholder: String,
    default_values: List(DefaultSelectValue),
    min_values: Int,
    max_values: Int,
    required: Bool,
    disabled: Bool,
  )
}

/// `required` only applies in modals, and `disabled` only applies to message components
pub type RoleSelect {
  RoleSelect(
    custom_id: String,
    placeholder: String,
    default_values: List(DefaultSelectValue),
    min_values: Int,
    max_values: Int,
    required: Bool,
    disabled: Bool,
  )
}

/// `required` only applies in modals, and `disabled` only applies to message components
pub type MentionableSelect {
  MentionableSelect(
    custom_id: String,
    placeholder: String,
    default_values: List(DefaultSelectValue),
    min_values: Int,
    max_values: Int,
    required: Bool,
    disabled: Bool,
  )
}

/// `required` only applies in modals, and `disabled` only applies to message components
pub type ChannelSelect {
  ChannelSelect(
    custom_id: String,
    channel_types: List(Int),
    placeholder: String,
    default_values: List(DefaultSelectValue),
    min_values: Int,
    max_values: Int,
    required: Bool,
    disabled: Bool,
  )
}

/// Representing the snowflake of the select component's type
pub type DefaultSelectValue =
  String

pub type FileUpload {
  FileUpload(
    custom_id: String,
    min_values: Int,
    max_values: Int,
    required: Bool,
    file_types: List(String),
  )
}

pub type RadioGroup {
  RadioGroup(custom_id: String, options: List(GroupOption), required: Bool)
}

pub type CheckboxGroup {
  CheckboxGroup(
    custom_id: String,
    options: List(GroupOption),
    min_values: Int,
    max_values: Int,
    required: Bool,
  )
}

pub type GroupOption {
  GroupOption(value: String, label: String, description: String, default: Bool)
}

pub type Checkbox {
  Checkbox(custom_id: String, default: Bool)
}
