module completions {

  export extern ut [
    --help(-h)                # Print help
  ]

  def "nu-complete ut completions shell" [] {
    [ "bash" "elvish" "fish" "powershell" "zsh" "nushell" ]
  }

  # Generate shell completions for ut
  export extern "ut completions" [
    shell: string@"nu-complete ut completions shell"
    --help(-h)                # Print help (see more with '--help')
  ]

  # Base64 encode and decode utilities
  export extern "ut base64" [
    --help(-h)                # Print help
  ]

  # Base64 encode contents
  export extern "ut base64 encode" [
    text: string              # Input to encode (use "-" for stdin)
    --urlsafe                 # Encode with urlsafe character set
    --help(-h)                # Print help
  ]

  # Base64 decode contents
  export extern "ut base64 decode" [
    text: string              # Input to decode (use "-" for stdin)
    --urlsafe                 # Decode with urlsafe character set
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut base64 help" [
  ]

  # Base64 encode contents
  export extern "ut base64 help encode" [
  ]

  # Base64 decode contents
  export extern "ut base64 help decode" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut base64 help help" [
  ]

  # bcrypt hashing and verification utilities
  export extern "ut bcrypt" [
    --help(-h)                # Print help
  ]

  # Hash a password using bcrypt
  export extern "ut bcrypt hash" [
    password: string          # Password to hash
    --cost(-c): string        # Cost factor (4-31, default: 12). Higher values are more secure but slower
    --help(-h)                # Print help
  ]

  # Verify a password against a bcrypt hash
  export extern "ut bcrypt verify" [
    password: string          # Password to verify
    hash: string              # Bcrypt hash to verify against
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut bcrypt help" [
  ]

  # Hash a password using bcrypt
  export extern "ut bcrypt help hash" [
  ]

  # Verify a password against a bcrypt hash
  export extern "ut bcrypt help verify" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut bcrypt help help" [
  ]

  # Expression calculator with math functions
  export extern "ut calc" [
    expression: string        # Expression to evaluate Supports arithmetic, functions, constants, and multiple number formats
    --help(-h)                # Print help
  ]

  # Convert text between different case formats
  export extern "ut case" [
    --help(-h)                # Print help
  ]

  # Convert text to lowercase
  export extern "ut case lower" [
    text: string              # Text to convert
    --help(-h)                # Print help
  ]

  # Convert text to UPPERCASE
  export extern "ut case upper" [
    text: string              # Text to convert
    --help(-h)                # Print help
  ]

  # Convert text to camelCase
  export extern "ut case camel" [
    text: string              # Text to convert
    --help(-h)                # Print help
  ]

  # Convert text to Title Case
  export extern "ut case title" [
    text: string              # Text to convert
    --help(-h)                # Print help
  ]

  # Convert text to CONSTANT_CASE
  export extern "ut case constant" [
    text: string              # Text to convert
    --help(-h)                # Print help
  ]

  # Convert text to Header-Case
  export extern "ut case header" [
    text: string              # Text to convert
    --help(-h)                # Print help
  ]

  # Convert text to sentence case
  export extern "ut case sentence" [
    text: string              # Text to convert
    --help(-h)                # Print help
  ]

  # Convert text to snake_case
  export extern "ut case snake" [
    text: string              # Text to convert
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut case help" [
  ]

  # Convert text to lowercase
  export extern "ut case help lower" [
  ]

  # Convert text to UPPERCASE
  export extern "ut case help upper" [
  ]

  # Convert text to camelCase
  export extern "ut case help camel" [
  ]

  # Convert text to Title Case
  export extern "ut case help title" [
  ]

  # Convert text to CONSTANT_CASE
  export extern "ut case help constant" [
  ]

  # Convert text to Header-Case
  export extern "ut case help header" [
  ]

  # Convert text to sentence case
  export extern "ut case help sentence" [
  ]

  # Convert text to snake_case
  export extern "ut case help snake" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut case help help" [
  ]

  # Color utilities
  export extern "ut color" [
    --help(-h)                # Print help
  ]

  # Convert colors between different formats
  export extern "ut color convert" [
    color: string             # Color value in any supported format (hex, rgb, rgba, hsl, hwb, cmyk, lch, oklch)
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut color help" [
  ]

  # Convert colors between different formats
  export extern "ut color help convert" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut color help help" [
  ]

  # Cron utilities for scheduling and parsing
  export extern "ut crontab" [
    --help(-h)                # Print help
  ]

  # Parse crontab expression and show upcoming firing times
  export extern "ut crontab schedule" [
    expression: string        # Crontab expression (e.g., "0 9 * * 1-5" for weekdays at 9 AM, or "0 0 9 * * 1-5" for extended format)
    --count(-n): string       # Number of upcoming firing times to show (default: 5)
    --after(-a): string       # Calculate firing times after this time (ISO 8601 format, defaults to now)
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut crontab help" [
  ]

  # Parse crontab expression and show upcoming firing times
  export extern "ut crontab help schedule" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut crontab help help" [
  ]

  # Parse and convert datetime to different timezones
  export extern "ut datetime" [
    datetime: string          # DateTime value to parse
    --source-timezone(-s): string # Input timezone to use when parsing datetime without timezone info (overrides any timezone in the input)
    --target-timezone(-t): string # Target timezone to convert to (e.g., "America/New_York", "UTC", "Asia/Tokyo")
    --parse-format(-f): string
    --help(-h)                # Print help (see more with '--help')
  ]

  # Compare text contents
  export extern "ut diff" [
    --a(-a): path             # First version of the file, omit to use editor
    --b(-b): path             # Second version of the file, omit to use editor
    --help(-h)                # Print help
  ]

  # Generate hash digests using various algorithms
  export extern "ut hash" [
    --help(-h)                # Print help
  ]

  # Generate MD5 hash
  export extern "ut hash md5" [
    input: string             # Input to hash (use "-" for stdin)
    --help(-h)                # Print help
  ]

  # Generate SHA-1 hash
  export extern "ut hash sha1" [
    input: string             # Input to hash (use "-" for stdin)
    --help(-h)                # Print help
  ]

  # Generate SHA-224 hash
  export extern "ut hash sha224" [
    input: string             # Input to hash (use "-" for stdin)
    --help(-h)                # Print help
  ]

  # Generate SHA-256 hash
  export extern "ut hash sha256" [
    input: string             # Input to hash (use "-" for stdin)
    --help(-h)                # Print help
  ]

  # Generate SHA-384 hash
  export extern "ut hash sha384" [
    input: string             # Input to hash (use "-" for stdin)
    --help(-h)                # Print help
  ]

  # Generate SHA-512 hash
  export extern "ut hash sha512" [
    input: string             # Input to hash (use "-" for stdin)
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut hash help" [
  ]

  # Generate MD5 hash
  export extern "ut hash help md5" [
  ]

  # Generate SHA-1 hash
  export extern "ut hash help sha1" [
  ]

  # Generate SHA-224 hash
  export extern "ut hash help sha224" [
  ]

  # Generate SHA-256 hash
  export extern "ut hash help sha256" [
  ]

  # Generate SHA-384 hash
  export extern "ut hash help sha384" [
  ]

  # Generate SHA-512 hash
  export extern "ut hash help sha512" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut hash help help" [
  ]

  # HTTP status codes and their descriptions
  export extern "ut http" [
    --help(-h)                # Print help
  ]

  # Look up HTTP status codes
  export extern "ut http status" [
    code?: string             # HTTP status code to lookup (omit to list all)
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut http help" [
  ]

  # Look up HTTP status codes
  export extern "ut http help status" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut http help help" [
  ]

  # JSON utilities
  export extern "ut json" [
    --help(-h)                # Print help
  ]

  # Build JSON from key-value pairs with dot notation and array support
  export extern "ut json builder" [
    ...inputs: string         # Key-value pairs in the format key=value (e.g., a.b.c=hello, "a.b[].c"=1 or "a.b[2].c"=false)
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut json help" [
  ]

  # Build JSON from key-value pairs with dot notation and array support
  export extern "ut json help builder" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut json help help" [
  ]

  # Generate lorem ipsum text
  export extern "ut lorem" [
    --paragraphs(-p): string  # Number of paragraphs to generate
    --min-sentences: string   # Minimum number of sentences per paragraph
    --max-sentences: string   # Maximum number of sentences per paragraph
    --min-words: string       # Minimum number of words per sentence
    --max-words: string       # Maximum number of words per sentence
    --help(-h)                # Print help
  ]

  # Resolve escaped newlines and tab characters
  export extern "ut pretty-print" [
    text?: string             # Text to unescape. Use "-" to read from stdin, or omit to open editor
    --help(-h)                # Print help
  ]

  # Generate QR codes
  export extern "ut qr" [
    text: string              # The text or URL to encode as QR code
    --output(-o): path        # Save QR code to file (PNG format)
    --help(-h)                # Print help
  ]

  # Generate random numbers within specified range
  export extern "ut random" [
    --count(-c): string       # Number of random numbers to generate
    --min: string             # Minimum value (inclusive)
    --max: string             # Maximum value (inclusive)
    --step(-s): string        # Step value for precision (e.g., 0.01 for 2 decimal places)
    --help(-h)                # Print help
  ]

  # Interactive regex tester
  export extern "ut regex" [
    --test(-t): path          # File to load test string content from
    --help(-h)                # Print help
  ]

  # Start a local HTTP file server
  export extern "ut serve" [
    --directory(-d): path     # Path to the directory to serve
    --port(-p): string        # Port number the server should listen to
    --host: string            # Host address the server should bind to
    --auth: string            # Authentication credentials (username:password)
    --help(-h)                # Print help
  ]

  # Generate a cryptographically secure random token.
  export extern "ut token" [
    --length(-l): string      # Length of the token to generate
    --no-uppercase            # Do not include uppercase letters
    --no-lowercase            # Do not include lowercase letters
    --no-numbers              # Do not include numbers
    --no-symbols              # Do not include symbols
    --help(-h)                # Print help
  ]

  # URL encode and decode utilities
  export extern "ut url" [
    --help(-h)                # Print help
  ]

  # URL encode text
  export extern "ut url encode" [
    text: string              # Text to URL encode
    --help(-h)                # Print help
  ]

  # URL decode text
  export extern "ut url decode" [
    text: string              # Text to URL decode
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut url help" [
  ]

  # URL encode text
  export extern "ut url help encode" [
  ]

  # URL decode text
  export extern "ut url help decode" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut url help help" [
  ]

  # Generate UUIDs
  export extern "ut uuid" [
    --help(-h)                # Print help
  ]

  # Generate UUID v1 (timestamp-based)
  export extern "ut uuid v1" [
    --count(-c): string       # Number of UUIDs to generate
    --help(-h)                # Print help
  ]

  def "nu-complete ut uuid v3 namespace" [] {
    [ "dns" "url" "oid" "x500" ]
  }

  # Generate UUID v3 (namespace + MD5 hash)
  export extern "ut uuid v3" [
    --namespace(-n): string@"nu-complete ut uuid v3 namespace" # Namespace to use
    --name(-N): string        # Name to hash
    --count(-c): string       # Number of UUIDs to generate
    --help(-h)                # Print help (see more with '--help')
  ]

  # Generate UUID v4 (random)
  export extern "ut uuid v4" [
    --count(-c): string       # Number of UUIDs to generate
    --help(-h)                # Print help
  ]

  def "nu-complete ut uuid v5 namespace" [] {
    [ "dns" "url" "oid" "x500" ]
  }

  # Generate UUID v5 (namespace + SHA-1 hash)
  export extern "ut uuid v5" [
    --namespace(-n): string@"nu-complete ut uuid v5 namespace" # Namespace to use
    --name(-N): string        # Name to hash
    --count(-c): string       # Number of UUIDs to generate
    --help(-h)                # Print help (see more with '--help')
  ]

  # Generate UUID v7 (timestamp-based, sortable)
  export extern "ut uuid v7" [
    --count(-c): string       # Number of UUIDs to generate
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut uuid help" [
  ]

  # Generate UUID v1 (timestamp-based)
  export extern "ut uuid help v1" [
  ]

  # Generate UUID v3 (namespace + MD5 hash)
  export extern "ut uuid help v3" [
  ]

  # Generate UUID v4 (random)
  export extern "ut uuid help v4" [
  ]

  # Generate UUID v5 (namespace + SHA-1 hash)
  export extern "ut uuid help v5" [
  ]

  # Generate UUID v7 (timestamp-based, sortable)
  export extern "ut uuid help v7" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut uuid help help" [
  ]

  # Unicode symbol reference
  export extern "ut unicode" [
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut help" [
  ]

  # Generate shell completions for ut
  export extern "ut help completions" [
  ]

  # Base64 encode and decode utilities
  export extern "ut help base64" [
  ]

  # Base64 encode contents
  export extern "ut help base64 encode" [
  ]

  # Base64 decode contents
  export extern "ut help base64 decode" [
  ]

  # bcrypt hashing and verification utilities
  export extern "ut help bcrypt" [
  ]

  # Hash a password using bcrypt
  export extern "ut help bcrypt hash" [
  ]

  # Verify a password against a bcrypt hash
  export extern "ut help bcrypt verify" [
  ]

  # Expression calculator with math functions
  export extern "ut help calc" [
  ]

  # Convert text between different case formats
  export extern "ut help case" [
  ]

  # Convert text to lowercase
  export extern "ut help case lower" [
  ]

  # Convert text to UPPERCASE
  export extern "ut help case upper" [
  ]

  # Convert text to camelCase
  export extern "ut help case camel" [
  ]

  # Convert text to Title Case
  export extern "ut help case title" [
  ]

  # Convert text to CONSTANT_CASE
  export extern "ut help case constant" [
  ]

  # Convert text to Header-Case
  export extern "ut help case header" [
  ]

  # Convert text to sentence case
  export extern "ut help case sentence" [
  ]

  # Convert text to snake_case
  export extern "ut help case snake" [
  ]

  # Color utilities
  export extern "ut help color" [
  ]

  # Convert colors between different formats
  export extern "ut help color convert" [
  ]

  # Cron utilities for scheduling and parsing
  export extern "ut help crontab" [
  ]

  # Parse crontab expression and show upcoming firing times
  export extern "ut help crontab schedule" [
  ]

  # Parse and convert datetime to different timezones
  export extern "ut help datetime" [
  ]

  # Compare text contents
  export extern "ut help diff" [
  ]

  # Generate hash digests using various algorithms
  export extern "ut help hash" [
  ]

  # Generate MD5 hash
  export extern "ut help hash md5" [
  ]

  # Generate SHA-1 hash
  export extern "ut help hash sha1" [
  ]

  # Generate SHA-224 hash
  export extern "ut help hash sha224" [
  ]

  # Generate SHA-256 hash
  export extern "ut help hash sha256" [
  ]

  # Generate SHA-384 hash
  export extern "ut help hash sha384" [
  ]

  # Generate SHA-512 hash
  export extern "ut help hash sha512" [
  ]

  # HTTP status codes and their descriptions
  export extern "ut help http" [
  ]

  # Look up HTTP status codes
  export extern "ut help http status" [
  ]

  # JSON utilities
  export extern "ut help json" [
  ]

  # Build JSON from key-value pairs with dot notation and array support
  export extern "ut help json builder" [
  ]

  # Generate lorem ipsum text
  export extern "ut help lorem" [
  ]

  # Resolve escaped newlines and tab characters
  export extern "ut help pretty-print" [
  ]

  # Generate QR codes
  export extern "ut help qr" [
  ]

  # Generate random numbers within specified range
  export extern "ut help random" [
  ]

  # Interactive regex tester
  export extern "ut help regex" [
  ]

  # Start a local HTTP file server
  export extern "ut help serve" [
  ]

  # Generate a cryptographically secure random token.
  export extern "ut help token" [
  ]

  # URL encode and decode utilities
  export extern "ut help url" [
  ]

  # URL encode text
  export extern "ut help url encode" [
  ]

  # URL decode text
  export extern "ut help url decode" [
  ]

  # Generate UUIDs
  export extern "ut help uuid" [
  ]

  # Generate UUID v1 (timestamp-based)
  export extern "ut help uuid v1" [
  ]

  # Generate UUID v3 (namespace + MD5 hash)
  export extern "ut help uuid v3" [
  ]

  # Generate UUID v4 (random)
  export extern "ut help uuid v4" [
  ]

  # Generate UUID v5 (namespace + SHA-1 hash)
  export extern "ut help uuid v5" [
  ]

  # Generate UUID v7 (timestamp-based, sortable)
  export extern "ut help uuid v7" [
  ]

  # Unicode symbol reference
  export extern "ut help unicode" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "ut help help" [
  ]

}

export use completions *
