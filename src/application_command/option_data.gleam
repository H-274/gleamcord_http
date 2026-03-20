pub type OptionData {
  StringValue(name: String, value: String, focused: Bool)
  IntegerValue(name: String, value: Int, focused: Bool)
  BooleanValue(name: String, value: Bool, focused: Bool)
  UserValue(name: String, value: Int, focused: Bool)
  ChannelValue(name: String, value: Int, focused: Bool)
  RoleValue(name: String, value: Int, focused: Bool)
  MentionableValue(name: String, value: Int, focused: Bool)
  NumberValue(name: String, value: Float, focused: Bool)
  AttachmentValue(name: String, value: Int, focused: Bool)
}
