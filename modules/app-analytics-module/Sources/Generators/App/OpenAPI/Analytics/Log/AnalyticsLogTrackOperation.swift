import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AnalyticsLogTrackOperation: OperationRepresentable {
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
