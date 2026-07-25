pub type Type {
  GuildText
  DM
  GuildVoice
  GroupDM
  GuildCategory
  GuildAnnouncement
  AnnouncementThread
  PublicThread
  PrivateThread
  GuildStageVoice
  GuildDirectory
  GuildForum
  GuildMedia
}

pub fn type_to_id(typ: Type) {
  case typ {
    GuildText -> 0
    DM -> 1
    GuildVoice -> 2
    GroupDM -> 3
    GuildCategory -> 4
    GuildAnnouncement -> 5
    AnnouncementThread -> 10
    PublicThread -> 11
    PrivateThread -> 12
    GuildStageVoice -> 13
    GuildDirectory -> 14
    GuildForum -> 15
    GuildMedia -> 16
  }
}
