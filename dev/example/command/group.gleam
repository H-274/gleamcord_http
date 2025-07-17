import command/group.{group, group_command, group_subgroup, subgroup}
import command/response
import command/text
import entities/integration
import entities/interaction_context
import entities/message
import gleam/int

pub fn example() {
  group(name: "primary", options: [
    // Command that will be registered: `/primary command1`
    primary_command(1),
    // Command that will be registered: `/primary command2`
    primary_command(2),
    group_subgroup(
      subgroup(name: "secondary", commands: [
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
    |> group_command()
  }

  use <- handle()

  message.Create(
    ..message.create_default(),
    content: "Executed primary command " <> num,
  )
  |> response.Message()
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

  message.Create(
    ..message.create_default(),
    content: "Executed secondary command " <> num,
  )
  |> response.Message()
}
