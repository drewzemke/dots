# abbreviations
use ../modules/abbrevs.nu *

add-abbrev cb  'cargo build'
add-abbrev cbr 'cargo build --release'
add-abbrev ct  'cargo test'
add-abbrev cr  'cargo run'
add-abbrev crr 'cargo run --release'

# completions
use ../completions/cargo-completions.nu *
