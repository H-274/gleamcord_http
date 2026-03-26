import application_command/application_command as command
import application_command/option_data
import gleam/dict
import gleam/dynamic
import gleam/option
import interaction/data
import interaction/interaction

const correct_run = "correct run"

pub fn valid_chat_input_handle_interaction_test() {
  // Given
  let invoked_name = "test"
  let state = "state"
  let expected = command.MessageWithSource(correct_run)
  let opt_name = "opt"
  let options =
    dict.new()
    |> dict.insert(
      opt_name,
      option_data.StringValue(name: opt_name, value: "", focused: False),
    )
  let data =
    data.ChatInputApplicationCommand(
      id: "",
      name: invoked_name,
      resolved: option.None,
      options: option_data.Command(options),
      guild_id: option.None,
      target_id: option.None,
    )
  let interaction =
    interaction.ApplicationCommand(
      id: "",
      application_id: "",
      data:,
      guild: option.None,
      guild_id: option.None,
      channel: option.None,
      channel_id: option.None,
      member: option.None,
      user: option.None,
      token: "",
      version: 0,
      permissions: "",
      locale: option.None,
      guild_locale: option.None,
      entitlements: [],
      attachment_size_limit: 0,
      context: dynamic.string(""),
      authorizing_integration_owners: [],
    )
  let command =
    command.chat_input(
      signature: command.signature(name: invoked_name, desc: ""),
      opts: [],
      handler: fn(i, s, o) {
        assert i == interaction
        assert s == state
        assert o == options
        expected
      },
    )
  let commands =
    dict.new()
    |> dict.insert(invoked_name, command)

  // When
  let res = command.handle_interaction(commands, state, interaction, data)

  // Then
  assert res == Ok(expected)
}

pub fn invalid_chat_input_handle_interaction_test() {
  // Given
  let invoked_name = "test"
  let bad_name = "bad-" <> invoked_name
  let state = "state"
  let expected = Nil
  let opt_name = "opt"
  let options =
    dict.new()
    |> dict.insert(
      opt_name,
      option_data.StringValue(
        name: opt_name,
        value: correct_run,
        focused: False,
      ),
    )
  let data =
    data.ChatInputApplicationCommand(
      id: "",
      name: invoked_name,
      resolved: option.None,
      options: option_data.Command(options),
      guild_id: option.None,
      target_id: option.None,
    )
  let interaction =
    interaction.ApplicationCommand(
      id: "",
      application_id: "",
      data:,
      guild: option.None,
      guild_id: option.None,
      channel: option.None,
      channel_id: option.None,
      member: option.None,
      user: option.None,
      token: "",
      version: 0,
      permissions: "",
      locale: option.None,
      guild_locale: option.None,
      entitlements: [],
      attachment_size_limit: 0,
      context: dynamic.string(""),
      authorizing_integration_owners: [],
    )
  let command =
    command.chat_input(
      signature: command.signature(name: bad_name, desc: ""),
      opts: [],
      handler: fn(_i, _s, _o) { panic as "should not run" },
    )
  let commands =
    dict.new()
    |> dict.insert(bad_name, command)

  // When
  let res = command.handle_interaction(commands, state, interaction, data)

  // Then
  assert res == Error(expected)
}

