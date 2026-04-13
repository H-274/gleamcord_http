pub type New {
  NewText(content: String, flags: List(Flag))
  /// TODO replace nil with proper root type
  NewComponent(content: List(Nil), flags: List(Flag))
}

pub type Flag
