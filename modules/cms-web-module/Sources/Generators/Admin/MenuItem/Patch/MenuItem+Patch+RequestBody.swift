import FeatherOpenAPI

extension MenuItem.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "MenuItemPatchRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
