import FeatherOpenAPI

extension Analytics.Log {
    struct Tag: TagRepresentable {
        var name: String = "AnalyticsLogs"
        var description: String? = "Manage analytics logs."
    }
}
