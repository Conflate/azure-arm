# Linux VM from Custom Image
Deploy VM from a Managed Disks captured image


### Deployed Resources
- Microsoft.Compute/virtualMachines
- Microsoft.Network/publicIPAddresses
- Microsoft.Network/virtualNetworks
- Microsoft.Network/networkSecurityGroups
- Microsoft.Network/networkInterfaces


### Parameters
- `vmName`: The name and hostname of the VM 
- `imageName`: The name of the custom VM image 
- `vmSize`: Size of the VM to deploy 
- `username`: User name for the VM admin account 
- `sshKey`: SSH RSA public key for the VM admin account 


### Outputs
- `publicIp`: Public IP of new VM
- `sshCommand`: Command to SSH onto VM


### Quick Deploy
[![deploy](https://raw.githubusercontent.com/benc-uk/azure-arm/master/etc/azuredeploy.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbenc-uk%2Fazure-arm%2Fmaster%2Fiaas-linux-vm%2Fcustom-img%2Fazuredeploy.json)

### Notes