pub fn valid_chat_input_group_handle_interaction_test() {
  // Given
  let invoked_name = "test"
  let invoked_subcommand = "subcommand"
  let state = "state"
  let expected = command.MessageWithSource(correct_run)
  let opt_name = "opt"
  let options =
    dict.new()
    |> dict.insert(
      opt_name,
      option_data.StringValue(name: opt_name, value: "", focused: False),
    )
  let data =
    data.ChatInputApplicationCommand(
      id: "",
      name: invoked_name,
      resolved: option.None,
      options: option_data.CommandGroup(
        option_data.GroupSubcommand(option_data.Subcommand(
          invoked_subcommand,
          options:,
        )),
      ),
      guild_id: option.None,
      target_id: option.None,
    )
  let interaction =
    interaction.ApplicationCommand(
      id: "",
      application_id: "",
      data:,
      guild: option.None,
      guild_id: option.None,
      channel: option.None,
      channel_id: option.None,
      member: option.None,
      user: option.None,
      token: "",
      version: 0,
      permissions: "",
      locale: option.None,
      guild_locale: option.None,
      entitlements: [],
      attachment_size_limit: 0,
      context: dynamic.string(""),
      authorizing_integration_owners: [],
    )
  let subcommand =
    command.subcommand(
      signature: command.signature(name: invoked_subcommand, desc: ""),
      opts: [],
      handler: fn(i, s, o) {
        assert i == interaction
        assert s == state
        assert o == options
        expected
      },
    )
  let command =
    command.chat_input_group(invoked_name, "")
    |> command.add_subcommand(subcommand)
  let commands =
    dict.new()
    |> dict.insert(invoked_name, command)

  // When
  let res = command.handle_interaction(commands, state, interaction, data)

  // Then
  assert res == Ok(expected)
}

pub fn invalid_chat_input_group_handle_interaction_test() {
  // Given
  let invoked_name = "test"
  let invoked_subcommand = "subcommand"
  let bad_subcommand = "bad-" <> invoked_subcommand
  let state = "state"
  let expected = Nil
  let opt_name = "opt"
  let options =
    dict.new()
    |> dict.insert(
      opt_name,
      option_data.StringValue(name: opt_name, value: "", focused: False),
    )
  let data =
    data.ChatInputApplicationCommand(
      id: "",
      name: invoked_name,
      resolved: option.None,
      options: option_data.CommandGroup(
        option_data.GroupSubcommand(option_data.Subcommand(
          bad_subcommand,
          options:,
        )),
      ),
      guild_id: option.None,
      target_id: option.None,
    )
  let interaction =
    interaction.ApplicationCommand(
      id: "",
      application_id: "",
      data:,
      guild: option.None,
      guild_id: option.None,
      channel: option.None,
      channel_id: option.None,
      member: option.None,
      user: option.None,
      token: "",
      version: 0,
      permissions: "",
      locale: option.None,
      guild_locale: option.None,
      entitlements: [],
      attachment_size_limit: 0,
      context: dynamic.string(""),
      authorizing_integration_owners: [],
    )
  let subcommand =
    command.subcommand(
      signature: command.signature(name: invoked_subcommand, desc: ""),
      opts: [],
      handler: fn(_i, _s, _o) { panic as "should not run" },
    )
  let command =
    command.chat_input_group(invoked_name, "")
    |> command.add_subcommand(subcommand)
  let commands =
    dict.new()
    |> dict.insert(invoked_name, command)

  // When
  let res = command.handle_interaction(commands, state, interaction, data)

  // Then
  assert res == Error(expected)
}

pub fn valid_chat_input_subcommand_group_handle_interaction_test() {
  // Given
  let invoked_name = "test"
  let invoked_subcommand_group = "subcommand_group"
  let invoked_subcommand = "subcommand"
  let state = "state"
  let expected = command.MessageWithSource(correct_run)
  let opt_name = "opt"
  let options =
    dict.new()
    |> dict.insert(
      opt_name,
      option_data.StringValue(name: opt_name, value: "", focused: False),
    )
  let data =
    data.ChatInputApplicationCommand(
      id: "",
      name: invoked_name,
      resolved: option.None,
      options: option_data.CommandGroup(
        option_data.GroupSubcommandGroup(option_data.SubcommandGroup(
          invoked_subcommand_group,
          option_data.Subcommand(invoked_subcommand, options:),
        )),
      ),
      guild_id: option.None,
      target_id: option.None,
    )
  let interaction =
    interaction.ApplicationCommand(
      id: "",
      application_id: "",
      data:,
      guild: option.None,
      guild_id: option.None,
      channel: option.None,
      channel_id: option.None,
      member: option.None,
      user: option.None,
      token: "",
      version: 0,
      permissions: "",
      locale: option.None,
      guild_locale: option.None,
      entitlements: [],
      attachment_size_limit: 0,
      context: dynamic.string(""),
      authorizing_integration_owners: [],
    )
  let subcommand =
    command.subcommand(
      signature: command.signature(name: invoked_subcommand, desc: ""),
      opts: [],
      handler: fn(i, s, o) {
        assert i == interaction
        assert s == state
        assert o == options
        expected
      },
    )
  let subcommand_group =
    command.subcommand_group(name: invoked_subcommand_group, desc: "", sub: [
      subcommand,
    ])
  let command =
    command.chat_input_group(invoked_name, "")
    |> command.add_subcommand_group(subcommand_group)
  let commands =
    dict.new()
    |> dict.insert(invoked_name, command)

  // When
  let res = command.handle_interaction(commands, state, interaction, data)

  // Then
  assert res == Ok(expected)
}

