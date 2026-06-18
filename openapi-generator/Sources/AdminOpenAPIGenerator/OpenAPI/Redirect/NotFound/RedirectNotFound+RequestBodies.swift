import FeatherOpenAPI

struct RedirectNotFoundOverviewRequestBody: JSONRequestBodyRepresentable {
    var description: String? { "Redirect not found overview query payload" }
    var schema = AnalyticsLogOverviewQuerySchema().reference()
}
