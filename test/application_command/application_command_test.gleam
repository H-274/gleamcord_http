import application_command/application_command as command
import application_command/chat_input
import application_command/chat_input_group
import application_command/interaction
import application_command/message_command
import application_command/option_value
import application_command/response
import application_command/signature
import application_command/user_command
import gleam/dict
import gleam/dynamic
import gleam/option
import message

pub fn valid_chat_input_handle_interaction_test() {
  // Given
  let expected = response.MessageWithSource("success" |> message.NewText([]))
  let invoked = "command"
  let interaction =
    interaction.Interaction(
      "",
      "",
      interaction.ChatInput(interaction.ChatInputData(
        "",
        invoked,
        option.None,
        option_value.Values(dict.new()),
        option.None,
        option.None,
      )),
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      "",
      0,
      "",
      option.None,
      option.None,
      [],
      [],
      dynamic.int(0),
      0,
    )
  let commands =
    dict.new()
    |> dict.insert(
      invoked,
      command.from_chat_input(
        chat_input.new(signature.new(invoked, ""), [], fn(_, _, _) { expected }),
      ),
    )

  // When
  let result = command.handle_interaction(commands, Nil, interaction)

  // Then
  assert result == Ok(expected)
}

pub fn invalid_chat_input_handle_interaction_test() {
  // Given
  let expected = Nil
  let invoked = "command"
  let interaction =
    interaction.Interaction(
      "",
      "",
      interaction.ChatInput(interaction.ChatInputData(
        "",
        invoked,
        option.None,
        option_value.Values(dict.new()),
        option.None,
        option.None,
      )),
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      "",
      0,
      "",
      option.None,
      option.None,
      [],
      [],
      dynamic.int(0),
      0,
    )
  let commands =
    dict.new()
    |> dict.insert(
      invoked <> "bad",
      command.from_chat_input(
        chat_input.new(signature.new(invoked <> "bad", ""), [], fn(_, _, _) {
          panic as "should not run"
        }),
      ),
    )

  // When
  let result = command.handle_interaction(commands, Nil, interaction)

  // Then
  assert result == Error(expected)
}

pub fn valid_chat_input_subcommand_handle_interaction_test() {
  // Given
  let expected = response.MessageWithSource("success" |> message.NewText([]))
  let invoked = "command"
  let invoked_subcommand = "subcommand"
  let interaction =
    interaction.Interaction(
      "",
      "",
      interaction.ChatInput(interaction.ChatInputData(
        "",
        invoked,
        option.None,
        option_value.Group(
          option_value.Subcommand(option_value.SubcommandValue(
            invoked_subcommand,
            dict.new(),
          )),
        ),
        option.None,
        option.None,
      )),
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      "",
      0,
      "",
      option.None,
      option.None,
      [],
      [],
      dynamic.int(0),
      0,
    )
  let commands =
    dict.new()
    |> dict.insert(
      invoked,
      command.from_chat_input_group(
        chat_input_group.new(invoked, "", [
          chat_input_group.subcommand(
            chat_input.new(
              signature.new(invoked_subcommand, ""),
              [],
              fn(_, _, _) { expected },
            ),
          ),
        ]),
      ),
    )

  // When
  let result = command.handle_interaction(commands, Nil, interaction)

  // Then
  assert result == Ok(expected)
}

pub fn invalid_chat_input_subcommand_handle_interaction_test() {
  // Given
  let expected = Nil
  let invoked = "command"
  let invoked_subcommand = "subcommand"
  let interaction =
    interaction.Interaction(
      "",
      "",
      interaction.ChatInput(interaction.ChatInputData(
        "",
        invoked,
        option.None,
        option_value.Group(
          option_value.Subcommand(option_value.SubcommandValue(
            invoked_subcommand,
            dict.new(),
          )),
        ),
        option.None,
        option.None,
      )),
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      "",
      0,
      "",
      option.None,
      option.None,
      [],
      [],
      dynamic.int(0),
      0,
    )
  let commands =
    dict.new()
    |> dict.insert(
      invoked,
      command.from_chat_input_group(
        chat_input_group.new(invoked, "", [
          chat_input_group.subcommand(
            chat_input.new(
              signature.new(invoked_subcommand <> "bad", ""),
              [],
              fn(_, _, _) { panic as "should not run" },
            ),
          ),
        ]),
      ),
    )

  // When
  let result = command.handle_interaction(commands, Nil, interaction)

  // Then
  assert result == Error(expected)
}

pub fn valid_chat_input_subcommand_group_handle_interaction_test() {
  // Given
  let expected = response.MessageWithSource("success" |> message.NewText([]))
  let invoked = "command"
  let invoked_subcommand_group = "group"
  let invoked_subcommand = "subcommand"
  let interaction =
    interaction.Interaction(
      "",
      "",
      interaction.ChatInput(interaction.ChatInputData(
        "",
        invoked,
        option.None,
        option_value.Group(
          option_value.SubcommandGroup(option_value.SubcommandGroupValue(
            invoked_subcommand_group,
            option_value.SubcommandValue(invoked_subcommand, dict.new()),
          )),
        ),
        option.None,
        option.None,
      )),
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      "",
      0,
      "",
      option.None,
      option.None,
      [],
      [],
      dynamic.int(0),
      0,
    )
  let commands =
    dict.new()
    |> dict.insert(
      invoked,
      command.from_chat_input_group(
        chat_input_group.new(invoked, "", [
          chat_input_group.subcommand_group(invoked_subcommand_group, "", [
            chat_input.new(
              signature.new(invoked_subcommand, ""),
              [],
              fn(_, _, _) { expected },
            ),
          ]),
        ]),
      ),
    )

  // When
  let result = command.handle_interaction(commands, Nil, interaction)

  // Then
  assert result == Ok(expected)
}

