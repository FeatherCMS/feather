import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Analytics.Log.Overview {
    struct Operation: Analytics.Log.Operation {
        var operationId: String? { "analyticsLogOverview" }

        var requestBody: (any RequestBodyRepresentable)? {
            AnalyticsLogOverviewRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [200: AnalyticsLogOverviewResponse().reference()]
        }
    }
}
