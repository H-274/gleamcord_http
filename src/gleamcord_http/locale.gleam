import gleam/dict.{type Dict}

pub type Locale

pub fn to_string(locale: Locale) {
  todo
}

pub type Translator =
  fn(String) -> Dict(Locale, String)
