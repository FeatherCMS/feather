import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Analytics.Log.Overview {
    struct Operation: Analytics.Log.Operation {
        var operationId: String? { "analyticsLogOverview" }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [200: Response().reference()]
        }
    }
}
