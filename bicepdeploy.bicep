param virtualNetworkName string
param computerName string
param numberOfDataDisks int
param diskSizeArray array

var nicName_var = '${computerName}-nic'

resource virtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: resourceGroup().location
  tags: {}
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource nicName 'Microsoft.Network/networkInterfaces@2019-11-01' = {
  name: nicName_var
  location: resourceGroup().location
  tags: {}
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, 'default')
          }
        }
      }
    ]
  }
  dependsOn: [
    virtualNetworkName_resource
  ]
}

resource computerName_resource 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: computerName
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS2_v2'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicName.id
        }
      ]
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter-Core-smalldisk'
        version: 'latest'
      }
      dataDisks: [for j in range(0, numberOfDataDisks): {
        lun: j
        createOption: 'Empty'
        diskSizeGB: diskSizeArray[j]
      }]
    }
    osProfile: {
      computerName: computerName
      adminUsername: 's-admin'
      adminPassword: 'P@ssword01'
      windowsConfiguration: {}
    }
  }
  dependsOn: [
    virtualNetworkName_resource
  ]
}