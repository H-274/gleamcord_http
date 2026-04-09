import component/interactive

pub type ActionRow {
  ButtonActionRow(List(interactive.Button))
  SelectActionRow(interactive.SelectComponent)
}

pub type Section {
  Section
}

pub type Separator {
  Separator
}

pub type Container {
  Container
}

pub type Label {
  Label
}
