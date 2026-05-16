import command/command.{type Command}
import gleam/dict.{type Dict}
import message_component/message_component.{type MessageComponent}
import modal/modal.{type Modal}

pub opaque type Bot(state) {
  Bot(
    app_id: String,
    pub_key: String,
    token: String,
    state: state,
    commands: Dict(String, Command(state)),
    components: Dict(String, MessageComponent(state)),
    modals: Dict(String, Modal(state)),
  )
}

pub fn new(
  app_id app_id: String,
  pub_key pub_key: String,
  token token: String,
  state state: state,
) {
  Bot(
    app_id:,
    pub_key:,
    token:,
    state:,
    commands: dict.new(),
    components: dict.new(),
    modals: dict.new(),
  )
}

pub fn get_key(bot: Bot(_)) {
  bot.pub_key
}
