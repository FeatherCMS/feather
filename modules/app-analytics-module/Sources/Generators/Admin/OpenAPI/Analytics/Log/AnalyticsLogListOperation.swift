import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AnalyticsLogListOperation: AnalyticsLogOperation {
    var responseMap: ResponseMap {
        [
            200: AnalyticsLogListResponse().reference()
        ]
    }
}
