# pnpm abbreviations
abbr -a -- p      'pnpm'
abbr -a -- pst    'pnpm start'
abbr -a -- pv     'pnpm verify'
abbr -a -- piso   'pnpm test-isolated'
abbr -a -- pint   'pnpm test-integrated'
abbr -a -- pintr  'pnpm test-integrated-retry'
abbr -a -- pvp    'pnpm verify && git push'
abbr -a -- jw     'pnpm jest --watchAll --testPathPattern'

# add PNPM_HOME env var and path
set -gx PNPM_HOME "/Users/drewzee/Library/pnpm"
fish_add_path -p PNPM_HOME
