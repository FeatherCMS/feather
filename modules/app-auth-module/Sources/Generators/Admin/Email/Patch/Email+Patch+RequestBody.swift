import FeatherOpenAPI

extension Email.Patch {
    struct RequestBody: RequestBodyRepresentable {
        var contentMap: ContentMap {
            [.json: Content(Email.Schemas.Patch().reference())]
        }
    }
}
