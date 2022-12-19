$env:TF_LOG_CORE = 'TRACE'
$env:TF_LOG_PROVIDER = 'TRACE'
$env:TF_LOG_PATH = 'logs.txt'

$nowPath = (Get-Location).Path
cd .\tf-state
terraform init
terraform validate
terraform plan -out init.tfplan
terraform apply "init.tfplan"
cd $nowPath

$env:TF_LOG_CORE = $null
$env:TF_LOG_PROVIDER = $null
$env:TF_LOG_PATH = $null