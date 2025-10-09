use ../modules/tokens.nu load-token
use ../modules/abbrevs.nu add-abbrev

if $env.DREW_AT_WORK {
  $env.AWS_PROFILE = 'staging'
  
  load-token GITHUB_TOKEN    .github_token
  load-token JIRA_API_TOKEN  .jira_token
  load-token COPILOT_API_KEY .copilot

  add-abbrev kstage 'k9s --context=aws-staging'
  add-abbrev kqa    'k9s --context=aws-qa'
  add-abbrev kprod  'k9s --context=aws-prod'
}
