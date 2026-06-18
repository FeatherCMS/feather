import FeatherOpenAPI
import SharedOpenAPIComponents

struct RedirectNotFoundOverviewResponse: JSONResponseRepresentable {
    var description: String = "Redirect not found overview response"
    var schema = AnalyticsLogOverviewSchema().reference()
}
