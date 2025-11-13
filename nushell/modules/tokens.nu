# loads a token into the env from a file
# expects `file_name` to be a file in the home directory
export def --env load-token [token_name, file_name] {
  if ($env has $token_name) {
    return 
  }
  
  let file_path = $env.HOME | path join $file_name
  { $token_name: (cat $file_path) } | load-env
}

