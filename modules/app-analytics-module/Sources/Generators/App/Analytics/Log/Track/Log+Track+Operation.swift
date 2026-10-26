import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Analytics.Log.Track {
    struct Operation: OperationRepresentable {
        var operationId: String? { "analyticsLogTrack" }
        var tags: [any TagRepresentable] { [Analytics.Log.Tag()] }

        var requestBody: (any RequestBodyRepresentable)? {
            RequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                204: NoContentResponse(description: "Analytics log tracked")
            ]
        }
    }
}
