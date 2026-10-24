import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Analytics.Log.List {
    struct Operation: Analytics.Log.Operation {
        var operationId: String? { "analyticsLogList" }
        var responseMap: ResponseMap {
            [200: AnalyticsLogListResponse().reference()]
        }
    }
}
