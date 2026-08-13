import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AppAnalyticsLogTag: TagRepresentable {
    var name: String = "Analytics"
    var description: String = "Frontend analytics operations"
}

struct AnalyticsLogTrackOperation: OperationRepresentable {
    var tags: [TagRepresentable] { [AppAnalyticsLogTag()] }

    var requestBody: RequestBodyRepresentable? {
        AnalyticsLogTrackRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "Analytics log tracked")
        ]
    }
}
