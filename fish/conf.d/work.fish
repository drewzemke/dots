test "$DREW_AT_WORK" = 1; or return

set -gx AWS_PROFILE staging

load_token GITHUB_TOKEN .github_token
load_token JIRA_API_TOKEN .jira_token
load_token COPILOT_API_KEY .copilot

abbr -a kstage 'k9s --context=aws-staging'
abbr -a kqa 'k9s --context=aws-qa'
abbr -a kprod 'k9s --context=aws-prod'
