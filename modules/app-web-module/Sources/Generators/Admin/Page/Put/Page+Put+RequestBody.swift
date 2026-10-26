import FeatherOpenAPI

extension Page.Put {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "PageUpdateRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Page.Patch.Schema().reference())]
        }
    }
}
