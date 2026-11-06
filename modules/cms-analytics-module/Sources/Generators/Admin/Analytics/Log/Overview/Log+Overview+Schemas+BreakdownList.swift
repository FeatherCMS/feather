import FeatherOpenAPI

extension Analytics.Log.Overview.Schemas {
    struct BreakdownList: ArraySchemaRepresentable {
        var openAPIIdentifier: String {
            "AnalyticsLogOverviewBreakdownListSchema"
        }
        var items: (any SchemaRepresentable)? {
            BreakdownItem().reference()
        }
    }
}