pub fn invalid_chat_input_subcommand_group_handle_interaction_test() {
  // Given
  let invoked_name = "test"
  let invoked_subcommand_group = "subcommand_group"
  let invoked_subcommand = "subcommand"
  let bad_subcommand = "bad-" <> invoked_subcommand
  let state = "state"
  let expected = Nil
  let opt_name = "opt"
  let options =
    dict.new()
    |> dict.insert(
      opt_name,
      option_data.StringValue(name: opt_name, value: "", focused: False),
    )
  let data =
    data.ChatInputApplicationCommand(
      id: "",
      name: invoked_name,
      resolved: option.None,
      options: option_data.CommandGroup(
        option_data.GroupSubcommandGroup(option_data.SubcommandGroup(
          invoked_subcommand_group,
          option_data.Subcommand(invoked_subcommand, options:),
        )),
      ),
      guild_id: option.None,
      target_id: option.None,
    )
  let interaction =
    interaction.ApplicationCommand(
      id: "",
      application_id: "",
      data:,
      guild: option.None,
      guild_id: option.None,
      channel: option.None,
      channel_id: option.None,
      member: option.None,
      user: option.None,
      token: "",
      version: 0,
      permissions: "",
      locale: option.None,
      guild_locale: option.None,
      entitlements: [],
      attachment_size_limit: 0,
      context: dynamic.string(""),
      authorizing_integration_owners: [],
    )
  let subcommand =
    command.subcommand(
      signature: command.signature(name: bad_subcommand, desc: ""),
      opts: [],
      handler: fn(_i, _s, _o) { panic as "should not run" },
    )
  let subcommand_group =
    command.subcommand_group(name: invoked_subcommand_group, desc: "", sub: [
      subcommand,
    ])
  let command =
    command.chat_input_group(invoked_name, "")
    |> command.add_subcommand_group(subcommand_group)
  let commands =
    dict.new()
    |> dict.insert(invoked_name, command)

  // When
  let res = command.handle_interaction(commands, state, interaction, data)

  // Then
  assert res == Error(expected)
}

pub fn valid_user_handle_interaction_test() {
  // Given
  let invoked_name = "test"
  let state = "state"
  let expected = command.MessageWithSource(correct_run)
  let data =
    data.UserApplicationCommand(
      id: "",
      name: invoked_name,
      resolved: option.None,
      guild_id: option.None,
      target_id: option.None,
    )
  let interaction =
    interaction.ApplicationCommand(
      id: "",
      application_id: "",
      data:,
      guild: option.None,
      guild_id: option.None,
      channel: option.None,
      channel_id: option.None,
      member: option.None,
      user: option.None,
      token: "",
      version: 0,
      permissions: "",
      locale: option.None,
      guild_locale: option.None,
      entitlements: [],
      attachment_size_limit: 0,
      context: dynamic.string(""),
      authorizing_integration_owners: [],
    )
  let command =
    command.user(
      signature: command.signature(name: invoked_name, desc: "test"),
      handler: fn(i, s) {
        assert i == interaction
        assert s == state
        expected
      },
    )
  let commands =
    dict.new()
    |> dict.insert(invoked_name, command)

  // When
  let res = command.handle_interaction(commands, state, interaction, data)

  // Then
  assert res == Ok(expected)
}

