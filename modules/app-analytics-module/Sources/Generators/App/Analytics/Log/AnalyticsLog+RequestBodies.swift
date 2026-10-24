import FeatherOpenAPI

struct AnalyticsLogTrackRequestBody: RequestBodyRepresentable {

    var contentMap: ContentMap {
        [
            .json: Content(AppAnalyticsLogTrackSchema().reference())
        ]
    }
}
