import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Analytics.Log.List {
    struct Operation: Analytics.Log.Operation {
        var operationId: String? { "analyticsLogList" }
        var responseMap: ResponseMap {
            [200: AnalyticsLogListResponse().reference()]
        }
    }
}
