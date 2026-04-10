import examples/message_component/interactive as i_example
import gleam/option
import message_component/content
import message_component/interactive
import message_component/layout

pub fn button_action_row() {
  layout.ButtonActionRow([i_example.button()])
}

pub fn string_select_action_row() {
  layout.SelectActionRow(
    interactive.StringSelectVariant(i_example.string_select()),
  )
}

pub fn section() {
  layout.Section(
    components: [layout.SectionTextDisplay(content.TextDisplay("example"))],
    accessories: [
      layout.SectionButton(i_example.button()),
    ],
  )
}

pub fn separator() {
  layout.Separator(divider: True, spacing: layout.LargeSpacing)
}

pub fn container() {
  layout.Container(
    components: [
      layout.ContainerTextDisplay(content.TextDisplay("Example")),
      layout.ContainerSection(section()),
      layout.ContainerSeparator(separator()),
      layout.ContainerActionRow(button_action_row()),
    ],
    accent_colour: option.None,
    spoiler: False,
  )
}
