pub opaque type PremiumButton {
  PremiumButton(sku_id: String, disabled: Bool)
}

pub fn new_premium(sku_id: String) {
  PremiumButton(sku_id:, disabled: False)
}

pub fn premium_disabled(button: PremiumButton) {
  PremiumButton(..button, disabled: True)
}
