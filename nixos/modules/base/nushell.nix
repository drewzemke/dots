{ unstable, ... }:

{
  # installed for scripts, not as login shell
  environment.systemPackages = [ unstable.nushell ];
}
