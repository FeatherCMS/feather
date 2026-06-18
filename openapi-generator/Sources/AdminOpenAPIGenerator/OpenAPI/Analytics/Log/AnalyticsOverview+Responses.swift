import FeatherOpenAPI
import SharedOpenAPIComponents

struct AnalyticsLogOverviewResponse: JSONResponseRepresentable {
    var description: String = "Analytics overview response"
    var schema = AnalyticsLogOverviewSchema().reference()
}
