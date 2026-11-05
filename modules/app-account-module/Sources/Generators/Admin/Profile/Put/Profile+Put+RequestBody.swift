import FeatherOpenAPI

extension Profile.Put {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AccountProfileUpdateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
