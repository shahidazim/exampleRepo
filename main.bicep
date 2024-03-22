// Scope
targetScope = 'subscription'

@minLength(3)
@maxLength(11)
param storagePrefix string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'

var location = 'westus'
var environmentName = 'test'
var resourceGroupName = 'exampleRG'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'exampleRG'
  location: location
  tags: {
    environmentName: environmentName
  }
}

var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup.id)}'

resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  scope: resourceGroup
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

output storageEndpoint object = stg.properties.primaryEndpoints
