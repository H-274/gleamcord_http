import message_component/buttons/link_button.{type LinkButton}
import message_component/buttons/premium_button.{type PremiumButton}
import message_component/buttons/styled_button.{type StyledButton}

pub type ButtonComponent(ctx) {
  Styled(StyledButton(ctx))
  Link(LinkButton)
  Premium(PremiumButton)
}
