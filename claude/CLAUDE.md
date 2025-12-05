## version control

- I personally use `jj` (jujutsu) for local version control, not git.
  - so whenever you need to examine the repo, use jj commands, falling back to git only if the jj commands fail
  - my default `jj log` output is truncated to keep it minimal, so use `jj all` or `jj log -r <something>` when searching history
  - `jj describe` doesn't advance to a new commit, you need to run `jj new` afterwards. `jj commit` does both of those in sequence
- at the end of every major task, you can offer to commit the current work using jj.
- commits should be "atomic," meaning that they are as small as possible while still being consistent and correct
- commit messages must be short and simple, and always follow the commit message pattern from other commits in the same repo
  - you can run `jj all --limit 10` to see a sample of the commit history

## code comments

- keep comments minimal and only add them when necessary to explain nonobvious code
- comments should be short, not capitalized at the beginning, and don't need to be complete sentences

## testing

- write tests before implementation
- after writing or updating tests, check in with me before moving on to the implementation
