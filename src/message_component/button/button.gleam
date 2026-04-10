import message_component/button/interactive_button.{type InteractiveButton}

pub type Button(state) {
  Interactive(InteractiveButton(state))
  LinkButton(url: String, label: String, disabled: Bool)
  PremiumButton(sku_id: String)
}
