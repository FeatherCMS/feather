import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct AnalyticsLogOverviewResponse: JSONResponseRepresentable {
    var description: String = "Analytics overview response"
    var schema = AnalyticsLogOverviewSchema().reference()
}
