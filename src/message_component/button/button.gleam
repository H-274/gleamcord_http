import message_component/button/interaction_button.{type InteractionButton}

pub type Button(state) {
  Interactive(InteractionButton(state))
  LinkButton(url: String, label: String, disabled: Bool)
  PremiumButton(sku_id: String)
}
