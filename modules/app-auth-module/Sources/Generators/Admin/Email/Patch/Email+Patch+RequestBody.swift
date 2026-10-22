import FeatherOpenAPI

extension Email.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var openAPIIdentifier: String { "AuthEmailPatchRequestBody" }
        var contentMap: ContentMap {
            [.json: Content(Email.Patch.Schema().reference())]
        }
    }
}
