# aws-login abbreviation
alias aws-login='aws-adfs login --profile default --adfs-ca-bundle ~/.aws/sectigo.cer --authfile ~/.aws-login --duo-factor "Duo Push" && aws-adfs login --profile cross-account --adfs-ca-bundle ~/.aws/sectigo.cer --authfile ~/.aws-login --duo-factor "Duo Push"'
