import message_component/selectors/channel_select_menu.{type ChannelSelectMenu}
import message_component/selectors/mentionable_select_menu.{
  type MentionableSelectMenu,
}
import message_component/selectors/role_select_menu.{type RoleSelectMenu}
import message_component/selectors/text_select_menu.{type TextSelectMenu}
import message_component/selectors/user_select_menu.{type UserSelectMenu}

/// TODO
pub type Response {
  JsonString(String)
}

/// TODO
pub type Error {
  NotImplemented
}

/// TODO
pub type Data {
  Data
}

pub type SelectComponent(ctx) {
  TextSelector(TextSelectMenu(ctx, Data, Response, Error))
  UserSelectMenu(UserSelectMenu(ctx, Data, Response, Error))
  RoleSelectMenu(RoleSelectMenu(ctx, Data, Response, Error))
  MentionableSelectMenu(MentionableSelectMenu(ctx, Data, Response, Error))
  ChannelSelectMenu(ChannelSelectMenu(ctx, Data, Response, Error))
}
