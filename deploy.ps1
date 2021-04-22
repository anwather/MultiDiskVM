Param($DeploymentFile, $TemplateFile)

New-AzResourceGroup -Name deploy -Location 'Australia East' -Force

$inputFile = Get-Content $DeploymentFile | ConvertFrom-Json

$params = @{
    ComputerName       = $inputFile.computerName
    VirtualNetworkName = $inputFile.virtualNetworkName
    numberOfDataDisks  = $inputFile.numberOfDisks
    diskSizeArray      = $inputFile.sizeOfDisks
}

New-AzResourceGroupDeployment -ResourceGroupName deploy -TemplateFile $TemplateFile -TemplateParameterObject $params -Verbose