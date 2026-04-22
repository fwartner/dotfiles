# Terraform / OpenTofu / Pulumi (conditional on installed tools)

(( ${+commands[terraform]} )) && alias tf='terraform'
(( ${+commands[opentofu]} )) && alias tofu='opentofu'
(( ${+commands[packer]} )) && alias pf='packer'

# Terraform shortcuts (only when terraform exists)
if (( ${+commands[terraform]} )); then
  tfi() {
    terraform init "$@"
  }
  tfp() {
    terraform plan "$@"
  }
  tfa() {
    terraform apply "$@"
  }
fi
