@export()
type activityLogAlertType = {
  name: string
  operationName: string
}

param activityLogAlertsToCreate activityLogAlertType[]
param tags object
param enableRules bool
param actionGroupId string

resource activityLogAlerts 'Microsoft.Insights/activityLogAlerts@2020-10-01' = [
  for activityLogAlert in activityLogAlertsToCreate: {
    name: activityLogAlert.name
    location: 'global'
    tags: tags
    properties: {
      enabled: enableRules
      actions: {
        actionGroups: [
          {
            actionGroupId: actionGroupId
          }
        ]
      }
      scopes: [
        '/subscriptions/${subscription().subscriptionId}'
      ]
      condition: {
        allOf: [
          {
            field: 'category'
            equals: 'Administrative'
          }
          {
            field: 'operationName'
            equals: activityLogAlert.operationName
          }
        ]
      }
    }
  }
]
