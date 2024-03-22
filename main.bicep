// Scope
targetScope = 'subscription'

// Parameters
@description('The environment name that is being deployed')
param environmentName string

@description('The Azure location to deploy resources into')
param location string = 'uksouth'

// Variables
var workload = 'images'
var imageStorageName = 'sa${workload}${environmentName}${take(location, 3)}001'

// Resources
resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: 'rg-${workload}-${environmentName}-${location}-001'
  location: location
  tags: {
    environmentName: environmentName
  }
}

// Modules
module imageStorage 'storage.bicep' = {
  name: take('${uniqueString(deployment().name, location)}-${workload}-${environmentName}-imagestorage', 64)
  scope: resourceGroup
  params: {
    name: imageStorageName
    location: location
  }
}

