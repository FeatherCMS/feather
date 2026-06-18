import FeatherOpenAPI
import OpenAPIKit30

struct AnalyticsLogTrackRequestBody: RequestBodyRepresentable {

    var contentMap: ContentMap {
        [
            .json: Content(AppAnalyticsLogTrackSchema().reference())
        ]
    }
}
