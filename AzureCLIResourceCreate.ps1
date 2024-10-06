az login
az account set --subscription c763400f-30cd-4299-9030-c555f8891223

# Variables
$RANDOM = Get-Random -Minimum 1 -Maximum 10000
$myLocation="westeurope"
$myResourceGroup="nikosb-az204-rg"
$myAppContainerEnvironment="nikosb-az204-env-" + $RANDOM
$myContainerApp="nikosb-az204-app-" + $RANDOM
$myAppContEnvLogAnalyticsWkspc="nikosb-az204-loganalytics-" + $RANDOM

# Create a resource group
az group create --name $myResourceGroup --location $myLocation

# Create a container app
$workspaceOutput = az monitor log-analytics workspace create --name $myAppContEnvLogAnalyticsWkspc --resource-group $myResourceGroup --output json | ConvertFrom-Json
$workspaceId = $workspaceOutput.id
$keysOutput = az monitor log-analytics workspace get-shared-keys `
    --resource-group $myResourceGroup `
    --workspace-name $myAppContEnvLogAnalyticsWkspc `
    --output json | ConvertFrom-Json
$primarySharedKey = $keysOutput.primarySharedKey
az containerapp env create --name $myAppContainerEnvironment --resource-group $myResourceGroup --location $myLocation --logs-workspace-id $workspaceId --logs-workspace-key $primarySharedKey
az containerapp create --name $myContainerApp --resource-group $myResourceGroup --environment $myAppContainerEnvironment --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest --target-port 80 --ingress 'external' --query properties.configuration.ingress.fqdn

Write-Host "Press any key to exit..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
