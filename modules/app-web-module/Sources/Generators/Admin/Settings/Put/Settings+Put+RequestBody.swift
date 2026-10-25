import FeatherOpenAPI

extension Settings.Put {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "SettingsUpdateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
