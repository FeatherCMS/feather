import FeatherOpenAPI

extension Settings.Put {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AccountSettingsUpdateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
