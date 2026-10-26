import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Analytics.Log.Get {
    struct Operation: Analytics.Log.IdentifiableOperation {
        var operationId: String? { "analyticsLogGet" }
        var responseMap: ResponseMap {
            [
                200: Response().reference(),
                404: CustomResponse(description: "AnalyticsLog not found"),
            ]
        }
    }
}
