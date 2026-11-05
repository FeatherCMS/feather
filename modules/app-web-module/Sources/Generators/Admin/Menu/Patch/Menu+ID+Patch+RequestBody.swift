import FeatherOpenAPI

extension Menu.ID.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "MenuPatchRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Schema().reference())]
        }
    }
}
