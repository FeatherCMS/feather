import FeatherOpenAPI

extension Menu.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "MenuRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
