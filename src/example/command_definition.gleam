import definition

pub fn message_command() {
  use <- definition.message_command(name: "Quote", locales: [])

  "Successfully quoted"
}

pub fn user_command() {
  use <- definition.user_command(name: "Ping", locales: [])

  "Successfully pinged"
}

pub fn hello_world() {
  use <- definition.text_command(
    name: "hello_world",
    params: [],
    name_locales: [],
    desc: "Says `Hello World!`",
    desc_locales: [],
  )

  "Hello World!"
}

pub fn hello_name() {
  let name_param = Nil

  use <- definition.text_command(
    name: "hello",
    params: [name_param],
    name_locales: [],
    desc: "Greets the given name",
    desc_locales: [],
  )

  "Hello" <> "name"
}

pub fn info() {
  definition.command_group(name: "info", name_locales: [], sub_commands: [
    info_channel(),
    info_guild(),
  ])
}

pub fn info_channel() {
  use <- definition.sub_command(
    name: "channel",
    params: [],
    name_locales: [],
    desc: "info about the current channel",
    desc_locales: [],
  )

  "Some pertinent info about the channel"
}

pub fn info_guild() {
  use <- definition.sub_command(
    name: "channel",
    params: [],
    name_locales: [],
    desc: "info about the current channel",
    desc_locales: [],
  )

  "Some pertinent info about the guild"
}
