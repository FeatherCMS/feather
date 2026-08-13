import FeatherOpenAPI

struct AnalyticsLogOverviewRequestBody: JSONRequestBodyRepresentable {
    var description: String? { "Analytics overview query payload" }
    var schema = AnalyticsLogOverviewQuerySchema().reference()
}