pub fn invalid_chat_input_subcommand_group_handle_interaction_test() {
  // Given
  let expected = Nil
  let invoked = "command"
  let invoked_subcommand_group = "group"
  let invoked_subcommand = "subcommand"
  let interaction =
    interaction.Interaction(
      "",
      "",
      interaction.ChatInput(interaction.ChatInputData(
        "",
        invoked,
        option.None,
        option_value.Group(
          option_value.SubcommandGroup(option_value.SubcommandGroupValue(
            invoked_subcommand_group,
            option_value.SubcommandValue(invoked_subcommand, dict.new()),
          )),
        ),
        option.None,
        option.None,
      )),
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      "",
      0,
      "",
      option.None,
      option.None,
      [],
      [],
      dynamic.int(0),
      0,
    )
  let commands =
    dict.new()
    |> dict.insert(
      invoked,
      command.from_chat_input_group(
        chat_input_group.new(invoked, "", [
          chat_input_group.subcommand_group(invoked_subcommand_group, "", [
            chat_input.new(
              signature.new(invoked_subcommand <> "bad", ""),
              [],
              fn(_, _, _) { panic as "should not run" },
            ),
          ]),
        ]),
      ),
    )

  // When
  let result = command.handle_interaction(commands, Nil, interaction)

  // Then
  assert result == Error(expected)
}

pub fn valid_user_handle_interaction_test() {
  // Given
  let expected = response.MessageWithSource("success" |> message.NewText([]))
  let invoked = "command"
  let interaction =
    interaction.Interaction(
      "",
      "",
      interaction.User(interaction.UserData(
        "",
        invoked,
        option.None,
        option.None,
        option.None,
      )),
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      "",
      0,
      "",
      option.None,
      option.None,
      [],
      [],
      dynamic.int(0),
      0,
    )
  let commands =
    dict.new()
    |> dict.insert(
      invoked,
      command.from_user(
        user_command.new(signature.new(invoked, ""), fn(_, _) { expected }),
      ),
    )

  // When
  let result = command.handle_interaction(commands, Nil, interaction)

  // Then
  assert result == Ok(expected)
}

pub fn invalid_user_handle_interaction_test() {
  // Given
  let expected = Nil
  let invoked = "command"
  let interaction =
    interaction.Interaction(
      "",
      "",
      interaction.User(interaction.UserData(
        "",
        invoked,
        option.None,
        option.None,
        option.None,
      )),
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      "",
      0,
      "",
      option.None,
      option.None,
      [],
      [],
      dynamic.int(0),
      0,
    )
  let commands =
    dict.new()
    |> dict.insert(
      invoked <> "bad",
      command.from_user(
        user_command.new(signature.new(invoked <> "bad", ""), fn(_, _) {
          panic as "should not run"
        }),
      ),
    )

  // When
  let result = command.handle_interaction(commands, Nil, interaction)

  // Then
  assert result == Error(expected)
}

pub fn valid_message_handle_interaction_test() {
  // Given
  let expected = response.MessageWithSource("success" |> message.NewText([]))
  let invoked = "command"
  let interaction =
    interaction.Interaction(
      "",
      "",
      interaction.Message(interaction.MessageData(
        "",
        invoked,
        option.None,
        option.None,
        option.None,
      )),
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      "",
      0,
      "",
      option.None,
      option.None,
      [],
      [],
      dynamic.int(0),
      0,
    )
  let commands =
    dict.new()
    |> dict.insert(
      invoked,
      command.from_message(
        message_command.new(signature.new(invoked, ""), fn(_, _) { expected }),
      ),
    )

  // When
  let result = command.handle_interaction(commands, Nil, interaction)

  // Then
  assert result == Ok(expected)
}

pub fn invalid_message_handle_interaction_test() {
  // Given
  let expected = Nil
  let invoked = "command"
  let interaction =
    interaction.Interaction(
      "",
      "",
      interaction.Message(interaction.MessageData(
        "",
        invoked,
        option.None,
        option.None,
        option.None,
      )),
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      option.None,
      "",
      0,
      "",
      option.None,
      option.None,
      [],
      [],
      dynamic.int(0),
      0,
    )
  let commands =
    dict.new()
    |> dict.insert(
      invoked <> "bad",
      command.from_message(
        message_command.new(signature.new(invoked <> "bad", ""), fn(_, _) {
          panic as "should not run"
        }),
      ),
    )

  // When
  let result = command.handle_interaction(commands, Nil, interaction)

  // Then
  assert result == Error(expected)
}
