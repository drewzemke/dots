use ../modules/abbrevs.nu *

# pnpm-related abbreviations
add-abbrev p      'pnpm'
add-abbrev pst    'pnpm start'
add-abbrev pv     'pnpm verify'
add-abbrev piso   'pnpm test-isolated'
add-abbrev pint   'pnpm test-integrated'
add-abbrev pintr  'pnpm test-integrated-retry'
add-abbrev pvp    'pnpm verify && git push'
add-abbrev jw     'pnpm jest --watchAll --testPathPattern'

# completion for `pnpm jest`
def list-spec-files [] {
  glob '**/*.spec.{ts,tsx}' --exclude [**/node_modules/** **/.git/**] | each { |f| basename $f }
}

export extern "pnpm jest" [
  file?: string@list-spec-files 
  --watchAll
  --testPathPattern
]

# completion for `pnpm test-integrated` and `pnpm e2e`
# NOTE: expects tests to be in the `e2e` directory
def list-e2e-test-names [] {
  glob 'e2e/**/*.e2e.ts' --exclude [**/node_modules/** **/.git/**]
  | each { |file|
      open $file
      | lines
      | parse --regex ".*test\\('(?<name>.*)'.*"
      | get name
    }
  | flatten
}

export extern "pnpm test-integrated" [
  --grep(-g): string@list-e2e-test-names
  --debug
  --headed
]

export extern "pnpm e2e" [
  --grep?(-g): string@list-e2e-test-names
  --debug
  --headed
]
