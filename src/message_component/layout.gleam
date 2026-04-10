import gleam/list
import gleam/option.{type Option}
import message_component/content
import message_component/interactive

pub opaque type ActionRow(state) {
  ButtonActionRow(List(interactive.Button(state)))
  SelectActionRow(interactive.SelectComponent(state))
}

pub fn button_row(buttons: List(interactive.Button(_))) -> ActionRow(_) {
  assert list.length(buttons) <= 5

  ButtonActionRow(buttons)
}

pub fn select_row(select: interactive.SelectComponent(_)) -> ActionRow(_) {
  SelectActionRow(select)
}

pub type Section(state) {
  Section(
    components: List(SectionComponent),
    accessories: List(SectionAccessory(state)),
  )
}

pub type SectionComponent {
  SectionTextDisplay(content.TextDisplay)
}

pub type SectionAccessory(state) {
  SectionButton(interactive.Button(state))
  SectionThumbnail(content.Thumbnail)
}

pub type Separator {
  SmallSeparator(divider: Bool)
  LargeSeparator(divider: Bool)
}

pub type Container(state) {
  Container(
    components: List(ContainerComponent(state)),
    accent_colour: Option(Int),
    spoiler: Bool,
  )
}

pub type ContainerComponent(state) {
  ContainerActionRow(ActionRow(state))
  ContainerTextDisplay(content.TextDisplay)
  ContainerSection(Section(state))
  ContainerMediaGallery(content.MediaGallery)
  ContainerSeparator(Separator)
  ContainerFile(content.File)
}
