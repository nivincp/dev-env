terraform init
terraform init -reconfigure

terraform fmt
terraform validate

terraform plan -var-file=staging.tfvars
terraform apply -var-file=staging.tfvars

terraform plan -destroy -var-file=staging.tfvars
terraform destroy -var-file=staging.tfvars

# generate a clean, shareable plan
terraform plan -var-file=staging.tfvars -out=tfplan
terraform show -no-color tfplan > plan.txt

terraform apply tfplan
terraform output

terraform state list

# If apply fails halfway, safe recovery steps:
terraform refresh -var-file=staging.tfvars
terraform plan -var-file=staging.tfvars
terraform apply -var-file=staging.tfvars
