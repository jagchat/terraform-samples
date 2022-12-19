$nowPath = (Get-Location).Path
cd .\tf-state
del ./.terraform -Force -Recurse -ErrorAction SilentlyContinue
del .terraform.lock.hcl -ErrorAction SilentlyContinue
del terraform.tfstate* -ErrorAction SilentlyContinue
del init.tfplan -ErrorAction SilentlyContinue
del logs.txt -ErrorAction SilentlyContinue
cd $nowPath