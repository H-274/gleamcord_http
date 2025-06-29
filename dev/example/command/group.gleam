import command/group
import command/text
import entities/integration
import entities/interaction_context
import gleam/int

pub fn example() {
  group.group(name: "primary", options: [
    group.command_option(primary_command(1)),
    group.command_option(primary_command(2)),
    group.subgroup_option(
      group.subgroup(name: "secondary", commands: [
        secondary_command(1),
        secondary_command(2),
      ]),
    ),
  ])
}

/// Will be called when the slash command `primary command<num>` is used
/// (So long as the command with the given num is registered)
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

/// Will be called when the slash command `primary secondary command<num>` is used
/// (So long as the command with the given num is registered)
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
