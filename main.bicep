targetScope = 'subscription'

import { activityLogAlertType } from './activityLogAlert.bicep'

@description('The resource ID of the Action Group to use for the Activity Log alerts. All alerts will use the same action group.')
param actionGroupId string
@description('The location of the resource group, if required. Alerts will be created with global scope.')
param location string

param tags object = {}
param deploymentTime string = utcNow()
param enableRules bool = true

@description('The resource group where to create the alerts. The resource group will be created if it doesn\'t already exist.')
param resourceGroupName string = 'Default-ActivityLogAlerts'

@description('The Activity Log alerts to create. The default value creates the alerts required for compliance with version 14.4.0 of the Azure built-in HITRUST/HIPAA policy initiative.')
param activityLogAlertsToCreate activityLogAlertType[] = [
  {
    name: 'Create or Update Azure SQL server firewall rule'
    operationName: 'Microsoft.Sql/servers/firewallRules/write'
  }
  {
    name: 'Delete Azure SQL server firewall rule'
    operationName: 'Microsoft.Sql/servers/firewallRules/delete'
  }
  {
    name: 'Create or Update Network Security Group'
    operationName: 'Microsoft.Network/networkSecurityGroups/write'
  }
  {
    name: 'Delete Network Security Group'
    operationName: 'Microsoft.Network/networkSecurityGroups/delete'
  }
  {
    name: 'Create or Update NSG Security Rule'
    operationName: 'Microsoft.Network/networkSecurityGroups/securityRules/write'
  }

  { name: 'Delete NSG Security Rule', operationName: 'Microsoft.Network/networkSecurityGroups/securityRules/delete' }
  {
    name: 'Create or Update Classic Network Security Group'
    operationName: 'Microsoft.ClassicNetwork/networkSecurityGroups/write'
  }
  {
    name: 'Delete Classic Network Security Group'
    operationName: 'Microsoft.ClassicNetwork/networkSecurityGroups/delete'
  }
  {
    name: 'Create or Update Classic NSG Security Rule'
    operationName: 'Microsoft.ClassicNetwork/networkSecurityGroups/securityRules/write'
  }
  {
    name: 'Delete Classic NSG Security Rule'
    operationName: 'Microsoft.ClassicNetwork/networkSecurityGroups/securityRules/delete'
  }
]

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

module activityLogAlertsModule './activityLogAlert.bicep' = {
  name: 'activityLogAlerts-${deploymentTime}'
  scope: resourceGroup
  params: {
    activityLogAlertsToCreate: activityLogAlertsToCreate
    enableRules: enableRules
    actionGroupId: actionGroupId
    tags: tags
  }
}
