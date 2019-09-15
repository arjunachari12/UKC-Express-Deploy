# Deploy UKC Using Terraform

1. Download *UKC_unbound.tf* and *UKC_variables.tf* files from this repo.

2. Edit *UKC_variables.tf*. Replace every *"!!!!!! replace it with ......... !!!!!!"* string by the relevant value.

## Launch UKC
1. Start Terraform.
   ```
   $ terraform init
   ```
2. Do something.
   ```
   $ terraform apply demo.plan -no-color | tee demo.apply.out 2>&1
   ```
3. Do something else.
   ```
   $ terraform plan -out=demo.plan -no-color --var "provide_ssh=true" | tee demo.plan.out
   ```

## Terminate UKC
Use this command to terminate UKC.
   ```
   $ terraform destroy -auto-approve --var "provide_ssh=true"
   ```

`--var "provide_ssh=true"` can be set to *false*. In this case, SSH private keys for access to UKC Partner and Aux will only be uploaded to the bastion host. If the parameter is not be used in command line, the user will be prompted to input the value.
