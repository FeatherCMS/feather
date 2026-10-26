import FeatherOpenAPI

extension MenuItem.Post {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "MenuItemRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
