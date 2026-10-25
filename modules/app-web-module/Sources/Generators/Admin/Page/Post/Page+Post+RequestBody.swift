import FeatherOpenAPI

extension Page.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "PageRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
