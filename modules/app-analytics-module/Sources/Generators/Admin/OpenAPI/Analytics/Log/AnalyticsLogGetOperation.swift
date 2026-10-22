import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AnalyticsLogGetOperation: AnalyticsLogIDOperation {
    var responseMap: ResponseMap {
        [
            200: AnalyticsLogDetailResponse().reference(),
            404: CustomResponse(description: "AnalyticsLog not found"),
        ]
    }
}
