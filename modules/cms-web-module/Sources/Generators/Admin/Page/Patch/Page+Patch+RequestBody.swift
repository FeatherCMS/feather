import FeatherOpenAPI

extension Page.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "PagePatchRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
