import command/group
import command/text
import entities/integration
import entities/interaction_context
import gleam/int

pub fn example() {
  group.group(name: "primary", options: [
    // Command that will be registered: `/primary command1`
    group.group_command(primary_command(1)),
    // Command that will be registered: `/primary command2`
    group.group_command(primary_command(2)),
    group.group_subgroup(
      group.subgroup(name: "secondary", commands: [
        // Command that will be registered: `/primary secondary command3`
        secondary_command(3),
        // Command that will be registered: `/primary secondary command4`
        secondary_command(4),
      ]),
    ),
  ])
}

pub fn primary_command(num: Int) {
  let num = int.to_string(num)
  let handle = fn(handler) {
    text.command(
      name: "command" <> num,
      description: "primary command",
      options: [],
      integ_types: [integration.GuildInstall],
      contexts: [interaction_context.Guild],
      handler:,
    )
  }

  use <- handle()

  "Executed primary command " <> num
}

pub fn secondary_command(num: Int) {
  let num = int.to_string(num)
  let handle = fn(handler) {
    text.command(
      name: "command" <> num,
      description: "secondary command",
      options: [],
      integ_types: [integration.GuildInstall],
      contexts: [interaction_context.Guild],
      handler:,
    )
  }

  use <- handle()

  "Executed secondary command " <> num
}
