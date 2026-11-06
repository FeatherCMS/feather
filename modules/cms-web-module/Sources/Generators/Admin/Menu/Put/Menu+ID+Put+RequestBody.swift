import FeatherOpenAPI

extension Menu.ID.Put {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "MenuUpdateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Menu.Post.Schema().reference())]
        }
    }
}
