import gleam/option.{type Option}
import message_component/content
import message_component/interactive

pub type ActionRow(state) {
  ButtonActionRow(List(interactive.Button(state)))
  SelectActionRow(interactive.SelectComponent(state))
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
  Separator(divider: Bool, spacing: SeparatorSpacing)
}

pub type SeparatorSpacing {
  SmallSpacing
  LargeSpacing
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
