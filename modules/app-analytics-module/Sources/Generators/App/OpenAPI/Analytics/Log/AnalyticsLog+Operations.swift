import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AppAnalyticsLogTag: TagRepresentable {
    var name: String = "Analytics"
    var description: String = "Frontend analytics operations"
}

struct AnalyticsLogTrackOperation: OperationRepresentable {
    var tags: [any TagRepresentable] { [AppAnalyticsLogTag()] }

    var requestBody: (any RequestBodyRepresentable)? {
        AnalyticsLogTrackRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "Analytics log tracked")
        ]
    }
}
