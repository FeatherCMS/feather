import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Analytics.Log.Get {
    struct Operation: Analytics.Log.IdentifiableOperation {
        var operationId: String? { "analyticsLogGet" }
        var responseMap: ResponseMap {
            [
                200: AnalyticsLogDetailResponse().reference(),
                404: CustomResponse(description: "AnalyticsLog not found"),
            ]
        }
    }
}