pub fn invalid_user_handle_interaction_test() {
  // Given
  let invoked_name = "test"
  let bad_name = "bad-" <> invoked_name
  let state = "state"
  let expected = Nil
  let data =
    data.UserApplicationCommand(
      id: "",
      name: invoked_name,
      resolved: option.None,
      guild_id: option.None,
      target_id: option.None,
    )
  let interaction =
    interaction.ApplicationCommand(
      id: "",
      application_id: "",
      data:,
      guild: option.None,
      guild_id: option.None,
      channel: option.None,
      channel_id: option.None,
      member: option.None,
      user: option.None,
      token: "",
      version: 0,
      permissions: "",
      locale: option.None,
      guild_locale: option.None,
      entitlements: [],
      attachment_size_limit: 0,
      context: dynamic.string(""),
      authorizing_integration_owners: [],
    )
  let command =
    command.user(
      signature: command.signature(name: bad_name, desc: "test"),
      handler: fn(_i, _s) { panic as "should not run" },
    )
  let commands =
    dict.new()
    |> dict.insert(bad_name, command)

  // When
  let res = command.handle_interaction(commands, state, interaction, data)

  // Then
  assert res == Error(expected)
}

pub fn valid_message_handle_interaction_test() {
  // Given
  let invoked_name = "test"
  let state = "state"
  let expected = command.MessageWithSource(correct_run)
  let data =
    data.MessageApplicationCommand(
      id: "",
      name: invoked_name,
      resolved: option.None,
      guild_id: option.None,
      target_id: option.None,
    )
  let interaction =
    interaction.ApplicationCommand(
      id: "",
      application_id: "",
      data:,
      guild: option.None,
      guild_id: option.None,
      channel: option.None,
      channel_id: option.None,
      member: option.None,
      user: option.None,
      token: "",
      version: 0,
      permissions: "",
      locale: option.None,
      guild_locale: option.None,
      entitlements: [],
      attachment_size_limit: 0,
      context: dynamic.string(""),
      authorizing_integration_owners: [],
    )
  let command =
    command.message(
      signature: command.signature(name: invoked_name, desc: "test"),
      handler: fn(i, s) {
        assert i == interaction
        assert s == state
        expected
      },
    )
  let commands =
    dict.new()
    |> dict.insert(invoked_name, command)

  // When
  let res = command.handle_interaction(commands, state, interaction, data)

  // Then
  assert res == Ok(expected)
}

pub fn invalid_message_handle_interaction_test() {
  // Given
  let invoked_name = "test"
  let bad_name = "bad-" <> invoked_name
  let state = "state"
  let expected = Nil
  let data =
    data.MessageApplicationCommand(
      id: "",
      name: invoked_name,
      resolved: option.None,
      guild_id: option.None,
      target_id: option.None,
    )
  let interaction =
    interaction.ApplicationCommand(
      id: "",
      application_id: "",
      data:,
      guild: option.None,
      guild_id: option.None,
      channel: option.None,
      channel_id: option.None,
      member: option.None,
      user: option.None,
      token: "",
      version: 0,
      permissions: "",
      locale: option.None,
      guild_locale: option.None,
      entitlements: [],
      attachment_size_limit: 0,
      context: dynamic.string(""),
      authorizing_integration_owners: [],
    )
  let command =
    command.message(
      signature: command.signature(name: bad_name, desc: "test"),
      handler: fn(_i, _s) { panic as "should not run" },
    )
  let commands =
    dict.new()
    |> dict.insert(bad_name, command)

  // When
  let res = command.handle_interaction(commands, state, interaction, data)

  // Then
  assert res == Error(expected)
}
