import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/list
import gleam/option
import gleam/result

/// Layout
pub type ActionRow {
  ButtonsActionRow(List(Button))
  SelectActionRow(Select)
}

pub type Section {
  Section(components: List(SectionChild), accessory: SectionAccessory)
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

pub type Container {
  Container(components: List(ContainerChild))
  AccentContainer(components: List(ContainerChild), accent_color: Int)
  SpoilerContainer(components: List(ContainerChild), spoiler: Bool)
  AccentSpoilerContainer(
    components: List(ContainerChild),
    accent_color: Int,
    spoiler: Bool,
  )
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
  LabelTextInput(TextInput)
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
  ShortTextInput(
    custom_id: String,
    min_len: Int,
    max_len: Int,
    required: Bool,
    value: String,
    placeholder: String,
  )
  LongTextInput(
    custom_id: String,
    min_len: Int,
    max_len: Int,
    required: Bool,
    value: String,
    placeholder: String,
  )
}

pub fn get_text_input_value(
  components: Dict(String, Dynamic),
  custom_id: String,
) {
  dict.get(components, custom_id)
  |> result.replace_error([])
  |> result.map(decode.run(_, decode.at(["value"], decode.string)))
  |> result.flatten
}

pub type UserSelect {
  UserSelect
}

pub fn get_user_select_value(
  components: Dict(String, Dynamic),
  resolved: Dynamic,
  custom_id: String,
) {
  use user_ids <- result.try(
    dict.get(components, custom_id)
    |> result.replace_error([])
    |> result.map(decode.run(
      _,
      decode.at(["values"], decode.list(decode.string)),
    ))
    |> result.flatten,
  )

  let users =
    list.map(user_ids, fn(id) {
      decode.run(resolved, decode.at(["users", id], decode.dynamic))
      |> option.from_result
    })
  let members =
    list.map(user_ids, fn(id) {
      decode.run(resolved, decode.at(["members", id], decode.dynamic))
      |> option.from_result
    })

  Ok(list.zip(users, members))
}

pub type RoleSelect {
  RoleSelect
}

pub fn get_role_select_value(
  components: Dict(String, Dynamic),
  resolved: Dynamic,
  custom_id: String,
) {
  use user_ids <- result.try(
    dict.get(components, custom_id)
    |> result.replace_error([])
    |> result.map(decode.run(
      _,
      decode.at(["values"], decode.list(decode.string)),
    ))
    |> result.flatten,
  )

  let roles =
    list.map(user_ids, fn(id) {
      decode.run(resolved, decode.at(["roles", id], decode.dynamic))
    })
    |> result.values

  Ok(roles)
}

pub type MentionableSelect {
  MentionableSelect
}

pub fn get_mentionable_select_value(
  components: Dict(String, Dynamic),
  resolved: Dynamic,
  custom_id: String,
) {
  use user_ids <- result.try(
    dict.get(components, custom_id)
    |> result.replace_error([])
    |> result.map(decode.run(
      _,
      decode.at(["values"], decode.list(decode.string)),
    ))
    |> result.flatten,
  )

  let users =
    list.map(user_ids, fn(id) {
      decode.run(resolved, decode.at(["users", id], decode.dynamic))
      |> option.from_result
    })
  let members =
    list.map(user_ids, fn(id) {
      decode.run(resolved, decode.at(["members", id], decode.dynamic))
      |> option.from_result
    })
  let roles =
    list.map(user_ids, fn(id) {
      decode.run(resolved, decode.at(["roles", id], decode.dynamic))
      |> option.from_result
    })

  let triples =
    list.zip(users, members)
    |> list.zip(roles)
    |> list.map(fn(item) {
      let #(#(user, member), role) = item
      #(user, member, role)
    })

  Ok(triples)
}

pub type ChannelSelect {
  ChannelSelect
}

pub fn get_channel_select_value(
  components: Dict(String, Dynamic),
  resolved: Dynamic,
  custom_id: String,
) {
  use user_ids <- result.try(
    dict.get(components, custom_id)
    |> result.replace_error([])
    |> result.map(decode.run(
      _,
      decode.at(["values"], decode.list(decode.string)),
    ))
    |> result.flatten,
  )

  let channel =
    list.map(user_ids, fn(id) {
      decode.run(resolved, decode.at(["channels", id], decode.dynamic))
    })
    |> result.values

  Ok(channel)
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
