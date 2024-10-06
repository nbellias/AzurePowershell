az login

# Variables
$myResourceGroup="nikosb-az204-rg"

# Delete the resource group
az group delete --name $myResourceGroup --yes

Write-Host "Press any key to exit..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")