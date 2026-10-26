import FeatherOpenAPI

extension MenuItem.Put {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "MenuItemUpdateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(MenuItem.Post.Schema().reference())]
        }
    }
}
