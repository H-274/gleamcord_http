pub type Choice(t) {
  Choice(name: String, name_localizations: List(#(String, String)), value: t)
}

pub fn new(name: String, value: t) -> Choice(t) {
  Choice(name:, name_localizations: [], value:)
}
