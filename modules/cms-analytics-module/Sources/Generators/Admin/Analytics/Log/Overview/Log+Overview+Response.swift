import FeatherOpenAPI

extension Analytics.Log.Overview {
    struct Response: JSONResponseRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogOverviewResponse" }
        var description: String = "Analytics overview response"
        var schema = Schemas.Schema().reference()
    }
}
