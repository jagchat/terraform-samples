$env:TF_LOG_CORE = 'TRACE'
$env:TF_LOG_PROVIDER = 'TRACE'
$env:TF_LOG_PATH = 'logs.txt'

$nowPath = (Get-Location).Path
cd .\tf-state
terraform destroy
cd $nowPath

$env:TF_LOG_CORE = $null
$env:TF_LOG_PROVIDER = $null
$env:TF_LOG_PATH = $null