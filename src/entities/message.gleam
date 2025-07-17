pub type Create {
  Create(
    content: String,
    tts: Bool,
    // TODO
    embeds: List(Nil),
    // TODO
    allowed_mentions: List(Nil),
    // TODO
    message_reference: Nil,
    sticker_ids: List(String),
    // TODO
    files: List(Nil),
    // TODO
    attachments: List(Nil),
    // TODO
    flags: List(Nil),
    // TODO
    poll: Nil,
  )
}

pub type Edit {
  Edit(
    content: String,
    tts: Bool,
    // TODO
    embeds: List(Nil),
    // TODO
    allowed_mentions: List(Nil),
    // TODO
    message_reference: Nil,
    sticker_ids: List(String),
    // TODO
    files: List(Nil),
    // TODO
    attachments: List(Nil),
    // TODO
    flags: List(Nil),
    // TODO
    poll: Nil,
  )
}

pub fn create_default() -> Create {
  Create("", False, [], [], Nil, [], [], [], [], Nil)
}

pub fn edit_default() -> Edit {
  Edit("", False, [], [], Nil, [], [], [], [], Nil)
}
