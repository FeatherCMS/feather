import FeatherOpenAPI

extension Analytics.Log.Schemas {
    struct AccountID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogAccountIdField" }
        var example: String? = "account-01"
    }
}
