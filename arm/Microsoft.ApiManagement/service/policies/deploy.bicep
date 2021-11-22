@description('Required. The name of the of the Api Management service.')
param apiManagementServiceName string

@description('Optional. Customer Usage Attribution id (GUID). This GUID must be previously registered')
param cuaId string = ''

@description('Optional. Format of the policyContent.')
@allowed([
  'rawxml'
  'rawxml-link'
  'xml'
  'xml-link'
])
param format string = 'xml'

@description('Required. Contents of the Policy as defined by the format.')
param value string

module pid_cuaId '.bicep/nested_cuaId.bicep' = if (!empty(cuaId)) {
  name: 'pid-${cuaId}'
  params: {}
}

resource policy 'Microsoft.ApiManagement/service/policies@2020-06-01-preview' = {
  name: '${apiManagementServiceName}/policy'
  properties: {
    format: format
    value: value
  }
}

@description('The resourceId of the API management service policy')
output policyResourceId string = policy.id

@description('The name of the API management service policy')
output policyName string = policy.name

@description('The resource group the API management service policy was deployed into')
output policyResourceGroup string = resourceGroup().name