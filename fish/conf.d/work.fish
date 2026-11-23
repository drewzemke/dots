test "$DREW_AT_WORK" = 1; or return

set -gx AWS_PROFILE staging

load_token GITHUB_TOKEN .github_token
load_token JIRA_API_TOKEN .jira_token
load_token COPILOT_API_KEY .copilot

abbr -a kstage  'kubectl --context=aws-staging'
abbr -a kprod   'kubectl --context=aws-prod'
abbr -a ks      'kubectl --context=aws-staging'
abbr -a kp      'kubectl --context=aws-prod'

abbr -a Kstage 'k9s --context=aws-staging'
abbr -a Kprod  'k9s --context=aws-prod'
abbr -a Ks     'k9s --context=aws-staging'
abbr -a Kp     'k9s --context=aws-prod'
