import FeatherOpenAPI

extension Analytics.Log.Overview {
    struct RequestBody: JSONRequestBodyRepresentable {
        var openAPIIdentifier: String {
            "AnalyticsLogOverviewRequestBody"
        }
        var description: String? { "Analytics overview query payload" }
        var schema = Schemas.Query().reference()
    }
}
