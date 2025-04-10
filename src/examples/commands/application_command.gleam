import interaction/application_command

pub fn chat_input_command() {
  let def =
    application_command.new_definition(
      name: "Hello",
      desc: "world",
      integs: [Nil],
      contexts: [Nil],
    )

  let params = []

  use _i, _params, _bot <- application_command.chat_input_command(def, params)
  todo
}
