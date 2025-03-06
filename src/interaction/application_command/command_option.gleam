import interaction/application_command/command_param.{type CommandParam}

pub type CommandOption {
  SubCommandGroup(name: String, options: List(CommandOption))
  SubCommand(name: String, options: List(CommandOption))
  Param(CommandParam)
}

pub fn to_param(option: CommandOption) -> Result(CommandParam, Nil) {
  case option {
    Param(param) -> Ok(param)
    _ -> Error(Nil)
  }
}
