import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct PathCollection: PathCollectionRepresentable {

    var pathMap: PathMap {
        [
            "api/v1/admin/analytics/logs/":
                AnalyticsLogListPathItems(),
            "api/v1/admin/analytics/logs/overview":
                AnalyticsLogOverviewPathItems(),
            "api/v1/admin/analytics/logs/search": AnalyticsLogSearchPathItems(),
            "api/v1/admin/analytics/logs/{id}": AnalyticsLogIdPathItems(),
        ]
    }
}
