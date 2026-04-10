import examples/message_component/interactive as i_example
import gleam/option
import message_component/button/button
import message_component/interactive
import message_component/layout

pub fn button_action_row() {
  layout.button_row([button.Interactive(i_example.button())])
}

pub fn string_select_action_row() {
  layout.select_row(interactive.StringSelectVariant(i_example.string_select()))
}

pub fn section() {
  layout.Section(
    components: [layout.SectionTextDisplay("example")],
    accessories: [
      layout.SectionButton(button.Interactive(i_example.button())),
    ],
  )
}

pub fn separator() {
  layout.LargeSeparator(divider: True)
}

pub fn container() {
  layout.Container(
    components: [
      layout.ContainerTextDisplay("Example"),
      layout.ContainerSection(section()),
      layout.ContainerSeparator(separator()),
      layout.ContainerActionRow(button_action_row()),
    ],
    accent_colour: option.None,
    spoiler: False,
  )
}
