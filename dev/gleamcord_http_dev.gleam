import example/commands
import gleamcord_http

pub fn main() {
  echo gleamcord_http.command_dicts([
    commands.utils_tree,
  ])
}
