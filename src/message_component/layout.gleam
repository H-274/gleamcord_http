import component/content
import component/interactive
import gleam/option.{type Option}

pub type ActionRow {
  ButtonActionRow(List(interactive.Button))
  SelectActionRow(interactive.SelectComponent)
}

pub type Section {
  Section(
    components: List(SectionComponent),
    accessories: List(SectionAccessory),
  )
}

pub type SectionComponent {
  SectionTextDisplay(content.TextDisplay)
}

pub type SectionAccessory {
  SectionButton(interactive.Button)
  SectionThumbnail(content.Thumbnail)
}

pub type Separator {
  Separator(divider: Bool, spacing: SeparatorSpacing)
}

pub type SeparatorSpacing {
  SmallSpacing
  LargeSpacing
}

pub type Container {
  Container(
    components: List(ContainerComponent),
    accent_colour: Option(Int),
    spoiler: Bool,
  )
}

pub type ContainerComponent {
  ContainerActionRow(ActionRow)
  ContainerTextDisplay(content.TextDisplay)
  ContainerSection(Section)
  ContainerMediaGallery(content.MediaGallery)
  ContainerSeparator(Separator)
  ContainerFile(content.File)
}
