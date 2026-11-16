import gleam/dynamic.{type Dynamic}
import gleam/option.{type Option}

/// Start of content components
pub type ActionRow {
  /// Button action row must have between 1-5 (inclusive) buttons
  ButtonRow(List(Button))
  StringSelectRow(StringSelect)
  UserSelectRow(UserSelect)
  RoleSelectRow(RoleSelect)
  MentionableSelectRow(MentionableSelect)
  ChannelSelectRow(ChannelSelect)
}

/// `components` must have between 1-3 (inclusive) items
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
  /// `items` should contain between 1-10 (inclusive) elements
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
  LinkButton(url: String, label: String, emoji: Option(Dynamic), disabled: Bool)
  PremiunButton(sku_id: String, disabled: Bool)
}

pub fn default_link_button(url: String, label: String) {
  LinkButton(url:, label:, emoji: option.None, disabled: False)
}

pub type InteractiveButton {
  PrimaryButton(
    custom_id: String,
    label: String,
    emoji: Option(Dynamic),
    disabled: Bool,
  )
  SecondaryButton(
    custom_id: String,
    label: String,
    emoji: Option(Dynamic),
    disabled: Bool,
  )
  SuccessButton(
    custom_id: String,
    label: String,
    emoji: Option(Dynamic),
    disabled: Bool,
  )
  DangerButton(
    custom_id: String,
    label: String,
    emoji: Option(Dynamic),
    disabled: Bool,
  )
}

pub fn default_primary_button(custom_id: String, label: String) {
  PrimaryButton(custom_id:, label:, emoji: option.None, disabled: False)
}

pub fn default_secondary_button(custom_id: String, label: String) {
  SecondaryButton(custom_id:, label:, emoji: option.None, disabled: False)
}

pub fn default_success_button(custom_id: String, label: String) {
  SuccessButton(custom_id:, label:, emoji: option.None, disabled: False)
}

pub fn default_danger_button(custom_id: String, label: String) {
  DangerButton(custom_id:, label:, emoji: option.None, disabled: False)
}

pub type StringSelect {
  /// Important notes:
  /// - number of elements in `options` should be between `min_values` and `max_values`
  /// - `min_values` should be between 0-25 (inclusive), and less than `max_values`
  /// - `max_values` should be between 1-25 (inclusive), and more than `min_values` 
  /// - `required` only applies to modals, and `disabled` only applies to message components
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

pub fn default_string_select(custom_id: String, options, placeholder: String) {
  StringSelect(
    custom_id:,
    options:,
    placeholder:,
    min_values: 1,
    max_values: 1,
    required: True,
    disabled: False,
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

pub fn default_select_option(label: String, value: String) {
  SelectOption(
    label:,
    value:,
    description: "",
    emoji: option.None,
    default: False,
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

pub fn default_short_text(custom_id: String, placeholder: String) {
  ShortTextInput(
    custom_id:,
    min_length: 1,
    max_length: 4000,
    required: True,
    value: "",
    placeholder:,
  )
}

pub fn default_long_text(custom_id: String, placeholder: String) {
  LongTextInput(
    custom_id:,
    min_length: 1,
    max_length: 4000,
    required: True,
    value: "",
    placeholder:,
  )
}

pub type UserSelect {
  /// Important notes:
  /// - number of elements in `default_values` should be between `min_values` and `max_values`
  /// - `min_values` should be between 0-25 (inclusive), and less than `max_values`
  /// - `max_values` should be between 1-25 (inclusive), and more than `min_values` 
  /// - `required` only applies to modals, and `disabled` only applies to message components
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

pub fn default_user_select(custom_id: String, placeholder: String) {
  UserSelect(
    custom_id:,
    default_values: [],
    placeholder:,
    min_values: 1,
    max_values: 1,
    required: True,
    disabled: False,
  )
}

pub type RoleSelect {
  /// Important notes:
  /// - number of elements in `default_values` should be between `min_values` and `max_values`
  /// - `min_values` should be between 0-25 (inclusive), and less than `max_values`
  /// - `max_values` should be between 1-25 (inclusive), and more than `min_values` 
  /// - `required` only applies to modals, and `disabled` only applies to message components
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

pub fn default_role_select(custom_id: String, placeholder: String) {
  RoleSelect(
    custom_id:,
    default_values: [],
    placeholder:,
    min_values: 1,
    max_values: 1,
    required: True,
    disabled: False,
  )
}

pub type MentionableSelect {
  /// Important notes:
  /// - number of elements in `options` should be between `min_values` and `max_values`
  /// - `min_values` should be between 0-25 (inclusive), and less than `max_values`
  /// - `max_values` should be between 1-25 (inclusive), and more than `min_values` 
  /// - `required` only applies to modals, and `disabled` only applies to message components
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

pub fn default_mentionable_select(custom_id: String, placeholder: String) {
  MentionableSelect(
    custom_id:,
    default_values: [],
    placeholder:,
    min_values: 1,
    max_values: 1,
    required: True,
    disabled: False,
  )
}

pub type ChannelSelect {
  /// Important notes:
  /// - number of elements in `default_values` should be between `min_values` and `max_values`
  /// - `min_values` should be between 0-25 (inclusive), and less than `max_values`
  /// - `max_values` should be between 1-25 (inclusive), and more than `min_values` 
  /// - `required` only applies to modals, and `disabled` only applies to message components
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

pub fn default_channel_select(custom_id: String, placeholder: String) {
  ChannelSelect(
    custom_id:,
    channel_types: [],
    placeholder:,
    default_values: [],
    min_values: 1,
    max_values: 1,
    required: True,
    disabled: False,
  )
}

/// Representing the snowflake of the select component's type
pub type DefaultSelectValue =
  String

pub type FileUpload {
  /// Important notes:
  /// - `min_values` should be between 0-10 (inclusive), and less than `max_values`
  /// - `max_values` should be between 1-10 (inclusive), and more than `min_values` 
  FileUpload(
    custom_id: String,
    min_values: Int,
    max_values: Int,
    required: Bool,
    file_types: List(String),
  )
}

pub type RadioGroup {
  /// Important notes:
  /// - number of elements in `options` should be between 2-10 (inclusive)
  RadioGroup(custom_id: String, options: List(GroupOption), required: Bool)
}

pub type CheckboxGroup {
  /// Important notes:
  /// - number of elements in `options` should be between `min_values` and `max_values`
  /// - `min_values` should be between 0-10 (inclusive), and less than `max_values`
  /// - `max_values` should be between 1-10 (inclusive), and more than `min_values` 
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
