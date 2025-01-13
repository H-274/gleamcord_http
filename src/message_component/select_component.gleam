import message_component/selectors/channel_select_menu.{type ChannelSelectMenu}
import message_component/selectors/mentionable_select_menu.{
  type MentionableSelectMenu,
}
import message_component/selectors/role_select_menu.{type RoleSelectMenu}
import message_component/selectors/text_select_menu.{type TextSelectMenu}
import message_component/selectors/user_select_menu.{type UserSelectMenu}

pub type SelectComponent(ctx) {
  TextSelector(TextSelectMenu(ctx))
  UserSelectMenu(UserSelectMenu(ctx))
  RoleSelectMenu(RoleSelectMenu(ctx))
  MentionableSelectMenu(MentionableSelectMenu(ctx))
  ChannelSelectMenu(ChannelSelectMenu(ctx))
}
