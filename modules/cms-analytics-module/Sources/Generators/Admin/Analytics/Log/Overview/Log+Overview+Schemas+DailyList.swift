import FeatherOpenAPI

extension Analytics.Log.Overview.Schemas {
    struct DailyList: ArraySchemaRepresentable {
        var openAPIIdentifier: String {
            "AnalyticsLogOverviewDailyListSchema"
        }
        var items: (any SchemaRepresentable)? {
            DailyPoint().reference()
        }
    }
}
