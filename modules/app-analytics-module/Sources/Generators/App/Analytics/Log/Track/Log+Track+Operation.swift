import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Analytics.Log.Track {
    struct Operation: OperationRepresentable {
        var operationId: String? { "analyticsLogTrack" }
        var tags: [any TagRepresentable] { [AppAnalyticsLogTag()] }

        var requestBody: (any RequestBodyRepresentable)? {
            AnalyticsLogTrackRequestBody().reference()
        }

        var responseMap: ResponseMap {
            [
                204: NoContentResponse(description: "Analytics log tracked")
            ]
        }
    }
}
