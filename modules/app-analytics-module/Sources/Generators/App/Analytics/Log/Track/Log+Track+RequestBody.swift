import FeatherOpenAPI

extension Analytics.Log.Track {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AnalyticsLogTrackRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
