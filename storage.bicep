// Scope
targetScope = 'resourceGroup'

// Parameters
@description('Azure region to deploy the function into.')
param location string = resourceGroup().location

@description('The storage account name.')
param name string

// Resources
resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    defaultToOAuthAuthentication: true
    allowBlobPublicAccess: false
    networkAcls: {
      defaultAction: 'Deny'
    }
    minimumTlsVersion: 'TLS1_2'
  }
  tags: resourceGroup().tags
}

resource storageRetention 'Microsoft.Storage/storageAccounts/blobServices@2019-06-01' = {
  parent: storage
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      enabled: true
      days: 14
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 14
    }
  }
}

// Outputs
output name string = storage.name
